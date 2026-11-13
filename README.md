This package includes four different algorithms for matrix completion problems: NIHT_Matrix, CGIHT_Matrix, ASD, and ScaledASD. 
Please cite corresponding papers when you use it. 

NIHT_Matrix:
Normalized iterative hard thresholding for matrix completion (J. Tanner and K. Wei), SIAM J. Sci. Comput., 35(5) (2013), S104–S125.

CGIHT_Matrix: 
CGIHT: Conjugate gradient iterative hard thresholding for compressed sensing and matrix completion (J. Blanchard, J. Tanner, and K. Wei), submitted.

ASD and ScaledASD
Low rank matrix completion by alternating steepest descent methods (J. Tanner and K. Wei), submitted.

-------------------------------------------------------------------------------------------------------------------------------
Copyright 2013/2014 J. Blanchard, J. Tanner and K. Wei. If there are any problems, feel free to email me at satellite00love@gmail.com.
-------------------------------------------------------------------------------------------------------------------------------

Installation: 
   Run startup.m to set up MATLAB path.
i8
Content: 
   Main/: This folder contains the interface codes to different algorithms.
   Auxiliary/: This folder contains two mex files (to take advantage the sparse structure of matrix completion, written by Wen, Yin and Zhang for LMaFit)
               and two matlab files (to provide the stopping conditions and initial points for different algorithms, adaptions from LRGeomCG by Vandereycken).

Usage: there are two sorts of tests that can be conducted via the demo_v1 routine.
  1. matrix_completion('alg_name', m, n, p, r, epsilon) e.g., matrix_completion('CGIHT_Matrix', 1000, 1000, 100000, 20, 0) or matrix_completion('CGIHT_Matrix', 1000, 1000, 100000, 20):
     it will run CGIHT_Matrix for a random problem with m = 1000, n = 1000 (matrix size), p = 100000 (number of sampled entries), r = 20 (matrix rank) 
     and epsilon = 0 (noise free), and write the output into a file. The alg_name are those algorithm names in Main file.

  2. matrix_noise('alg_name', 'img', 'snr', 'delta') = [Mout, M, M_noisy, noisy_psnr]
      given a choice of image ('img'), signal-to-noise ratio ('snr'), and missing-data rate ('delta'), the matrix_noise routine will inpaint the rank r SVD of our img ('M') with Gaussian random noise to generate 'M_noisy'. the routine then runs 'alg_name' to reconstruct the inpainted image 'M_Noisy'. finally, the reconstruction PSNR 'noisy_psnr' is calculated relative to the SVD of our image 'M'.
      






