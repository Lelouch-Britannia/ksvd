function D = Training(X_train, X_test, K, iternum, sparsity, flag)

    % TRAINING - Reconstruct an image based on K-SVD dictionary learning.
    %
    % Syntax: D = Training(X_train, X_test, K, iternum, sparsity, flag)
    %
    % Inputs:
    %    X_train  - Training data
    %    X_test   - Test data
    %    K        - Number of atoms in the dictionary
    %    iternum  - (Optional) Number of iterations, default is 50
    %    sparsity - (Optional) Target sparsity, default is 10
    %    flag     - If set to 'on', it will plot the RMSE values
    %
    % Outputs:
    %    D        - Learned dictionary
    %
    % Example:
    %    D = Training(train_data, test_data, 100);
    %    D = Training(train_data, test_data, 100, 50, 10, 'on');
    %
    % This function initializes the dictionary with K randomly selected
    % training signals and then runs the K-SVD algorithm. If the flag
    % is set to 'on', it will plot the RMSE values for both training and
    % test data over the iterations.
    % 
    % Note: This function requires the 'ksvd' function to operate.
    % Function to reconstruct an image based on K-SVD dictionary learning

    % Default values for optional parameters
    if nargin < 3
        iternum = 50;  % Default number of iterations
    end
    if nargin < 4
        sparsity = 10;  % Default target sparsity
    end
    

    % Setting K-SVD parameters
    params.data = X_train;
    params.testdata = X_test;       % Assign test data to 'testdata' field
    params.Tdata = sparsity;        % Target sparsity
    params.dictsize = K;            % Number of atoms in dictionary
    params.iternum = iternum;       % Number of iterations
    params.memusage = 'normal';     % Memory usage level
    params.muthresh = 0.99;         % Mutual incoherence threshold

    % Initialize dictionary with K randomly selected training signals
    params.initdict = datasample(X_train, K, 2); 

    % Running K-SVD algorithm
    fprintf('Learning the dictionary...\n');
    [D, GAMMA, ERR, GERR] = ksvd(params, 't');

    if strcmpi(flag, 'on')
        % Plotting RMSE values
        figure;
        plot(1:iternum, ERR, 'b', 'LineWidth', 2); % blue line for training RMSE
        hold on;
        plot(1:iternum, GERR, 'r', 'LineWidth', 2); % red line for test RMSE
        xlabel('Iteration Number');
        ylabel('RMSE');
        title('RMSE on Training and Test Data');
        legend('Training', 'Test');
        hold off;
    end
end
