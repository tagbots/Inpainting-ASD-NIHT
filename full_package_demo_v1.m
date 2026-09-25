clear; close all; clc

% ========= random tests =======
fprintf('--- random matrix completion ---\n')

% --------- problem size -------
m = 100; %1000
n = 100; %1000
p = round(.2*m*n); %CHANGE! REMOVES 80% PIXELS?
r = 50;

fprintf('problem size: m = %d, n = %d, p = %d, r = %d\n\n', m, n, p, r)

% --------- NIHT_Matrix ---------
fprintf('NIHT starts ...\n')
matrix_completion('NIHT_Matrix', m, n, p, r)
fprintf('NIHT over ...\n\n')

% ---------- CGIHT_Matrix -------
fprintf('CGIHT starts ...\n')
matrix_completion('CGIHT_Matrix', m, n, p, r)
fprintf('CGIHT over ...\n\n')

% ----------- ASD --------------
fprintf('ASD starts ...\n')
matrix_completion('ASD', m, n, p, r)
fprintf('ASD over ...\n\n')

% -------- ScaledASD ------------
fprintf('ScaledASD starts ...\n')
matrix_completion('ScaledASD', m, n, p, r)
fprintf('ScaledASD over ...\n\n')

% ========= image inpainting ======
fprintf('--- random/cross inpainting ---\n')

alg_list = cell(4,1);
alg_list{1} = 'NIHT_Matrix';
alg_list{2} = 'CGIHT_Matrix';
alg_list{3} = 'ASD';
alg_list{4} = 'ScaledASD';

img_list = cell(3,1);
img_list{1} = 'boat.png';
img_list{2} = 'barb.png';
img_list{3} = 'lena.png';

% fprintf('1. NIHT, 2. CGIHT, 3. ASD, 4. ScaledASD (suggested:))\n')
% alg = input('Select an algorithm number from 1 to 4: ');

fprintf('1. boat, 2. barb, 3. lena\n')
img = input('Select an image number from 1 to 3: ');

snr = input('Enter desired SNR in dB (example: 5, 10, 20, 30): ');

% the 

fprintf('\n')

image_results = cell(4, 1);

for k=1:4
    rng(1)
  [image_results{k}, M, A] = Random_noise_051226(alg_list{k},img_list{img},snr);
end

figure;
subplot(2, 3, 1)
imshow(M, [])
title('Original')

noisy_psnr = psnr(A.*M, M);

subplot(2, 3, 2)
imshow(A.*M, [])
title({['Noisy, SNR= ', num2str(snr), ' dB'], ['PSNR = ', num2str(noisy_psnr, '%.2f'), ' dB']})

for k=1:4
    recovered_psnr = psnr(image_results{k}, M);
    subplot(2, 3, k+2)
    imshow(image_results{k}, [])
    title({alg_list{k},['PSNR = ', num2str(recovered_psnr, '%.2f'), ' dB']}, 'Interpreter', 'none')
end
% delta = 0.5;
% delta_percent = (100*delta);

fig_filename = ['tiles_snr', num2str(snr),'_observed', num2str(delta_percent), 'percent_rank', num2str(r), '.png'];

exportgraphics(gcf, fig_filename, 'Resolution', 300);