function plotResultsMatrix(results_matrix)

    % PLOTRESULTSMATRIX Visualizes the performance metrics RMSE, PSNR, and SSIM
    % for different parameter combinations. The function generates three subplots,
    % each dedicated to a metric, showcasing the performance for various combinations
    % of parameters.
    
    % INPUTS:
    %   results_matrix - A matrix where each row represents a unique combination 
    %                    of parameters and the corresponding performance metrics.
    %                    The matrix should have the following format:
    %                    [patch_size, K, sparsity, RMSE, PSNR, SSIM].
    %
    % OUTPUTS:
    %   None. This function directly generates a figure with three subplots.
    
    % USAGE:
    %   plotResultsMatrix(results_matrix);
    
    % EXAMPLE:
    %   Assuming `results` is a matrix containing the appropriate data:
    %   plotResultsMatrix(results);

    num_combinations = size(results_matrix, 1);

    % Extracting parameters and metrics from the results matrix
    patch_sizes = results_matrix(:, 1);
    Ks = results_matrix(:, 3);
    sparsities = results_matrix(:, 4);
    RMSEs = results_matrix(:, 5);
    PSNRs = results_matrix(:, 6);
    SSIMs = results_matrix(:, 7);

    % Generating labels for each parameter combination
    labels = cell(num_combinations, 1);
    for i = 1:num_combinations
        labels{i} = sprintf('P:%d, K:%d, S:%d', patch_sizes(i), Ks(i), sparsities(i));
    end

    % Plotting
    figure;
    
    % RMSE
    subplot(3, 1, 1);
    bar(RMSEs, 'b');
    title('RMSE for Different Parameter Combinations');
    ylabel('RMSE Score');
    set(gca, 'XTick', 1:num_combinations, 'XTickLabel', labels, 'XTickLabelRotation', 45);
    
    % PSNR
    subplot(3, 1, 2);
    bar(PSNRs, 'r');
    title('PSNR for Different Parameter Combinations');
    ylabel('PSNR Score');
    set(gca, 'XTick', 1:num_combinations, 'XTickLabel', labels, 'XTickLabelRotation', 45);
    
    % SSIM
    subplot(3, 1, 3);
    bar(SSIMs, 'g');
    title('SSIM for Different Parameter Combinations');
    ylabel('SSIM Score');
    set(gca, 'XTick', 1:num_combinations, 'XTickLabel', labels, 'XTickLabelRotation', 45);
    ylim([0.9 1.0]); % Adjusting y-axis limits for SSIM
end
