## Reproducibility Instructions

This repository contains code used to reproduce **Figure 2** in **Section 4.2** of the manuscript.

  - **`Ours.ipynb`**  
    This Jupyter notebook generates the emperical size and size adjusted power used in **Figure 1 (a) and (b)** for method **$\hat T_2$**. 
    - To generate empirical size for **Figure 2 (a)** for method **$\hat T_2$**, please run the Code Block titled `code to get Emperical Rejection Rate for Figure 2 (a) hat T_2`.
    - To generate size adjusted power for **Figure 2 (b)** for method **$\hat T_2$**, please run the Code Block titled `code to get Size Adjusted Power for Figure 2 (b) hat T_2`.

  - **`Ours_Oracle.ipynb`**  
    This Jupyter notebook generates the emperical size and size adjusted power used in **Figure 1 (a) and (b)** for method **$\hat T_2$ orcale**. 
    - To generate empirical size for **Figure 2 (a)** for method **$\hat T_2$ orcale**, please run the Code Block titled `code to get Emperical Rejection Rate for Figure 2 (a) hat T_2 orcale`.
    - To generate size adjusted power for **Figure 2 (b)** for method **$\hat T_2$ orcale**, please run the Code Block titled `code to get Size Adjusted Power for Figure 2 (b) hat T_2 orcale`.

  - **`gcit.ipynb`**  
    This Jupyter notebook generates the emperical size and size adjusted power used in **Figure 1 (a) and (b)** for method **`GCIT`**. 
    - To generate empirical size for **Figure 2 (a)** for method **`GCIT`**, please run the Code Block titled `code to get Emperical Rejection Rate for Figure 2 (a) GCIT`.
    - To generate size adjusted power for **Figure 2 (b)** for method **`GCIT`**, please run the Code Block titled `code to get Size Adjusted Power for Figure 2 (b) GCIT`.


  - **`dgcit.ipynb`**  
    This Jupyter notebook generates the emperical size and size adjusted power used in **Figure 1 (a) and (b)** for method **`DGCIT`**. 
    - To generate empirical size for **Figure 2 (a)** for method **`DGCIT`**, please run the Code Block titled `code to get Emperical Rejection Rate for Figure 2 (a) DGCIT`.
    - To generate size adjusted power for **Figure 2 (b)** for method **`DGCIT`**, please run the Code Block titled `code to get Size Adjusted Power for Figure 2 (b) DGCIT`.

  - **`CIT_size.R`**  
    This R file generates the emperical size used in **Figure 2 (a)** for method **`CIT`**. 
    - Code before line 266: generate the statistic (bn=2) and its oracle version (bn=1) for different dimension dz of $Z$ and different batach (dt) of experiment.
    - Code after line 266: Use the oracle statistics to calculate the rejection criteria, and use this criteria to calculate the empirical size used in **Figure 2 (a)**.

  - **`CIT_power.R`**  
    This R file generates the size adjusted power used in **Figure 2 (b)** for method **`CIT`**. 
    - Code before line 251: generate the statistic for different dimension dz of $Z$, different signal value b and different batach (dt) of experiment.
    - Code after line 251: Use the statistics generated above to calculate the empirical rejection rate under alternative used in **Figure 2 (b)**.
    
  - **`sec_04_02_plots.Rmd`**  
    This R Markdown file uses the generated data from the previous `.ipynb` files to create the final visualizations for Figure 2 (a) and (b).  
    - Lines 26–64: Code for generating **Figure 2 (a)** 
    - Lines 70–108: Code for generating **Figure 2 (b)**

Please ensure both Python and R environments are properly configured before running the respective files.
