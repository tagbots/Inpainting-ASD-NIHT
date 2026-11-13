function [Mout, M, M_noisy, noisy_psnr] = matrix_noise_v1(alg_name, img, snr, delta) %= random_inpaint(alg_name, img, snr) prior file

X = imread(img);
X = im2gray(X); %because i was lazy and downloaded images in color
X=double(X)/255;
r = 50;
[U, S, V] = svds(X,r);

clear X;

M = U*S*V';

[m, n] = size(M);

p = round(delta*m*n);

if delta == 1
    Omega=(1:m*n)';
else
    A = zeros(m*n,1);
    A(1:p) = ones(p,1);
    [~,ind] = sort(randn(m*n,1));
    A = A(ind);
    A = reshape(A,m,n);
    
    [I, J] = find(A);
    Omega = sub2ind([m n], I, J);
end

%p = round(delta*m*n);
%Omega = randperm(m*n, p)';

signal_obs = M(Omega);

% Noise model
%noise_opts.type = 'white';

% Generate white Gaussian noise over the full image
noise_full = randn(size(M));

% Restrict noise to observed entries
noise_obs = noise_full(Omega);

% Enforce desired realized SNR
noise_obs = noise_obs * norm(signal_obs) / (10^(snr/20)*norm(noise_obs));

data = signal_obs + noise_obs;

M_noisy = zeros(size(M));
M_noisy(Omega) = data;

noisy_psnr = psnr(M_noisy, M, 1);

%figure(1)                                   %commented out in prior
%imshow(A.*M)                                %commented out in prior
%drawnow                                     %commented out in prior

%fprintf('begin reovery? Press Enter\n\n')   %commented out in prior
%pause                                       %commented out in prior

% convert string to function handle
fhandle = str2func(alg_name);
opts = default_opts;

start = make_start_x(alg_name,m,n,r,Omega,data);

fprintf('recovery starts...\n')

tic;[Mout, Out] = fhandle(m,n,r,Omega,data,start,opts); ttol=toc;
relerr = norm(M-Mout,'fro')/norm(M,'fro');
fprintf([alg_name ' relerr = %g, iter = %d, t = %g, reschg = %g\n'], relerr, Out.iter, ttol, Out.reschg);

fprintf('recovery ends...\n\n')


%figure(2)
%imshow(Mout)
%drawnow

%{
title(alg_name,'fontsize',15);
print([func_name,'_boat_random'],'-dpdf')
print([func_name,'_boat_random'],'-depsc')
%}

%fprintf('close all the figures? Press Enter\n')
%pause

%close all