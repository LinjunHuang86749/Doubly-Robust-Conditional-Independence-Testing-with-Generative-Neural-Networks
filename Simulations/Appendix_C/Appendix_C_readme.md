## Reproducibility Instructions

This repository contains code used to reproduce **Figure 6** in **Appendix C** of the manuscript.

  - **`ours_size.ipynb`**  
    This Jupyter notebook generates the emperical size used in **Figure 6 (a)** for method **$\hat T_2$**. 
    - To generate empirical size for **Figure 6 (a)** for method **$\hat T_2$**, please run the Code Block titled `code to get Emperical Rejection Rate for Figure 6 (a) hat T_2`.

  - **`ours_power.ipynb`**  
    This Jupyter notebook generates the size adjusted power used in **Figure 6 (b)** for method **$\hat T_2$**. 
    - To generate size adjusted power for **Figure 6 (a)** for method **$\hat T_2$**, please run the Code Block titled `code to get Size Adjusted Power for Figure 6 (b) hat T_2`.

  - **`SplitKCI`** Folder
    This folder contains all the code that generates the p values for method **SplitKCI** with different split ratio. 
      - Run **`SplitKCI_size.py`** to get all the p values for method **SplitKCI** with different split ratio under the null.
      - Run **`SplitKCI_power.py`** to get all the p values for method **SplitKCI** with different split ratio under the alternative.
      - Other `.py` files are dependence files.
  
  - **`Appendix_C_plot.R`**  
    This R Markdown file uses the generated data from the previous `.ipynb` file to create the final visualizations for Figure 6 (a) and (b).  
    - Lines 1–66: Code for computing emperical size for **SplitKCI** with different split ratio and generating Figure 6 (a). 
    - Lines 86–156: Code for computing size adjusted power for **SplitKCI** with different split ratio and generating Figure 6 (b).
    - Need to load the csv files that generated from `SplitKCI_size.py` or `SplitKCI_power.py`.


Please ensure both Python and R environments are properly configured before running the respective files.
