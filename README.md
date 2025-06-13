# Doubly Robust Conditional Independence Testing with Generative Neural Networks

This repository contains the code and implementation details for the manuscript  
**"Doubly Robust Conditional Independence Testing with Generative Neural Networks."**

---

## Repository Overview

The project is organized into two main parts:

### 1. Simulations/  
Contains code for the following sections of the paper:  
`Section_4_1`, `Section_4_2`, `Section_4_3`, `Appendix_B`, `Appendix_C`, `Appendix_D`, and `Appendix_E`.

### 2. Real_Data_Applications/  
Contains code for the following sections of the paper:  
`Section_5_1`, `Section_5_2`, and `Appendix_F`.

Each folder includes code and a corresponding `README.md` file that provides detailed instructions on how to reproduce the figures or tables presented in the paper.

---

## Data Availability

- For **Section_5_1** and **Section_5_2**, the MNIST dataset (`.pt` files) is provided in the `MNIST/` folder under `Section_5_1`.

- For **Appendix_F**, the CCLE dataset can be obtained from the [GCIT repository](https://github.com/alexisbellot/GCIT/tree/master/CCLE%20Experiments). Please download the following datasets:
  - Response data  
  - Mutation data  
  - Expression data

Place these datasets in the appropriate locations as described in the relevant `README.md` files.

---

## Environment and Dependencies

The following package versions were used (based on the Google Colab environment as of January 2024):

| Package                  | Version              |
|--------------------------|----------------------|
| python                   | 3.10.x               |
| torch                    | 2.0.1+cu118          |
| numpy                    | ~1.25                |
| scipy                    | ~1.10.1              |
| tqdm                     | ~4.65                |
| scikit-learn             | 1.3.2                |
| tensorflow_probability   | ~0.21.0              |

To install the required packages:

```bash
pip install torch==2.0.1+cu118 numpy scipy tqdm scikit-learn==1.3.2 tensorflow_probability
