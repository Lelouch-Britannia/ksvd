% TrainingScript.m
clear; close all; clc;

% Get path of the current script
base_path = fileparts(which('TrainingScript'));

% Define toolbox paths relative to the base
toolbox_path1 = fullfile(base_path, '..', '..', 'Toolboxes', 'ksvdbox13');
toolbox_path2 = fullfile(base_path, '..', '..', 'Toolboxes', 'ompbox10');

addpath(toolbox_path1);
addpath(toolbox_path2);

% Define directory
dir_path = fullfile(base_path, '..', 'Set14', 'original');

% Input image location
file_loc = input('Enter file name: ', 's');
img_loc = fullfile(dir_path, file_loc);

% Extract filename(path, name and extension)
[~, img_filename, ~] = fileparts(file_loc);


% Option Selection
disp('Choose an option:');
disp('1. Provide the location of the result matrix');
disp('2. Provide the location of the best parameters');
disp('3. Enter parameters directly');
option = input('Enter the option number (1,2 or 3): ');
img_type = input('Enter image type(LR or HR): ', 's');

if strcmpi(img_type, 'LR')
    % Low resolution image
    img = LowResImage(img_loc, 0.25);
elseif strcmpi(img_type, 'HR')
    % Read HR image
    img = imread(img_loc);
    % Check if the image is RGB, if yes then convert to grayscale
    if size(img,3) == 3
        img = rgb2gray(img);
    end
else
    disp('Enter valid option\n');
    return;
end

switch option
    case 1
        
        if strcmpi(img_type, 'LR')
            % Define the path to the Parameters folder relative to the base
            dir_path = fullfile(base_path, '..', 'Images_Parameters', img_filename, 'Parameters', 'GridSearch', 'LR');
            % Check if the directory exists, if not, create it
            if ~exist(dir_path, 'dir')
               return;
            end
        
        else
        
            % Define the path to the Parameters folder relative to the base
            dir_path = fullfile(base_path, '..', 'Images_Parameters', img_filename, 'Parameters', 'GridSearch', 'HR');
            % Check if the directory exists, if not, create it
            if ~exist(dir_path, 'dir')
               return;
            end
            
        end


        result_matrix_path = input('Enter filename for result matrix: ', 's');
        filepath = fullfile(dir_path, result_matrix_path);
        load(filepath, 'results_matrix');

        % Statistics about gridsearch
        plotResultsMatrix(results_matrix);
        
        % Best score is based on highest SSIM
        [~, best_idx] = max(results_matrix(:, 7)); % Assuming SSIM is the last column
        patch_size = [results_matrix(best_idx, 1), results_matrix(best_idx, 2)];
        K = results_matrix(best_idx, 3);
        sparsity = results_matrix(best_idx, 4);
        
        iternum = input('Enter number of iteration: ');
        fprintf('Current Iteration Parameters: Patch Size = %d\n', patch_size);
        fprintf('Current Iteration Parameters: K = %d, sparsity = %d\n', K, sparsity);

    case 2 

        if strcmpi(img_type, 'LR')
            % Define the path to the Parameters folder relative to the base
            dir_path = fullfile(base_path, '..', 'Images_Parameters', img_filename, 'Parameters', 'BestParameter', 'LR');
            % Check if the directory exists, if not, create it
            if ~exist(dir_path, 'dir')
               return;
            end
        
        else
        
            % Define the path to the Parameters folder relative to the base
            dir_path = fullfile(base_path, '..', 'Images_Parameters', img_filename, 'Parameters', 'BestParameter', 'HR');
            % Check if the directory exists, if not, create it
            if ~exist(dir_path, 'dir')
               return;
            end
            
        end

        best_params_path = input('Enter filename for Best parameters: ', 's');
        filepath = fullfile(dir_path, best_params_path);
        load(filepath, 'best_params', 'D_best');
        
        patch_size = best_params.patch_size;
        K = best_params.K;
        sparsity = best_params.sparsity;

        D = D_best;
        fprintf('Current Iteration Parameters: Patch Size = %d\n', patch_size);
        fprintf('Current Iteration Parameters: K = %d, sparsity = %d\n', K, sparsity);

    case 3
        
        parameters = input('Enter parameters as [patch_size, K, sparsity, iternum]: ');
        patch_size = [parameters(1), parameters(1)];
        K = parameters(2);
        sparsity = parameters(3);
        iternum = parameters(4);
       
    otherwise
        error('Invalid option.');
end

% Standard Hyper-parameters
split_ratio = 0.8;

% % Call with default values for sparsity and iternum
% low_res_img = LowResImage(img_loc, 0.25);

X = preProcessing(img, patch_size);

N = size(X, 2);  % Number of patches

% Shuffle and Split data into training and testing
idx = randperm(N);
train_size = round(N * split_ratio);
X_train = X(:, idx(1:train_size));
X_test = X(:, idx(train_size+1:end));

if option ~= 2
    % Ensure data_scaled has the correct size for training
    X_train = X_train(:, 1:train_size);
    
    D = Training(X_train, X_test, K, iternum, sparsity, 'on');

end
% Single Patch Recostruction
SinglePatchReconstructV2(D, X_test, patch_size);

% Using OMP for sparse codes 
GAMMA = omp(D, X, D'*D, sparsity);

% Compressibility
compressibility(GAMMA);

% Reconstruct patches
X_reconst = D * GAMMA;

% Reconstruct the image from patches
reconstructed_img = reconstruct_from_patches_2d(X_reconst, patch_size, size(img));

% Rescale the image to [0, 255]
reconstructed_img_linear = (reconstructed_img - min(reconstructed_img(:))) / (max(reconstructed_img(:)) - min(reconstructed_img(:))) * 255;
reconstructed_img_linear = uint8(reconstructed_img_linear);

% Compute SSIM and PSNR
ssim_val = ssim(img, reconstructed_img_linear);
psnr_val = psnr(img, reconstructed_img_linear);

% Calculate RMSE
rmse_val = sqrt(mean((img(:) - reconstructed_img_linear(:)).^2));

fprintf('Image Score \n');
fprintf('------------- \n');
fprintf('SSIM Score: %f\n', ssim_val);
fprintf('PSNR Score: %f\n', psnr_val);
fprintf('RMSE: %f\n', rmse_val);

% Display
figure;
subplot(1,2,1);
imshow(img, []);
if strcmpi(img_type, 'LR')
    title('Original Low Res Image', FontSize=8);
else
    title('Original High Res Image', FontSize=8);
end

subplot(1,2,2);
imshow(reconstructed_img_linear, []);
if strcmpi(img_type, 'LR')
    title('Reconstructed Low Res Image', FontSize=8);
else
    title('Reconstructed High Res Image', FontSize=8);
end