function [Mout, M, A] = Random_noise_051226(alg_name, img, snr) %= random_inpaint(alg_name, img, snr) prior file

X = imread(img);
X=double(X)/255;
r = 50;
[U, S, V] = svds(X,r);

clear X;

M = U*S*V';

[m, n] = size(M);
delta = .5; %for denoising problem we want all pixels
p = round(delta*m*n);

A = zeros(m*n,1);                       %commented out in prior
A(1:p) = ones(p,1);                     %commented out in prior
[~,ind] = sort(randn(m*n,1));           %commented out in prior
A = A(ind);                             %commented out in prior
A = reshape(A,m,n);                     %commented out in prior
[I, J] = find(A);                       %commented out in prior
Omega = sub2ind([m n], I, J);           %commented out in prior
%data=M(Omega); %removed on prior file


signal_power = var(M(:));                         % Added on prior file
noise_power = signal_power / (10^(snr/10));    % Added on prior file
sigma_noise = sqrt(noise_power);                  % Added on prior file

%rng(1)
noise = sigma_noise * randn(size(M));             % Added on prior file
M_noisy = M + noise;                              % Added on prior file
data = M_noisy(Omega);                                   % Added on prior file

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