## Dictionary Learning using KSVD and Hyper parameter tuning 

### Task:
The `TrainingScript.m` MATLAB script focuses on training and reconstructing images using sparse coding techniques. The primary goal is to enhance the resolution or quality of given low/high-resolution images. The reconstruction leverages the K-SVD algorithm, Orthogonal Matching Pursuit (OMP), and dictionary learning methods.

### Prerequisite:

Before running the script, please download the necessary toolboxes from [this link](https://csaws.cs.technion.ac.il/~ronrubin/software.html). Once downloaded, place the toolboxes (`ksvdbox13` and `ompbox10`) in the directory structure as described in the script. Ensure that they are correctly located so that the script can access them seamlessly.

Additionally, download the Set14 dataset used for the training from [Kaggle Set14 Dataset](https://www.kaggle.com/datasets/ll01dm/set-5-14-super-resolution-dataset). After downloading the dataset, place it in the `Set14` directory as specified in the script.

### Directory Structure

To set up the directory structure as required, please refer to the tree diagram below:

![Directory Structure](./ksvd/miscellaneous/DirectoryStructure.png)

### How it's solved:

1. **Path Setting and Initialization**:
   - Sets up required paths for toolboxes and directories.
   - Asks the user for an input image location and loads it.

2. **User Options for Training**:
   - Offers three main options to the user:
     1. Load a matrix of previously computed results.
     2. Load best parameters saved from prior experiments.
     3. Enter training parameters manually.
   - Based on the chosen option, the script retrieves or asks for parameters like patch size, dictionary size (K), and sparsity constraints.

3. **Image Preprocessing**:
   - Converts the input image to grayscale if it's an RGB image.
   - Breaks the image into overlapping patches, preparing it for dictionary training.

4. **Dictionary Learning and Sparse Representation**:
   - If best parameters aren't loaded, it trains a dictionary `D` using K-SVD algorithm on the training patches. This dictionary will be used to sparsely represent the image patches.
   - Uses Orthogonal Matching Pursuit (OMP) to get sparse representations (`GAMMA`) of the image patches using the dictionary `D`.

5. **Image Reconstruction**:
   - Reconstructs the image from the sparse codes and the dictionary.
   - Rescales the reconstructed image values to fit within the [0, 255] range.

6. **Evaluation**:
   - Computes three quality metrics for the reconstructed image against the original: SSIM (structural similarity), PSNR (peak signal-to-noise ratio), and RMSE (root mean square error).

7. **Visualization**:
   - Displays the original and the reconstructed images side by side for visual comparison.

To successfully run this script, ensure the necessary functions like `LowResImage`, `Training`, `SinglePatchReconstructV2`, `compressibility`, `plotResultsMatrix`, and `reconstruct_from_patches_2d` are implemented or imported accordingly.