function results_matrix = gridSearchCombined(img, patch_sizes, K_values, sparsities, iternum)
    
    % GRIDSEARCHCOMBINED Conducts a grid search over the specified parameter
    % combinations for patch size, K-values, and sparsities to evaluate their
    % impact on image reconstruction quality. For each parameter combination,
    % it uses 5-fold cross-validation and evaluates the reconstruction with
    % three metrics: RMSE, PSNR, and SSIM.
    
    % INPUTS:
    %   img           - Image(LR or HR) used for training and reconstruction.
    %   patch_sizes   - A cell array containing different patch sizes to be evaluated.
    %   K_values      - A vector containing different K-values (dictionary size) to be evaluated.
    %   sparsities    - A vector containing different sparsity levels to be evaluated.
    %   iternum       - The number of iterations for the Training function.
    %   metric        - The primary metric for evaluation ('RMSE', 'PSNR', or 'SSIM').
    
    % OUTPUTS:
    %   results_matrix - A matrix where each row corresponds to a unique parameter 
    %                    combination and its associated performance metrics. The matrix 
    %                    has the following format: 
    %                    [patch_size, K, sparsity, RMSE, PSNR, SSIM].
    
    % USAGE:
    %   results = gridSearchCombined(img, patch_sizes, K_values, sparsities, iternum, metric);
    %
    
    % NOTE:
    %   The SSIM metric, in this context, evaluates the entire reconstructed image, 
    %   while RMSE and PSNR only evaluate the validation dataset.

    total_combinations = length(patch_sizes) * length(K_values) * length(sparsities);
    completed_combinations = 0;

    % Initialize results matrix
    results_matrix = zeros(total_combinations, 7); % 4 parameters (2 for patch size) + 3 scores = 7 columns

    for p = 1:length(patch_sizes)
        current_patch_size = patch_sizes{p};
        
        X = preProcessing(img, current_patch_size);
        cv = cvpartition(size(X, 2), 'KFold', 5);

        for k = 1:length(K_values)
            for s = 1:length(sparsities)
                current_K = K_values(k);
                current_sparsity = sparsities(s);

                % Print the current parameters at the start of the iteration
                fprintf('Current Iteration Parameters: Patch Size = %d\n', current_patch_size);
                fprintf('Current Iteration Parameters: K = %d, sparsity = %d\n', current_K, current_sparsity);

                avg_scores = struct('SSIM', 0, 'PSNR', 0, 'RMSE', 0);
                start_time = tic; % Start the timer for this combination

                for fold = 1:5
                    % Extract training and validation indices for the current fold
                    training_idx = cv.training(fold);
                    validation_idx = cv.test(fold);

                    X_train_fold = X(:, training_idx);
                    X_val_fold = X(:, validation_idx);

                    D = Training(X_train_fold, X_val_fold, current_K, iternum, current_sparsity, 'off');

                    % Do prediction and evaluation(PSNR and RMSE)
                    % Y_pred_val = Prediction(D, X_val_fold, current_sparsity);
                    % Y_true_val = X_val_fold;

                    % Do prediction and evaluation(RMSE, PSNR, SSIM)
                    Y_pred_all = Prediction(D, X, current_sparsity);
                 
                    reconstructed_img = reconstruct_from_patches_2d(Y_pred_all, current_patch_size, size(img));
                    reconstructed_img_linear = (reconstructed_img - min(reconstructed_img(:))) / (max(reconstructed_img(:)) - min(reconstructed_img(:))) * 255;
                    reconstructed_img_linear = uint8(reconstructed_img_linear);

                    avg_scores.RMSE = avg_scores.RMSE + evalMetric(img, reconstructed_img_linear, 'RMSE');
                    avg_scores.PSNR = avg_scores.PSNR + evalMetric(img, reconstructed_img_linear, 'PSNR');
                    avg_scores.SSIM = avg_scores.SSIM + evalMetric(img, reconstructed_img_linear, 'SSIM');
                end

                avg_scores.RMSE = avg_scores.RMSE / 5;
                avg_scores.PSNR = avg_scores.PSNR / 5;
                avg_scores.SSIM = avg_scores.SSIM / 5;

                elapsed_time = toc(start_time); % Get elapsed time for this combination
                completed_combinations = completed_combinations + 1;
                percentage_done = (completed_combinations / total_combinations) * 100;

                % Display progress bar and elapsed time
                fprintf('Completed %d out of %d combinations (%.2f%%). Time taken for this iteration: %.2f seconds\n', ...
                        completed_combinations, total_combinations, percentage_done, elapsed_time);
                fprintf('[%s%s]\n', repmat('=', 1, round(percentage_done/2)), repmat(' ', 1, 50 - round(percentage_done/2)));

                % Update results matrix
                results_matrix(completed_combinations, :) = [current_patch_size(1), current_patch_size(2), current_K, current_sparsity, avg_scores.RMSE, avg_scores.PSNR, avg_scores.SSIM];
            end
        end
    end
end
