function compressibility(GAMMA)


    % COMPRESSIBILITY - A function to visualize the sparsity and magnitude distribution 
    % of a sparse coding matrix, GAMMA. The function computes the compressibility
    % of the matrix, which is defined as the number of non-zero values in GAMMA.
    % It then selects a random row from the matrix to generate two plots:
    % 1. A stem plot that displays the sorted non-zero coefficients, highlighting
    % the sparsity.
    % 2. A log-scale plot that displays all the coefficients in descending order
    % by magnitude, showing their power-law decay.
    
    % Usage: 
    %    compressibility(GAMMA);
    
    % Input:
    %    GAMMA - The sparse coding matrix.
    
    % Output:
    %    Two side-by-side plots and printed compressibility metrics.
    
    non_zero_count = nnz(GAMMA); % nnz counts the number of non-zero elements
    total_elements = numel(GAMMA);
    compressibility_ratio = non_zero_count / total_elements;

    fprintf('Compressibility: %d non-zero coefficients out of %d (%.2f%%)\n', non_zero_count, total_elements, compressibility_ratio*100);

    % Choose a random row from GAMMA for plotting
    random_row = randi(size(GAMMA,1));
    coefficients = GAMMA(random_row, :);

    % Non-zero coefficients for non-log plot
    non_zero_coefficients = coefficients(coefficients ~= 0);
    % Sort the non-zero coefficients by absolute value in descending order
    sorted_non_zero_coefficients = sort(abs(non_zero_coefficients), 'descend');

    % Sort coefficients by absolute value in descending order for log plot
    sorted_coefficients = sort(abs(coefficients), 'descend');

    % Create a 1x2 subplot: left for stem plot, right for log plot
    figure;

    % Stem plot of sorted non-zero coefficients
    subplot(1, 2, 1);
    stem(sorted_non_zero_coefficients, 'LineWidth', 1.5);
    xlabel('Coefficient Index (sorted by magnitude)');
    ylabel('Magnitude of Coefficient');
    title('Sorted Non-Zero Coefficients (Stem Plot)');
    grid on;

    % Log scale plot of sorted coefficients
    subplot(1, 2, 2);
    plot(sorted_coefficients, '-o', 'LineWidth', 1.5);
    xlabel('Coefficient Index (sorted by magnitude)');
    ylabel('Magnitude of Coefficient (Log Scale)');
    title('Sorted Coefficients (Log Scale)');
    set(gca, 'YScale', 'log'); % Setting logarithmic scale on the y-axis
    grid on;
end
