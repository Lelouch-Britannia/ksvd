img_loc = "Set14/original/barbara.png";
high_res_img = imread(img_loc);

% Convert RGB to grayscale
high_res_grey_img = rgb2gray(high_res_img);

% Display the image
figure;

% Display high resolution RGB image
subplot(1, 2, 1);
imshow(high_res_img);
title('High Resolution Image');

% Display high resolution grayscale image
subplot(1, 2, 2);
imshow(high_res_grey_img);
title('High Resolution Greyscale Image');

% Print the shape of the image
img_shape = size(high_res_img);
fprintf('Shape of Image: %d x %d\n', img_shape(1), img_shape(2));

%{ 
Low resolution image 
-----------------------
Downsampling: The high-resolution image is downsampled by a factor of 4, 
meaning that the low-resolution image will have 1/16th the number of pixels of the original.
Applying a guassian kernel of 9X9 before we downsample. This is done to reduce high-frequency noise and artifacts.

%} 

%Define the kernel size

kernel_size = [9, 9];
sigma = 1.5;

% Apply Gaussian blur
blur_img = imgaussfilt(high_res_grey_img, sigma, 'FilterSize', kernel_size);

% Downsample the image by a factor of 0.25
low_res_grey_img = imresize(blur_img, 0.25);

% Get the dimensions of the image
[height, width] = size(low_res_grey_img);

% Display the image
figure;
imshow(low_res_grey_img);
title('Low resolution Greyscale Image');
axis off;

% Print the shape of the image
fprintf('Shape of image: %d x %d\n', height, width);

%{

Extracting Patches
-------------------

1. Overlapping Patch Extraction: Overlapping nxn patches are extracted from the low-resolution grayscale image. A sliding window of size 8x8 with a stride of 1 pixel in both horizontal and vertical dimensions is used, resulting in a total of K patches.
2. Reshaping: Each patch (nxn) is flattened into a 1D array of length n^2, creating a 2D array with dimensions (K, n^2).
3. Standardization: The patches are standardized by subtracting the mean and dividing by the standard deviation of each pixel value across all patches. This step normalizes the data, which can help improve the performance of certain machine learning algorithms.

Hyper-parameter
-----------------
n : Size of patch
K : Number of patches

%}

% Patch size
patch_size = [5, 5];

% Extract patches using the im2col function
% 'sliding' is used to get all possible patches
data = im2col(low_res_grey_img, patch_size, 'sliding');

% Print the shapes
fprintf('Shape of Data: %d x %d\n', size(data,1), size(data,2));
fprintf('%d patches extracted\n', size(data,2));

data = double(data);

% Compute mean and standard deviation for each column (patch)
data_mean = mean(data, 1); % Compute the mean for each column
data_std = std(data, 0, 1); % Compute the standard deviation for each column

% Subtract the mean and divide by the standard deviation for each column
X = (data - data_mean) ./ data_std;

original_patch = reshape(data(:,100), patch_size);
scaled_patch = reshape(X(:, 100), patch_size);

figure;
subplot(1,2,1);
imshow(original_patch, []); % [] is used to scale the data for display purpose
title('Before Standardization');

subplot(1,2,2);
imshow(scaled_patch, []);   % [] is used to scale the data for display purpose
title('After standardization');
axis('off');
