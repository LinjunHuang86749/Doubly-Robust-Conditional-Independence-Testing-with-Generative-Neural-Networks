## Reproducibility Instructions

This repository contains code used to reproduce Figure 1 in Section 4.1 of the manuscript.

  - **`Sensitivity_with_respect_to_the_fold_number_J.ipynb`**  
    This Jupyter notebook generates the emperical size and size adjusted power used in Figure 1 (a) and (b). 
    - Core function: `run_experiment` — runs simulations for various values of \( J \) and \( n \), saves the list of p-values, and prints the empirical rejection rates for visualization.
    - To generate empirical size for Figure 1 (a), please run the Code Block titled `code to get Emperical Rejection Rate for Figure 1 (a)`.
    - To generate size adjusted power for Figure 1 (b), please run the Code Block titled `code to get Size Adjusted Power for Figure 1 (b)`.
    
  - **`Different_Fold.Rmd`**  
    This R Markdown file uses the generated data from the previous `.ipynb` file to create the final visualizations for Figure 2 (a) and (b).  
    - Lines 1–64: Code for generating Figure 2 (a). 
    - Lines 66–100: Code for generating Figure 2 (b).

Please ensure both Python and R environments are properly configured before running the respective files.
