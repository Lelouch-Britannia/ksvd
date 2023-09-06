function [best_params, best_score, D_best] = gridSearch(img, patch_sizes, K_values, sparsities, iternum, metric)
    
    % gridSearch: Performs grid search on patch sizes, K values, and sparsity levels for dictionary learning.
    % It divides the data into 5-fold cross-validation and evaluates based on the given metric.
    %
    % Inputs:
    %   - img: The low-resolution image to be processed.
    %   - patch_sizes: A cell array containing different patch sizes to be evaluated.
    %   - K_values: A vector of dictionary sizes (number of atoms) to be evaluated.
    %   - sparsities: A vector of sparsity levels to be evaluated.
    %   - iternum: Number of iterations for the Training function.
    %   - metric: Evaluation metric ('RMSE', 'PSNR', or 'SSIM').
    %
    % Outputs:
    %   - best_params: A structure containing the best parameters found:
    %       * patch_size: Best patch size.
    %       * K: Best dictionary size.
    %       * sparsity: Best sparsity level.
    %   - best_score: Best score achieved based on the evaluation metric.
    %   - D_best: Dictionary atoms corresponding to the best_score.
    %
    % Description:
    %   The function processes the img using different patch sizes specified in patch_sizes.
    %   For each patch size, it trains dictionaries for all combinations of K_values and sparsities.
    %   5-fold cross-validation is performed to evaluate the performance of each parameter combination.
    %   For each fold, the image patches are split into training and validation sets. A dictionary is 
    %   trained using the Training function and then predictions are made on the validation set.
    %   The predictions are then evaluated based on the provided metric. The function tracks and returns 
    %   the best parameters based on the evaluation metric across all combinations.
    %
    % Note:
    %   - The 'Training' and 'Prediction' functions are assumed to be user-defined elsewhere.
    %   - The function displays a progress bar showing the percentage of combinations completed.
    %
    % Usage Example:
    %   [best_params, best_score, D_best] = gridSearch(img, {8, 16}, [50, 100], [3, 5], 10, 'RMSE');


    best_score = -inf; % Initialize for maximization problem
    best_params = struct('patch_size', [], 'K', [], 'sparsity', []);

    total_combinations = length(patch_sizes) * length(K_values) * length(sparsities);
    completed_combinations = 0;

    for p = 1:length(patch_sizes)
        current_patch_size = patch_sizes{p};
        X = preProcessing(img, current_patch_size);
        cv = cvpartition(size(X, 2), 'KFold', 5);

        for k = 1:length(K_values)
            for s = 1:length(sparsities)
                current_K = K_values(k);
                current_sparsity = sparsities(s);

                avg_score = 0;

                start_time = tic; % Start the timer for this combination
                
                for fold = 1:5
                    % Extract training and validation indices for the current fold
                    training_idx = cv.training(fold);
                    validation_idx = cv.test(fold);

                    X_train_fold = X(:, training_idx);
                    X_val_fold = X(:, validation_idx);
                    

                    D = Training(X_train_fold, X_val_fold, current_K, iternum, current_sparsity, 'off');

                    % Do prediction and evaluation
                    if strcmp(metric, 'RMSE') || strcmp(metric, 'PSNR')
                        Y_pred = Prediction(D, X_val_fold, current_sparsity);
                        Y_true = X_val_fold; % Your ground truth
                        metricScore = evalMetric(Y_true, Y_pred, metric);
                    elseif strcmp(metric, 'SSIM')
                        Y_pred = Prediction(D, X, current_sparsity );
                        img = reconstruct_from_patches_2d(X, current_patch_size, size(img));
                        reconstructed_img = reconstruct_from_patches_2d(Y_pred, current_patch_size, size(img));
                        metricScore = evalMetric(img, reconstructed_img, metric);

                    end

                    avg_score = avg_score + metricScore;
                end

                avg_score = avg_score / 5;

                elapsed_time = toc(start_time); % Get elapsed time for this combination
                completed_combinations = completed_combinations + 1;
                percentage_done = (completed_combinations / total_combinations) * 100;

                fprintf('Completed %d out of %d combinations (%.2f%%). Time taken: %.2f seconds\n', ...
                        completed_combinations, total_combinations, percentage_done, elapsed_time);

                % Display progress bar (optional)
                fprintf('[%s%s]\n', repmat('=', 1, round(percentage_done/2)), repmat(' ', 1, 50 - round(percentage_done/2)));
                
                if strcmp(metric, 'RMSE')
                    if avg_score < best_score
                        best_score = avg_score;
                        D_best = D;
                        best_params.patch_size = current_patch_size;
                        best_params.K = current_K;
                        best_params.sparsity = current_sparsity;
                    end
                elseif strcmp(metric, 'SSIM') || strcmp(metric, 'PSNR')
                    if avg_score > best_score
                        best_score = avg_score;
                        D_best = D;
                        best_params.patch_size = current_patch_size;
                        best_params.K = current_K;
                        best_params.sparsity = current_sparsity;
                    end
                end
            end
        end
    end
end

