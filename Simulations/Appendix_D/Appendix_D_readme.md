## Reproducibility Instructions

This repository contains code used to reproduce Figure 7 in Appendix D of the manuscript. 

- **`Histogram.R`**
  - Code before line 150: simulate 2000 copies of the two oracle statistics $T_0^\ast$ and $T^\ast$. 
  - Code after line 150: use the simulated statistics to plot the histogram in Figure 7 (a).

- **`empirical_power.R`**  
  - Code before line 161: simulate 2000 copies of the two oracle statistics $T_0^\ast$ and $T^\ast$ under alternative with signal $p=$pp.
  - Code after line 161: use the simulated statistics to plot the empirical power curve in Figure 7 (b).

Please ensure R environments are properly configured to execute the respective files.
 