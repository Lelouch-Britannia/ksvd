function low_res_img = LowResImage(img_loc, downsampling_factor)


    % LOWRESIMAGE Generate a low-resolution image from a high-resolution one.
    
    % Parameters:
    %   - img_loc: String, path to the input high-resolution image.
    %   - downsampling_factor: Double, the factor by which to downsample the image. 
    %                          Values less than 1 will reduce the image size.
    
    % Returns:
    %   - low_res_img: The downsampled and blurred version of the input image.
    
    % Description:
    % The function begins by reading the specified image from its location. If the 
    % image is an RGB image, it is converted to grayscale; otherwise, it is used as is.
    
    % Before downsampling, the image is blurred using a Gaussian filter. This is 
    % done to reduce high-frequency noise and artifacts which can adversely affect 
    % the appearance of the image after downsampling. The size of the Gaussian 
    % kernel used for the blur is 9x9, and it has a standard deviation of 1.5.
    %
    % The blurred image is then downsampled by the specified factor using the 
    % imresize function. The result is an image with reduced resolution which 
    % has been preprocessed to minimize artifacts.
    

    % Read the image
    img = imread(img_loc);

    % Check if the image is RGB, if yes then convert to grayscale
    if size(img,3) == 3
        img_grey = rgb2gray(img);
    else
        img_grey = img;
    end

    % Gaussian blur kernel size and sigma
    kernel_size = [9, 9];
    sigma = 1.5;

    % Apply Gaussian blur
    blur_img = imgaussfilt(img_grey, sigma, 'FilterSize', kernel_size);

    % Downsample the image by the given downsampling factor
    low_res_img = imresize(blur_img, downsampling_factor);
end
