## Reproducibility Instructions

This repository contains code used to reproduce **Figure 8** in Appendix E of the manuscript. For method **$\hat T_2$ Oracle** and **$\hat T_2$ GANs**, we used the same results from **Section 4.2**.

  - **`GANs.ipynb`**  
    This Jupyter notebook generates the emperical size and size adjusted power used in **Figure 8 (a), (b), (c), (d)** for method **$\hat T_2$ GANs**. 
    - To generate empirical size for **Figure 8 (a), (b)** for method **$\hat T_2$ GANs**, please run the Code Block titled `code to get Emperical Rejection Rate for Figure 8 (a) (b) hat T_2 GANs`.
    - To generate size adjusted power for **Figure 8 (c), (d)** for method **$\hat T_2$ GANs**, please run the Code Block titled `code to get Size Adjusted Power for Figure 8 (c) (d) hat T_2`.
    
  - **`Appendix_E_plots.Rmd`**  
    This R Markdown file uses the generated data from the previous `.ipynb` file to create the final visualizations for **Figure 8 (a), (b), (c), (d)**.  
    - Lines 30–59: Code for generating **Figure 8 (a)**. 
    - Lines 62–94: Code for generating **Figure 8 (b)**.
    - Lines 96–128: Code for generating **Figure 8 (c)**.
    - Lines 129–162: Code for generating **Figure 8 (d)**.
    
Please ensure both Python and R environments are properly configured before running the respective files.
