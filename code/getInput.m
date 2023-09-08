function [patch_sizes, K_values, sparsities, metric, iternum] = getInput(flag)
    %GETINPUT Prompt the user to input parameters for grid search.
    %
    % [patch_sizes, K_values, sparsities, metric, iternum] = getInput() prompts the 
    % user to input values for patch sizes, K values, sparsities, metric, and iternum.
    % If the user does not provide a value, default values are assigned.
    %
    % Outputs:
    %   - patch_sizes : A cell array containing different patch sizes. Each 
    %                   element of the cell array should be a numeric array 
    %                   representing the dimensions of a patch (e.g., [5,5]).
    %                   Default value: {[5, 5], [8, 8]}
    %   - K_values    : A numeric array containing the desired K values.
    %                   Default value: [256, 512]
    %   - sparsities  : A numeric array containing the desired sparsity values.
    %                   Default value: [5, 10]
    %   - metric      : A string indicating the desired metric (e.g., 'RMSE').
    %                   Only allowed values: 'RMSE', 'SSIM', 'PSNR'.
    %                   Default value: 'RMSE'
    %   - iternum     : Number of iterations for the grid search. 
    %                   Default value: 10
    %
    % Usage Example:
    %   [patch_sizes, K_values, sparsities, metric, iternum] = getInput();

    % Define default values
    defaultPatchSizes = {[5, 5], [8, 8]};
    defaultKValues = [256, 512];
    defaultSparsities = [5, 10];
    defaultMetric = 'RMSE';
    defaultIterNum = 10;

    % Ask the user for input
    patch_sizes = input('Enter patch sizes as a cell array (e.g. {[5,5], [8,8]}): ', 's');
    if isempty(patch_sizes)
        patch_sizes = defaultPatchSizes;
    else
        patch_sizes = eval(patch_sizes);
    end

    K_values = input('Enter K values as a numeric array (e.g. [256, 512]): ', 's');
    if isempty(K_values)
        K_values = defaultKValues;
    else
        K_values = str2num(K_values);
    end

    sparsities = input('Enter sparsities as a numeric array (e.g. [5, 10]): ', 's');
    if isempty(sparsities)
        sparsities = defaultSparsities;
    else
        sparsities = str2num(sparsities);
    end

    if flag == 0
        
        metric = input('Enter metric as a string (e.g. "RMSE"): ', 's');
        if isempty(metric)
            metric = defaultMetric;
        end
        % Check for valid metrics
        validMetrics = {'RMSE', 'SSIM', 'PSNR', 'ALL'};
        if ~ismember(metric, validMetrics)
            error('Invalid metric provided. Please select from "RMSE", "SSIM", "PSNR" or "ALL"');
            return;
        end
    else
        metric = 'ALL';
    end

    % Get iteration number
    iternum = input('Enter the number of iterations (e.g. 10): ', 's');
    if isempty(iternum)
        iternum = defaultIterNum;
    else
        iternum = str2double(iternum);
        if isnan(iternum) || iternum <= 0
            error('Invalid number of iterations. Please provide a positive integer.');
            return;
        end
    end
end
