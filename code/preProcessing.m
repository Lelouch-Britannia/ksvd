function X = preProcessing(img, patch_size)

    % Extracts overlapping patches from a low-resolution image, reshapes, and standardizes them
    
    % Parameters:
    %     - img: A 2D grayscale image matrix from which patches are to be extracted
    %     - patch_size: A 1x2 vector specifying the size of patches to be extracted (m x n)
    %
    % Description:
    %     This function performs the following steps:
    %     1. Extracts overlapping patches of size m x n from the input low-resolution grayscale image
    %        The extraction is done using a sliding window approach with a stride of 1 pixel
    %
    %     2. Each m x n patch is flattened into a 1D array of size 1 x (m*n). This results in a 
    %        2D array of size (m*n) x K, where K is the number of patches extracted
    %
    %     3. The patches are then standardized:
    %        - The patches matrix is first transposed.
    %        - The mean of each column is computed.
    %        - The standard deviation of each column is computed with a small value added to avoid division by zero.
    %        - Each element of a column has its respective column mean subtracted and is then divided by its respective column standard deviation.
    %        - The matrix is then transposed back to its original shape.
    %
    % Returns:
    %     - X: A standardized 2D matrix of size (m*n) x K, where K is the number of patches.
    
 
    % Get the dimensions of the image
    [height, width] = size(img);

    % Print the shape of the low-res image
    fprintf('Shape of Low-res image: %d x %d\n', height, width);


    % Extract patches using the im2col function
    data = im2col(img, patch_size, 'sliding');

    % Convert data to double
    data = double(data);
    data = data';

    % Compute mean and standard deviation for each column (patch)
    data_mean = mean(data);
    % data_std = std(data, 0, 1) + 1e-7; % Added a small value to avoid division by zero
    data_std = std(data) + 1e-7; % Added a small value to avoid division by zero

    % Subtract the mean and divide by the standard deviation for each column
    X = (data - data_mean) ./ data_std;
    X = X';
    % Print the shape of extracted patches
    fprintf('Shape of Data: %d x %d\n', size(data,1), size(data,2));
    fprintf('%d patches extracted\n', size(data,2));

    return;
end
