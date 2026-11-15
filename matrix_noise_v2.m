% Utility: matrix_noice_vN(alg_list, img, snr, delta)
%
% Input:
%   1) alg_list: "call names for my four algos"
%   2) img: test image
%   3) snr: signal-to-noise ratio (SNR) computed from Frobenius norm
%   4) delta: undersampling ratio
%
% Output:
%   1) image_results: results from each algorithm
%   2) M: rank-50 truncated singular-value decomposition (SVD) of img
%   3) inpaintOut:
%   4) inpaint_psnr: peak SNR of inpaintOut relative to rank-50 benchmark

function [image_results, M, inpaintOut, inpaint_psnr] = matrix_noise_v2(alg_list, img, snr, delta) %= random_inpaint(alg_name, img, snr) prior file

% ======== read and normalize greyscale data
X = imread(img);
X = im2gray(X);
X=double(X)/255;

% ======== rank-50 SVD to allow recovery to arbitrary precision
r = 50;
[U, S, V] = svds(X,r);

clear X;

M = U*S*V';

[m, n] = size(M);

% ======== initialize the observation space Omega

p = round(delta*m*n);
Omega = randperm(m*n, p)';

% if delta == 1
%    Omega=(1:m*n)';
% else
%    A = zeros(m*n,1);
%    A(1:p) = ones(p,1);
%    [~,ind] = sort(randn(m*n,1));
%    A = A(ind);
%    A = reshape(A,m,n);
% 
%    [I, J] = find(A);
%    Omega = sub2ind([m n], I, J);
% end

% ======== restrict image approximation to observation space

data = M(Omega);

% ======== generate random matrix restricted to observation space

NN = randn(size(M));
NN = NN(Omega);

% ======== normalize the random observations NN to the required snr

noiseLevel = norm(data) / (10^(snr/20)*norm(NN));
NN = NN*noiseLevel;

data = data + NN;

% ======== visualize and calculate PSNR of inpainted image

inpaintOut = zeros(size(M));
inpaintOut(Omega) = data;

inpaint_psnr = psnr(inpaintOut, M, 1);

% Noise model
%noise_opts.type = 'white';


% ======== test algorithms on inpainted image

image_results = cell(4, 1);

opts = default_opts;

fprintf('recovery starts...\n\n')

for k = 1:4

    alg_name = alg_list{k};
    fhandle = str2func(alg_name);

    % initialize low-rank guess
    start = make_start_x(alg_name, m, n, r, Omega, data);

    fprintf('%s recovery starts...\n', alg_name)

    tic
    [Mout, Out] = fhandle(m, n, r, Omega, data, start, opts);
    ttol = toc;

    % store algo results
    image_results{k} = Mout;

    % error calculation
    relerr = norm(M - Mout, 'fro') / norm(M, 'fro');

    fprintf(['%s relerr = %g, iter = %d, ' 't = %g, reschg = %g\n\n'], ...
        alg_name, relerr, Out.iter, ttol, Out.reschg);

end

fprintf('recovery ends...\n\n')

end