function score = evalMetric(Y_true, Y_pred, metric)

    % Inputs:
    %   Y_true  - Ground truth image.
    %   Y_pred  - Predicted image.
    %   metric  - String indicating the metric to compute. Supported metrics include: 'SSIM', 'RMSE', 'PSNR'.
    
    % Outputs:
    %   score   - Value of the specified metric.
    
    % Example:
    %   score = evalMetric(originalImage, compressedImage, 'PSNR');
    
    % Notes:
    %   - For the 'SSIM' metric, the MATLAB Image Processing Toolbox function 'ssim' is used.
    %   - For the 'RMSE' metric, the root mean square error is computed.
    %   - For the 'PSNR' metric, the MATLAB Image Processing Toolbox function 'psnr' is used.
    %   - If an unsupported metric is provided, an error is raised.

    switch metric
        case 'SSIM'
            score = SSIM(Y_true, Y_pred);
        case 'RMSE'
            score = RMSE(Y_true, Y_pred);
        case 'PSNR'
            score = PSNR(Y_true, Y_pred);
        otherwise
            error('Invalid metric specified.');
    end
end

function score = RMSE(Y_true, Y_pred)
    
    % Inputs:
    %   Y_true - Ground truth image.
    %   Y_pred - Predicted image.
    %
    % Outputs:
    %   score  - Root Mean Square Error between the two images.

    score = sqrt(mean((Y_true(:) - Y_pred(:)).^2));
end

function score = SSIM(Y_true, Y_pred)
    
    % Inputs:
    %   Y_true - Ground truth image.
    %   Y_pred - Predicted image.
    %
    % Outputs:
    %   score  - Structural Similarity Index between the two images.

    score = ssim(Y_true, Y_pred);
end

function score = PSNR(Y_true, Y_pred)

    % Inputs:
    %   Y_true - Ground truth image.
    %   Y_pred - Predicted image.
    %
    % Outputs:
    %   score  - Peak Signal-to-Noise Ratio between the two images.

    score = psnr(Y_true, Y_pred);
end
