function score = hybridMetric(Y_true, Y_pred, alpha, beta, gamma)
    rmse_val = RMSE(Y_true, Y_pred);
    ssim_val = SSIM(Y_true, Y_pred);
    psnr_val = PSNR(Y_true, Y_pred);
    
    % Assuming you want a weighted sum. Adjust as needed.
    score = alpha * rmse_val + beta * (1 - ssim_val) + gamma * (max(Y_true(:)) - psnr_val);
end

function score = RMSE(Y_true, Y_pred)
    score = sqrt(mean((Y_true(:) - Y_pred(:)).^2));
end

function score = SSIM(Y_true, Y_pred)
    score = ssim(Y_true, Y_pred);
end

function score = PSNR(Y_true, Y_pred)
    score = psnr(Y_true, Y_pred);
end