import torch
import numpy as np
import dependence_measures
import os
import toy_tasks
from tqdm import tqdm
# =============================================================================
# from argparse import ArgumentParser
# from fastargs import get_current_config
# from fastargs.decorators import param
# from fastargs import Param, Section
# from fastargs.validation import And, OneOf
# =============================================================================
enable_cuda = True
device = torch.device('cuda' if torch.cuda.is_available() and enable_cuda else 'cpu')


def run_task(ppvalue=0.0,n_points = 200, n_xy_points = 200,n_zy_points = 200, device=device, dim=2,  kernel_x = 'gaussian', kernel_yx = 'gaussian', kernel_z= 'gaussian', kernel_yz= 'gaussian', kernel_yx_args= {'sigma2': 1.0, 'n': 3},
             kernel_x_args = {'sigma2': 1.0},kernel_yz_args = {'sigma2': 1.0}, kernel_z_args = {'sigma2': 1.0},
             param_dict_yz={'sigma2': torch.tensor([0.5, 1.0, 2.0, 5.0])}, param_dict_yx = {'sigma2': torch.tensor([0.5, 1.0, 2.0, 5.0])},
             *, task='get_xzy_randn_nl', ground_truth='H1', measure = 'kci_xsplit', xzy_holdout_sampling='joint',  rbpt_c=0.1, rbpt_gamma=0.01, rbpt_seed=1,
             pval_estimation='wild', n_data_resamples=1, n_holdout_resamples=1000, n_points_wild_bootstrap=500):
    get_xzy = getattr(toy_tasks, task)
    biased = pval_estimation == 'wild'
    p_accepted_h0 = torch.zeros(n_holdout_resamples, n_data_resamples)

    for idx_ho_sample in tqdm(range(n_holdout_resamples)):
        if xzy_holdout_sampling == 'joint':
            x_ho, z_ho, y_ho_z = get_xzy(n_zy_points, ground_truth, dim, device=device,
                                         c=rbpt_c, gamma=rbpt_gamma, seed=rbpt_seed,pppp=ppvalue)
            y_ho_x = y_ho_z.clone()
            z_ho_x = z_ho.clone()
        elif xzy_holdout_sampling == 'separate':
            _, z_ho, y_ho_z = get_xzy(n_zy_points, ground_truth, dim, device=device,
                                      c=rbpt_c, gamma=rbpt_gamma,pppp=ppvalue)

            x_ho, z_ho_x, y_ho_x = get_xzy(n_xy_points, ground_truth, dim, device=device,
                                           c=rbpt_c, gamma=rbpt_gamma,pppp=ppvalue)
        else:
            raise NotImplementedError(f'xzy_holdout_sampling={xzy_holdout_sampling} has to be joint or separate')

        if get_xzy == toy_tasks.get_xzy_randn_nl:
            kernel_x_args['sigma2'] = (x_ho.norm(dim=1) ** 2).mean()
            kernel_z_args['sigma2'] = (z_ho.norm(dim=1) ** 2).mean()
        elif get_xzy == toy_tasks.get_xzy_rbpt:
            kernel_x_args['sigma2'] = 1
            kernel_z_args['sigma2'] = 1

        if 'circe' in measure:
            kci = dependence_measures.CirceMeasure(kernel_x, kernel_z, kernel_yz,
                                                   kernel_yz_args, kernel_z_args, kernel_x_args,
                                                   biased=biased)
        elif 'kci' in measure:
            kci = dependence_measures.KCIMeasure(kernel_x, kernel_yx, kernel_z, kernel_yz,
                                                 kernel_yx_args, kernel_x_args, kernel_yz_args, kernel_z_args,
                                                 biased=biased)
        elif measure == 'gcm':
            kci = dependence_measures.GCMMeasure(kernel_yx, kernel_yz,
                                                 kernel_yx_args, kernel_yz_args)
        elif measure == 'rbpt2' or measure == 'rbpt2_ub':
            if isinstance(kernel_yx, list):
                kci = dependence_measures.RBPT2Measure(kernel_w='gaussian', kernel_y=kernel_yx,
                                                       kernel_w_args={'sigma2': 1.0},
                                                       kernel_y_args=kernel_yx_args)
            else:
                kci = dependence_measures.RBPT2Measure(kernel_w='linear', kernel_y=kernel_yx,
                                                       kernel_w_args={'n': 1}, kernel_y_args=kernel_yx_args)
        elif measure == 'rbpt2_linreg_w':
            kci = dependence_measures.RBPT2Measure(kernel_w='linreg', kernel_y=kernel_yx,
                                                   kernel_w_args={'sigma2': 1.0},
                                                   kernel_y_args=kernel_yx_args)
        else:
            raise NotImplementedError(f'measure={measure} has to be kci/circe or variations')

        kci.find_regressors(x_ho, z_ho, y_z=y_ho_z, param_dict_yz=param_dict_yz, verbose=False,
                            cpu_solver=True, y_x=y_ho_x, param_dict_yx=param_dict_yx,
                            half_split_yx_estimator='xsplit' in measure or 'xzsplit' in measure,
                            half_split_yz_estimator='zsplit' in measure,
                            z_x=z_ho_x, param_dict_rbpt_w=param_dict_yz if isinstance(kernel_yx, list) else None,
                            param_dict_rbpt_y=param_dict_yx)
        for idx_sample in range(n_data_resamples):
            x, z, y = get_xzy(n_points, ground_truth, dim, device=device,
                              rbpt_c=rbpt_c, rbpt_gamma=rbpt_gamma, seed=rbpt_seed,pppp=ppvalue)

            if measure == 'gcm':
                kci_val, sigma_half = kci.compute_statistic(x, z, y)

                p_accepted_h0[idx_ho_sample, idx_sample] = \
                    kci.compute_pval(kci_val, sigma_half, n_samples=n_points_wild_bootstrap)
            elif 'rbpt2' in measure:
                kci_val = kci.compute_statistic(x, z, y)

                p_accepted_h0[idx_ho_sample, idx_sample] = kci.compute_pval(kci_val)
            else:
                kci_val, K, L = kci.compute_statistic(x, z, y, return_matrices=True)

                p_accepted_h0[idx_ho_sample, idx_sample] = \
                    kci.compute_pval(kci_val, pval_approx_type=pval_estimation, K=K, L=L,
                                     n_samples=n_points_wild_bootstrap)
    p_val_list = p_accepted_h0
    # return torch.mean((p_val_list < 0.05).float()).item()
    return p_val_list




        

index = 0
n=600
for ppi in [0.05,0.10,0.15,0.20,0.25]:
    for fd in [1,2,3,4]:
      testsset = [300,221,86,41,24]
      
      adjpval = [0.00,0.004,0.032,0.0459]
      pppaaa=ppi
      n_test = testsset[(fd-1)]
      n_train = n-n_test  
      p_val_mx_temp = np.zeros((1000, 1)) # (number of p_values, number of different n)
      np.random.seed(0)
      torch.manual_seed(0)
      p_val_list_temp = run_task(ppvalue = pppaaa,n_points = n_test, n_xy_points = n_train,n_zy_points = n_train)
      if fd==1:
          emp_rej_rate = torch.mean((p_val_list_temp <= adjpval[(fd-1)]).float()).item()
      else:
          emp_rej_rate = torch.mean((p_val_list_temp < adjpval[(fd-1)]).float()).item()
      print("finish p = {}, fd = {}, emp rej rate for 5% is {}".format(ppi,fd, emp_rej_rate))
      p_val_mx_temp[:, 0] = p_val_list_temp.reshape(-1).cpu().numpy()
      np.savetxt('./power_p_val_mx_n_'+ str(n) +'_fd_' + str(fd)+'_ppvalue_' + str(pppaaa)  +'.csv', p_val_mx_temp, delimiter=",")
        



##fd in 1,2,3,4,5 is n test to the power of 1,1.1,1.4,1.7,2

######n=200,600,1000,1600,2000
#test1 = 100,300,500,800,1000

#test2 = 79, 221,357,555,685
  
#test3 = 38, 86, 126,179,211
  
#test4 = 21, 41, 56 ,75, 85
  
#test5 = 14, 24, 31, 40, 44























# p_val_mx will have 1000 columns and 5 rows