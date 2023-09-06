% GridSearch.m
clear; close all; clc;

% DEFINE INPUT PARAMETERS
% =======================
% This script accepts parameters when executed, with the following structure:
% GridSearch('patch_sizes', {[a, a], [b, b]}, 'K_values', [x, y], 'sparsities', [z, w], 'metric', 'SSIM');

% If you don't provide any parameter, the script will use default values.


% Get path of the current script
base_path = fileparts(which('GridSearchWraper'));

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


img_type = input('Enter image type(LR or HR): ', 's');

if strcmpi(img_type, 'LR')
    % Define the path to the Parameters folder relative to the base
    parameters_path = fullfile(base_path, '..', 'Images_Parameters', img_filename, 'Parameters', 'BestParameter', 'LR');
    % Check if the directory exists, if not, create it
    if ~exist(parameters_path, 'dir')
       mkdir(parameters_path);
    end

    % Low resolution image
    img = LowResImage(img_loc, 0.25);

elseif strcmpi(img_type, 'HR')

    % Define the path to the Parameters folder relative to the base
    parameters_path = fullfile(base_path, '..', 'Images_Parameters', img_filename, 'Parameters', 'BestParameter', 'HR');
    % Check if the directory exists, if not, create it
    if ~exist(parameters_path, 'dir')
       mkdir(parameters_path);
    end
    
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

[patch_sizes, K_values, sparsities, metric, iternum] = getInput();

if strcmpi(metric, 'ALL')
    disp('Use GridSearchCombinedWraper.m script!!');
    return;
end

% Calling gridSearch
[best_params, best_score, D_best] = gridSearch(img, patch_sizes, K_values, sparsities, iternum, metric);
    

% Generate a unique filename using a timestamp
timestamp = datetime('now', 'Format', 'MM-dd-HH-mm-ss');
filename = strcat(char(timestamp), '.mat');
filepath = fullfile(parameters_path, filename);

save(filepath, 'best_params', 'best_score', 'D_best');
