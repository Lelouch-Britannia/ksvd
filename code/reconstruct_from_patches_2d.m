function reconstructed_img = reconstruct_from_patches_2d(patches, patch_size, image_size)
    
    % RECONSTRUCT_FROM_PATCHES_2D Reconstructs an image from its overlapping patches.
    
    % Parameters:
    %   - patches: A 2D matrix where each column is a flattened version of a 2D patch
    %   - patch_size: A 1x2 vector specifying the dimensions of the patch (m x n)
    %   - image_size: A 1x2 vector specifying the dimensions of the full image to be reconstructed (M X N)
    
    % Returns:
    %   - reconstructed_img: The reconstructed image from the patches.
    
    % Description:
    % The function first reshapes the flattened patches into a 3D matrix where each
    % "slice" corresponds to a 2D patch. It then initializes an empty image of the desired size.
    
    % The function proceeds to fill the image with the patches. It does this by iterating
    % over the image starting from the top-left corner, moving from top to bottom,
    % and then from left to right. Patches are added in their respective locations, and 
    % since the patches may overlap, the values in the overlapping regions are summed up.
    
    % After all patches have been placed, the function adjusts the values in the reconstructed 
    % image based on the number of overlapping patches for each pixel. This ensures that the 
    % final pixel values are the average of the corresponding values from the overlapping patches.
    
    % Note:
    % This implementation assumes that the patches are overlapping and that they cover the entire image.
    

    % Get dimensions
    M = image_size(1);
    N = image_size(2);
    m = patch_size(1);
    n = patch_size(2);

    % Unflatten patches matrix
    patches = reshape(patches, m, n, []);

    % Compute the dimensions of the patches array
    n_h = M - m + 1;
    n_w = N - n + 1;
    
    % Create the empty image
    img = zeros(M, N);
    
    % Fill the image with patches (Top to bottom then L to R)
    patch_num = 1;
    for j = 1:n_w
        for i = 1:n_h
            img(i:i+m-1, j:j+n-1) = img(i:i+m-1, j:j+n-1) + patches(:,:,patch_num);
            patch_num = patch_num + 1;
        end
    end
    
    % Adjust based on overlap (using the logic from Python implementation)
    for i = 1:M
        for j = 1:N
            overlap_factor = min([i, m, M - i + 1]) * min([j, n, N - j + 1]);
            img(i,j) = img(i,j) / overlap_factor;
        end
    end
    
    reconstructed_img = img;
end
