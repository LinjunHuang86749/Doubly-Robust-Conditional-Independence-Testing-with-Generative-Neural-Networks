## Reproducibility Instructions

This repository contains code used to reproduce **Table 3** in **Appendix F** of the manuscript.

To access the CCLE dataset, please visit the [GCIT repository](https://github.com/alexisbellot/GCIT/tree/master/CCLE%20Experiments) and download the following datasets:

- **Response data**

- **Mutation data**

- **Expression data**

---

- **`Ours.ipynb`**  
  This notebook computes the **\( \hat{T}_2 \)** p-values reported in **Table 3**.  
  - The final code block prints the p-values for different drug–gene pairs.

- The other p-values shown in **Table 3** are reproduced from:  
  **Shi, C., Xu, T., & Bergsma, W. (2021).**  
  *Double Generative Adversarial Networks for Conditional Independence Testing.*  
  Journal of Machine Learning Research, **22(171)**, 1–45.  
  ([Link to paper](https://www.jmlr.org/papers/volume22/21-0294/21-0294.pdf), see Table 1 on page 16)

---

**Note:** Please ensure the CCLE datasets are placed in the appropriate directory before running the notebook.