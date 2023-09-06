function SinglePatchReconstructV2(D, X_test, patch_size, T)

    % SinglePatchReconstructV2: Reconstructs and visualizes a single patch.
    %
    % Input:
    %   - D           : Dictionary matrix
    %   - X_test      : Test data matrix
    %   - patch_size  : Size of each patch (usually a 2-element vector [height, width])
    %   - T           : Sparsity level (optional; default is 10)
    %
    % Procedure:
    %   1. Computes the Gram matrix of the dictionary.
    %   2. Computes the sparse representation of the test data using OMP.
    %   3. Reconstructs the test data.
    %   4. Randomly selects a patch from the test data and its reconstruction.
    %   5. Visualizes the original and reconstructed patches.
    %   6. Visualizes the stem plots comparing the original and reconstructed patch values.
    %   7. Computes and displays the SSIM, PSNR, and RMSE scores for the selected patch.
    %
    % Output:
    %   No return value. (Overlapping)Visualizations are displayed, and scores are printed to the console.


    % Check if T (sparsity) is provided
    if nargin < 4
        T = 10;  % Default sparsity
    end
    
    % Compute the Gram matrix
    G = D' * D;
    
    % Compute GAMMA_test using OMP (fast and moderate)
    GAMMA_test = omp(D, X_test, G, T);
    
    % Reconstruct X_test_reconst
    X_test_reconst = D * GAMMA_test;
    
    % Randomly select a patch
    N = size(X_test, 2);
    rand_idx = randi([1, N]);
    
    patch_original = reshape(X_test(:, rand_idx), patch_size);
    patch_reconstructed = reshape(X_test_reconst(:, rand_idx), patch_size);
    
    % Visualization
    figure;
    
    % Original and reconstructed patches
    subplot(1,2,1); imshow(patch_original, []); title('Original Patch');
    subplot(1,2,2); imshow(patch_reconstructed, []); title('Reconstructed Patch');
    
    % Overlaid stem plots
    figure;
    stem(patch_original(:), 'r', 'Marker', 'o', 'DisplayName', 'Original'); hold on;
    stem(patch_reconstructed(:), 'b', 'Marker', 'x', 'DisplayName', 'Reconstructed');
    title('Patch Values Comparison');
    xlabel('Pixel Index');
    ylabel('Pixel Intensity');
    legend('show');
    grid on;
    hold off;
    
    % 5. Compute SSIM and PSNR
    ssim_val = ssim(patch_original, patch_reconstructed);
    psnr_val = psnr(patch_original, patch_reconstructed);

    % Calculate RMSE
    rmse_val = sqrt(mean((patch_original(:) - patch_reconstructed(:)).^2));
    
    fprintf('Patch Scores \n');
    fprintf('------------- \n');
    fprintf('SSIM Score: %f\n', ssim_val);
    fprintf('PSNR Score: %f\n', psnr_val);
    fprintf('RMSE: %f\n', rmse_val);
end
