clear; close all; clc

% ========= random tests =======
fprintf('--- random matrix completion ---\n')

% --------- problem size -------
m = 100;
n = 100;
delta=1; % IF I SAW EVERYTHING, DELTA=1
p = round(delta*m*n);
r = 50;
delta_percent=100*delta;

fprintf('problem size: m = %d, n = %d, p = %d, r = %d\n\n', m, n, p, r)

% % --------- NIHT_Matrix ---------
% fprintf('NIHT starts ...\n')
% matrix_completion('NIHT_Matrix', m, n, p, r)
% fprintf('NIHT over ...\n\n')
% 
% % ---------- CGIHT_Matrix -------
% fprintf('CGIHT starts ...\n')
% matrix_completion('CGIHT_Matrix', m, n, p, r)
% fprintf('CGIHT over ...\n\n')
% 
% % ----------- ASD --------------
% fprintf('ASD starts ...\n')
% matrix_completion('ASD', m, n, p, r)
% fprintf('ASD over ...\n\n')
% 
% % -------- ScaledASD ------------
% fprintf('ScaledASD starts ...\n')
% matrix_completion('ScaledASD', m, n, p, r)
% fprintf('ScaledASD over ...\n\n')
% 
% % ========= image inpainting ======
% fprintf('--- random/cross inpainting ---\n')

alg_list = cell(4,1);
alg_list{1} = 'NIHT_Matrix';
alg_list{2} = 'CGIHT_Matrix';
alg_list{3} = 'ASD';
alg_list{4} = 'ScaledASD';

img_list = cell(12,1);
img_list{1} = 'boat.png';
img_list{2} = 'barb.png';
img_list{3} = 'lena.png';
img_list{4} = 'aerial.tiff';
img_list{5} = 'baboon.tiff';
img_list{6} = 'bubbles.tiff';
img_list{7} = 'couple.tiff';
img_list{8} = 'GGB2.jpg';
img_list{9} = 'oakland.tiff';
img_list{10} = 'peppers.tiff';
img_list{11} = 'straw.tiff';
img_list{12} = 'airplane.tiff';

% fprintf('1. NIHT, 2. CGIHT, 3. ASD, 4. ScaledASD (suggested:))\n')
% alg = input('Select an algorithm number from 1 to 4: ');

fprintf('1. boat, 2. barb, 3. lena, 4. aerial, 5. baboon, 6. bubbles, 7. couple, 8. GGB, 9. oakland, 10. peppers, 11. straw, 12. airplane \n')
img = input('Select an image number from 1 to 12: ');

snr = input('Enter desired SNR in dB (example: 5, 10, 20, 30): ');


fprintf('\n')

[image_results, M, inpaintOut, inpaint_psnr] = matrix_noise_v2(alg_list, img_list{img}, snr, delta);

figure;
subplot(2, 3, 1)
imshow(M, [])
title('Original')

subplot(2, 3, 2)
imshow(inpaintOut, [])
title({['Noisy, SNR= ', num2str(snr), ' dB'], ['PSNR = ', num2str(inpaint_psnr, '%.2f'), ' dB']})

for k=1:4
    recovered_psnr = psnr(image_results{k}, M);
    subplot(2, 3, k+2)
    imshow(image_results{k}, [])
    title({alg_list{k},['PSNR = ', num2str(recovered_psnr, '%.2f'), ' dB']}, 'Interpreter', 'none')
end

fig_filename = ['tiles_snr', num2str(snr),'_observed', num2str(delta_percent), 'percent_rank', num2str(r), '.png'];

exportgraphics(gcf, fig_filename, 'Resolution', 300);