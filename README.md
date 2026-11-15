# Image Inpainting and Random Matrix Problems

This package contains four algorithms for low-rank matrix completion:

   `NIHT_Matrix`:
   Normalized iterative hard thresholding for matrix completion (J. Tanner and K. Wei), SIAM J. Sci. Comput., 35(5) (2013), S104–S125.

   `CGIHT_Matrix`: 
   CGIHT: Conjugate gradient iterative hard thresholding for compressed sensing and matrix completion (J. Blanchard, J. Tanner, and K. Wei), submitted.

   `ASD` and `ScaledASD`
   Low rank matrix completion by alternating steepest descent methods (J. Tanner and K. Wei), submitted.


## Copyright + Contact

Copyright 2013/2014 J. Blanchard, J. Tanner and K. Wei.

Code modifications by `@tagbots`

Bugs and info:

`satellite00love@gmail.com`


## Installation

Run startup.m to set up MATLAB path.

## Package Contents

### `Main/`

Contains the demonstration script and MATLAB implementations of the four algorithms.

### `Auxiliary/`

- Two MEX files that take advantage of the sparse structure of matrix completion
  problems. These files were originally written by Wen, Yin, and Zhang for
  LMaFit.
- MATLAB files providing stopping conditions and initialization routines,
  adapted from LRGeomCG by Bart Vandereycken.

### `Images/`

This folder contains eleven test images obtained from
```markdown
[USC-SIPI Image Database](https://sipi.usc.edu/database/)
```

## `Usage`

The package supports two types of experiments.

### Random Matrix Completion

Use the following function:

```matlab
matrix_completion('alg_name', m, n, p, r, epsilon)
```

it will run CGIHT_Matrix for a random problem with m = 1000, n = 1000 (matrix size), p = 100000 (number of sampled entries), r = 20 (matrix rank) and epsilon = 0 (noise free), and write the output into a file. The alg_name are those algorithm names in Main file.

### Image Inpainting

Use the following function:

```matlab
matrix_noise_v2('alg_list', 'img', 'snr', 'delta')
```

Parameters:
- alg_list: list of algorithms to run
- img: image filename or path
- snr: signal-to-noise ratio of observed data
- delta: undersampling ratio

For example:
alg_list = {'NIHT_Matrix', 'CGIHT_Matrix'};
matrix_noise_v2(alg_list, 'Images/Lena.png', 20, 0.5)

This runs the selected algorithms on an image-inpainting problem with additive random noise corresponding to 20 dB, and a sampling ratio of 50%.
      






