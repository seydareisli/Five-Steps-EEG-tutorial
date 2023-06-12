# The Five-Steps-EEG-tutorial for Preprocessing and Analysis of EEG Data

## Table of Contents
1. [Description](#description)
2. [Dependencies](#dependencies)
3. [Installation](#installation)
4. [How to Use](#howtouse)
5. [Author](#author)
6. [License](#license)

## Description <a name="description"></a>
Welcome to the Five-Steps-EEG Tutorial! This repository contains scripts for a carefully crafted protocol for simple yet robust preprocessing of EEG data for high-quality EEG analysis. It prepares the data for plotting and statistics.  

## Dependencies <a name="dependencies"></a>
The scripts require MATLAB and the EEGLAB toolbox.

## Installation <a name="installation"></a>
To use these scripts, clone this repository to your local machine.

## How to Use <a name="howtouse"></a>
The scripts are designed to be run sequentially. Each script represents a step in the preprocessing pipeline:

1. **Step 1: Processing Raw Data** - Upload raw files, define channel locations, merge data across sessions, remove data during breaks, save datasets, and conduct visual inspection for data quality control.
2. **Step 2: First Cleaning** - Resample data to 256 Hz, apply low-pass and high-pass filters, save and handle filtered data, reject and remove channels based on criteria.
3. **Step 3: Independent Component Analysis (ICA)** - Introduction to ICA, run ICA on EEG data, save and apply IC weight matrices.
4. **Step 4: IC Labeling** - Run ICLabel for labeling ICs, criteria for rejecting ICs and channels, visual inspections and data quality checks.
5. **Step 5: Epoching and Trial Averaging** - Interpolate missing channels, extract data epochs time-locked to stimulus, reject trials based on criteria, re-reference and baseline correction, average across trials and merge data.

After completing the preprocessing steps outlined in this repository, you can further analyze and visualize your data. Step-by-step instructions and scripts for these steps will be provided in a separate repository.

I highly recommend reviewing the EEGlab workshops available online, showcasing a range of instructive YouTube videos on different EEG processing steps: [Online EEGLAB Workshop](https://eeglab.org/workshops/Online_EEGLAB_Workshop.html).

## Author <a name="author"></a>
Created by Seydanur Reisli. For any questions or comments, please contact me at seydareisli @ gmail.com.

## License <a name="license"></a>
This project is licensed under the MIT License - see the LICENSE.md file for details.
