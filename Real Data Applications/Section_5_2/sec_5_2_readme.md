## Reproducibility Instructions

This repository contains code used to reproduce **Figure 4** in **Section 5.2** of the manuscript.  
Please refer to the **`MNIST/`** folder from **Section 5.1** to access the `.pt` files for the MNIST dataset.


***

  - **`saved_models` folder**
  
    Contains the saved `.pth` models of trained autoencoders (AEs), generators of \( P_{Y \mid Z} \), and generators of \( P_{X \mid Z} \) across various latent space dimensions \( d_l \).
  
***

  - **`Find_p_val` folder** 
  
    Contains `.ipynb` notebooks for computing the median, 25th percentile, and 75th percentile of the 50 **\( \hat{T}_2 \)** or **DGCIT** p-values across various latent dimensions \( d_l \).
  
    - **`find_p_vals_Ours.ipynb`**
      - The first code block allows you to vary the latent dimension via the `d_l` variable.
      - Code block 9 (`Train AE model`) trains the AE model with the specified \( d_l \).
      - Code block 10 (`Get MSE for compute Test PSNR`) computes test MSE for PSNR calculation and it will be used in **Figure 4 (a)**.
      - Code block 19 trains multiple \( P_{X \mid Z} \) generators with different seeds.
      - Code bloack 20 (`Get Gen model X`) selects the one with the lowest validation MMD loss.
      - Code block 21 trains multiple \( P_{Y \mid Z} \) generators with different seeds.
      - Code block 24 (`Get Gen model Y`) selects the best model by validation MMD loss.
      - The final block prints the mean, median, 25th, and 75th percentile of the 50 computed **\( \hat{T}_2 \)** p-values.
    - **`find_p_vals_DGCIT.ipynb`**
      - The first code block allows you to vary the `d_l` value.
      - Loads saved `.pth` models of the AE, \( P_{X \mid Z} \), and \( P_{Y \mid Z} \) from the **`saved_models/`** folder based on the latent dimension.
      - The final block outputs the mean, median, 25th, and 75th percentile of the 50 computed **DGCIT** p-values.
    
***

  - **`accuracy` folder** 
  
    Contains `.ipynb` files used to compute test accuracies for k-NN classifiers, as shown in **Figure 4 (b)**.

    
***

  - **`Sec_5_2_plot.Rmd`**  
  
    This R Markdown file contained the data from the previous `.ipynb` file in different folders to create the final visualizations for **Figure 4 (a) and (b)**.  
    - Lines 72–119: Code for generating **Figure 4 (a)**. 
    - Lines 122–170: Code for generating **Figure 4 (b)**.


***
 
Please ensure both Python and R environments are properly configured before running the respective files.
