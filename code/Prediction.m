function X_pred = Prediction(D, X, sparsity)

    % This function uses a dictionary, D, to compute a sparse representation (GAMMA) of the input X. 
    % The sparse representation is then used to predict or reconstruct the patches, X_pred, based on the dictionary.
    %
    % Input:
    %   D     - Dictionary matrix. Each column represents an atom.
    %           Size: (m x n) x k (m is the dimensionality of atoms, K is the number of atoms).
    %
    %   X     - Input matrix where each column represents an observation.
    %           Size: (m X n) x N (m is the dimensionality of each observation, n is the number of observations).
    %
    % Output:
    %   X_pred - Predicted or reconstructed patches based on the dictionary and sparse codes.
    %            Size: (m X n)
    %
    % Note:
    %   The function uses Orthogonal Matching Pursuit (OMP) for sparse coding. 
    %   The actual sparsity level must be set prior to calling this function or within the OMP function 
    
    % Using OMP for sparse codes 
    GAMMA = omp(D, X, D'*D, sparsity);
    
    % Reconstruct patches
    X_pred = D * GAMMA;

end
