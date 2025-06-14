## Reproducibility Instructions

This repository contains code used to reproduce **Figure 3** in **Section 5.1** of the manuscript.

***

  - **`MNIST` folder**
  
    This folder contains the `.pt` files of the MNIST dataset. 

***

  - **`image_Application_PCA` folder**
  
    This folder includes folders that used to compute p-values for **Figure 3 (a) and (c)**, using **PCA** as the feature extraction method.
    
    - **`train_labels_PCA`** folder: Contain `.ipynb` files to learn generators of $P_{Y |f_{d_{l}(X)}}$ across various latent space dimensions $d_l$.
    - **`train_images_PCA`** folder: Contain `.ipynb` files to learn generators of $P_{X |f_{d_{l}(X)}}$ across various latent space dimensions $d_l$.
    - **`saved_model_PCA`** folder: Contain the saved `.pth` models of generators of $P_{Y |f_{d_{l}(X)}}$ and generators of $P_{X |f_{d_{l}(X)}}$ from **`train_labels_PCA`** and **`train_images_PCA`**.
    - **`find_p_values_Ours`** folder: Contain `.ipynb` files to get the $40$ **$\hat{T_2}$** p values for each latent space dimension $d_l$.
    - **`find_p_values_DGCIT`** folder: Contain `.ipynb` files to get the $40$ **DGCIT** p values for each latent space dimension $d_l$.

***

  - **`image_Application_Avg_Pooling` folder** 
  
    This folder includes folders that used to compute p-values for **Figure 3 (a) and (d)**, using **Average Pooling** as the feature extraction method.
    
    - **`train_labels_Avg_Pooling`** folder: Contain `.ipynb` files to learn generators of $P_{Y |f_{d_{l}(X)}}$ across various latent space dimensions $d_l$.
    - **`train_images_Avg_Pooling`** folder: Contain `.ipynb` files to learn generators of $P_{X |f_{d_{l}(X)}}$ across various latent space dimensions $d_l$.
    - **`saved_model_Avg_Pooling`** folder: Contain the saved `.pth` models of generators of $P_{Y |f_{d_{l}(X)}}$ and generators of $P_{X |f_{d_{l}(X)}}$ from **`train_labels_Avg_Pooling`** and **`train_images_Avg_Pooling`**.
    - **`find_p_values_Ours`** folder: Contain `.ipynb` files to get the $40$ **$\hat{T_2}$** p values for each latent space dimension $d_l$.
    - **`find_p_values_DGCIT`** folder: Contain `.ipynb` files to get the $40$ **DGCIT** p values for each latent space dimension $d_l$.

***

  - **`image_Application_AE` folder** 
  
    This folder includes folders that used to compute p-values for **Figure 3 (a) and (b)**, using **AE** as the feature extraction method.
    
    - **`train_labels_AE`** folder: Contain `.ipynb` files and used the trained AE models to learn generators of $P_{Y |f_{d_{l}(X)}}$ across various latent space dimensions $d_l$.
    - **`train_images_AE`** folder: Contain `.ipynb` files and used the trained AE models to learn generators of $P_{X |f_{d_{l}(X)}}$ across various latent space dimensions $d_l$.
    - **`train_AE_model`** folder: Contain `.ipynb` files to learn the AE model across various latent space dimensions $d_l$.
    - **`saved_model_AE`** folder: Contain the saved `.pth` models of trained AE models, generators of $P_{Y |f_{d_{l}(X)}}$ and generators of $P_{X |f_{d_{l}(X)}}$ from **`train_labels_AE`**, **`train_images_AE`**, and **`train_AE_model`**.
    - **`find_p_values_Ours`** folder: Contain `.ipynb` files to get the $40$ **$\hat{T_2}$** p values for each latent space dimension $d_l$.
    - **`find_p_values_DGCIT`** folder: Contain `.ipynb` files to get the $40$ **DGCIT** p values for each latent space dimension $d_l$.

***

  - **`accuracy` folder** 
  
    This folder includes `.ipynb` files that used to compute the test accuracies
of a k-NN classifiers that shown in **Figure 3 (a), (b), (c), and (d)**, using **PCA**, **Average Pooling**, and **AE** as the feature extraction method respectively.
    
***

  - **`Sec_5_1_plot.Rmd`**  
  
    This R Markdown file contained the generated data from the previous `.ipynb` file in different folders to create the final visualizations for **Figure 3 (a), (b), (c), and (d)**.  
    - Lines 88–116: Code for generating **Figure 3 (a)**. 
    - Lines 119–164: Code for generating **Figure 3 (b)**.
    - Lines 166–213: Code for generating **Figure 3 (c)**. 
    - Lines 215–262: Code for generating **Figure 3 (d)**.

***
 
Please ensure both Python and R environments are properly configured before running the respective files.
