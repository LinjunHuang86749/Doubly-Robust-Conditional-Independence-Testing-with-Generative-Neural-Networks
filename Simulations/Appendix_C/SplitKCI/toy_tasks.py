import torch
import numpy as np
import torch.distributions as TD

enable_cuda = True
device = torch.device('cuda' if torch.cuda.is_available() and enable_cuda else 'cpu')

__all__ = [
    'get_xzy_randn', 'get_xzy_circ', 'get_xzy_rbpt', 'get_xzy_randn_nl'
]


def get_xzy_randn(n_points, ground_truth='H0', dim=2, device='cuda:0', **ignored):
    y = torch.randn(n_points, dim, device=device)
    y /= torch.norm(y, dim=1, keepdim=True)

    noise = 0.1 * torch.randn(n_points, dim, device=device) / np.sqrt(dim)
    z = y + noise
    x = y.clone()

    if ground_truth == 'H1':
        x[:, 0] += noise[:, 0]
        x[:, 1:] += 0.1 * torch.randn_like(x[:, 1:], device=device) / np.sqrt(dim)
    elif ground_truth == 'H0':
        x += 0.1 * torch.randn_like(x) / np.sqrt(dim)
    else:
        raise NotImplementedError(f'{ground_truth} has to be H0 or H1')

    return x, z, y


def get_xzy_circ(n_points, ground_truth='H0', dim=2, device='cuda:0', **ignored):
    y = torch.randn(n_points, dim, device=device)
    y /= torch.norm(y, dim=1, keepdim=True)

    noise = 0.1 * torch.randn(n_points, dim, device=device) / np.sqrt(dim)
    z = y + noise

    if ground_truth == 'H1':
        x = y.clone()
        x[:, 0] += noise[:, 0]
        x[:, 1:] = 0.1 * torch.randn_like(x[:, 1:]) / np.sqrt(dim)
    elif ground_truth == 'H0':
        noise2 = 0.1 * torch.randn(n_points, dim, device=device) / np.sqrt(dim)
        x = y + noise2
    else:
        raise NotImplementedError(f'{ground_truth} has to be H0 or H1')

    y[y[:, 0] > 0] = 2 * y[y[:, 0] > 0]
    y[y[:, 1] < 0] = 0.5 * y[y[:, 1] < 0]

    return x, z, y


def get_xzy_rbpt(n_points, ground_truth='H0', dim=40, device='cuda:0', c=0.1, gamma=0.01,  **ignored):

    b = torch.tensor([0.3, 1.0]).to(device) # torch.randn(size=(dim, 1), generator=param_generator, device=device)

    y = torch.randn(size=(n_points, 2), device=device)
    z = torch.randn(size=(n_points, 1), device=device)  + (y @ b).reshape(-1, 1)
    x = torch.randn(size=(n_points, 1), device=device)  +  (y @ b).reshape(-1, 1)

    if ground_truth == 'H1':
         x += c * z
    elif ground_truth == 'H0':
        pass
    else:
        raise NotImplementedError(f'{ground_truth} has to be H0 or H1')

    return x , z , y


def get_xzy_randn_nl(n_points, ground_truth='H0',dim=2, device='cuda:0', pppp = 0.0, **ignored):
    y = torch.randn(n_points, dim, device=device) / np.sqrt(dim)
    m = TD.Bernoulli(torch.tensor([pppp]))
    delta = m.sample((n_points,)).to(device)

    noise_z = 0.1 * torch.randn(n_points, dim, device=device) / np.sqrt(dim)
    z = y + noise_z
    x = y.clone()

    if ground_truth == 'H1':
        x = x + (1 - delta) * (0.1* torch.randn_like(x) / np.sqrt(dim)) + delta * noise_z
    elif ground_truth == 'H0':
        x = x + (0.1* torch.randn_like(x) / np.sqrt(dim))
    else:
        raise NotImplementedError(f'{ground_truth} has to be H0 or H1')



    return x, z, y