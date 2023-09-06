# Dictionary Learning via K-SVD: A Hyperparameter Tuning Approach

## Overview

This repository contains MATLAB scripts for image dictionary learning and reconstruction using the K-SVD algorithm and Orthogonal Matching Pursuit (OMP). It also includes tools for hyperparameter tuning through a grid search approach with 5-fold cross-validation.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Directory Setup](#directory-setup)
- [Usage](#usage)
    - [GridSearchCombinedWraper](#gridsearchcombinedwraper)
    - [GridSeachWraper](#gridseachwraper)
    - [TrainingScript.m](#trainingscriptm)
- [Steps in TrainingScript.m](#steps-in-trainingscriptm)
- [Final Notes](#final-notes)


---

## Prerequisites

Ensure you have the necessary MATLAB toolboxes installed:
1. Download `ksvdbox13` and `ompbox10` toolboxes from [Technion Software Page](https://csaws.cs.technion.ac.il/~ronrubin/software.html).
2. Obtain the Set14 dataset for training from [Kaggle Set14 Dataset](https://www.kaggle.com/datasets/ll01dm/set-5-14-super-resolution-dataset).


## Directory Setup

Adhere to the following directory structure for seamless execution:

```plaintext
.
├── Ksvd
│   ├── Images_Parameters
│   ├── Results
│   ├── Set14
│   └── code
└── ToolBoxes
    ├── ksvdbox13
    └── ompbox10
```


## Usage

### `GridSearchCombinedWraper.m`

**Purpose**: Performs a comprehensive grid search for image processing parameters across an image dataset, saving the entire results matrix.

**When to Use**: Execute this script to conduct an exhaustive grid search on multiple parameter combinations for a particular image dataset.

### `GridSeachWraper.m`

**Purpose**: Carries out a grid search for either Low-Resolution (LR) or High-Resolution (HR) images to identify the best parameters based on a specified metric.

**When to Use**: Run this script when you need to pinpoint the best image processing parameters based on a particular metric for a given image dataset.

### `TrainingScript.m`

**Purpose**: Trains a dictionary for image reconstruction and provides quality metrics of the reconstructed images, including SSIM, PSNR, and RMSE.

**When to Use**: Use this script when you have image samples and you'd like to train a dictionary, possibly using hyperparameters obtained from a prior grid search.

Certainly! Here's the updated README section integrating your request:


# Training Process

### 1. **Path Setting and Initialization**
Load the user-specific image for processing.

### 2. **User Options for Training**
Users can:
- Retrieve a pre-calculated grid search matrix.
- Load the best parameters from previous experiments.
- Manually input training parameters.

### 3. **Image Preprocessing**
The image is segmented into overlapping patches, providing input data for dictionary training.

### 4. **Dictionary Learning and Sparse Representation**
The K-SVD algorithm is employed to train a dictionary. Subsequently, the Orthogonal Matching Pursuit (OMP) is utilized for sparse representation.

### 5. **Image Reconstruction**
The image is reconstructed using the obtained sparse codes and the trained dictionary.

### 6. **Evaluation Metrics**
The quality of the reconstructed image is evaluated using the metrics:
- SSIM (Structural Similarity Index)
- PSNR (Peak Signal-to-Noise Ratio)
- RMSE (Root Mean Square Error)

### 7. **Visualization**
The visual outcomes of the process are presented as:

1. **Reconstruction of Complete Image**: 
   
   ![Original LR vs Reconstructed LR | Original HR vs Reconstructed HR](./Results/lenna/ImageReconstruction.png) 

   *This displays a side-by-side comparison of Original LR, Reconstructed LR, Original HR, and Reconstructed HR images, annotated with their SSIM and PSNR scores.*

2. **Reconstruction of a Single Patch**: 
   
   ![Original vs Reconstructed Patch](./Results/lenna/Patch.png) 

   *This illustration offers insights into the reconstruction process of an individual image patch.*

3. **Sparse Vector Visualization**:
   
   ![Sparse Vector Stem Plot](./Results/lenna/SparseCodes.png)

   *A stem plot showcasing a sparse vector, emphasizing the power law decay characteristic of the representation.*


## Final Notes

For effective execution, ensure functions like `LowResImage`, `Training`, `SinglePatchReconstructV2`, `compressibility`, `plotResultsMatrix`, and `reconstruct_from_patches_2d` are correctly imported and referenced.


## References

1. M. Aharon, M. Elad and A. Bruckstein, "K-SVD: An algorithm for designing overcomplete dictionaries for sparse representation," in *IEEE Transactions on Signal Processing*.
2. Rubinstein, Ron & Zibulevsky, Michael & Elad, Michael. (2008). Efficient Implementation of the K-SVD Algorithm Using Batch Orthogonal Matching Pursuit.



