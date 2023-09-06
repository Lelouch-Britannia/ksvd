% TrainingScript.m
clear; close all; clc;

% Get path of the current script
base_path = fileparts(which('TrainingScriptV1'));

% Define the image location relative to the base
img_loc = fullfile(base_path, '..', 'Set14', 'original', 'lenna.png');

% Hyper-parameters
split_ratio = 0.8;
patch_size = [5, 5];
iternum = 100;
sparsity = 10;
K = 512;

% Call with default values for sparsity and iternum
low_res_img = LowResImage(img_loc, 0.25);

X = preProcessing(low_res_img, patch_size);

N = size(X, 2);  % Number of patches

% Shuffle and Split data into training and testing
idx = randperm(N);
train_size = round(N * split_ratio);
X_train = X(:, idx(1:train_size));
X_test = X(:, idx(train_size+1:end));

% Ensure data_scaled has the correct size for training
X_train = X_train(:, 1:train_size);

D = Training(X_train, X_test, K, iternum, sparsity, 'on');

% Single Patch Recostruction
SinglePatchReconstructV2(D, X_test, patch_size);

% Using OMP for sparse codes 
GAMMA = omp(D, X, D'*D, sparsity);

% Reconstruct patches
X_reconst = D * GAMMA;

% Reconstruct the image from patches
reconstructed_img = reconstruct_from_patches_2d(X_reconst, patch_size, size(low_res_img));

% Rescale the image to [0, 255]
reconstructed_img_linear = (reconstructed_img - min(reconstructed_img(:))) / (max(reconstructed_img(:)) - min(reconstructed_img(:))) * 255;
reconstructed_img_linear = uint8(reconstructed_img_linear);

% Compute SSIM and PSNR
ssim_val = ssim(low_res_img, reconstructed_img_linear);
psnr_val = psnr(low_res_img, reconstructed_img_linear);

% Calculate RMSE
rmse_val = sqrt(mean((low_res_img(:) - reconstructed_img_linear(:)).^2));

fprintf('Image Score \n');
fprintf('------------- \n');
fprintf('SSIM Score: %f\n', ssim_val);
fprintf('PSNR Score: %f\n', psnr_val);
fprintf('RMSE: %f\n', rmse_val);

% Display
figure;
subplot(1,2,1);
imshow(low_res_img, []);
title('Original Low Res Image', FontSize=8);

subplot(1,2,2);
imshow(reconstructed_img_linear, []);
title('Reconstructed Low Res Image', FontSize=8);