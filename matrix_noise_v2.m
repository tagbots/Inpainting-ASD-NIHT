% Utility: matrix_noise(alg_list, img, snr, delta)
%
% Input:
%   1) alg_list: "call names for my four algos"
%   2) img: test image
%   3) snr: signal-to-noise ratio (SNR)
%   4) delta: undersampling ratio
%
% Output:
%   1) image_results: results from each algorithm
%   2) M: rank-50 truncated singular-value decomposition (SVD) of img
%   3) inpaintOut: result from inpainting step
%   4) inpaint_psnr: peak SNR of inpainted image

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

% ======== initialize independent random number streams

[sOmega, sNoise] = RandStream.create('mrg32k3a', 'NumStreams', 2);

% ======== generate the observation space Omega

% p = round(delta*m*n);
% Omega = randperm(sOmega, m*n, p)';

if delta == 1
   Omega=(1:m*n)';
else
   A = zeros(m*n,1);
   A(1:p) = ones(p,1);
   [~,ind] = sort(randn(sOmega,m*n,1));
   A = A(ind);
   A = reshape(A,m,n);

   [I, J] = find(A);
   Omega = sub2ind([m n], I, J);
end

% ======== restrict image approximation to observed entries

data = M(Omega);

% ======== generate random matrix restricted to observed entries

NN = randn(sNoise, size(M));
NN = NN(Omega);

% ======== image inpainting

noiseLevel = norm(data) / (10^(snr/20)*norm(NN));
NN = NN*noiseLevel;

data = data + NN;

% ======== visualize and calculate PSNR of inpainted image

inpaintOut = zeros(size(M));
inpaintOut(Omega) = data;

inpaint_psnr = psnr(inpaintOut, M, 1);

% ======== test algorithms on inpainted image

image_results = cell(4, 1);

opts = default_opts;
disp('Options used:')
disp(opts)

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