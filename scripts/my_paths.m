
% Define file paths for EEGlab, raw data, and scripts
% Note: You must manually edit the following three lines to reflect your actual file paths

% EEGlab Path:
% First, download EEGlab from their official website. After installation, locate the EEGlab directory on your computer and copy its full path here.
% IMPORTANT: Replace the path below with the path to your eeglab directory.
my_eeglab_path = 'C:\Users\seyda\Desktop\eeglab_current\eeglab2022.1\';
% Note: For Mac Users, the path should be something like 'Users/seyda/Desktop/eeglab_current/eeglab2022.1/

% Data Path:
% Create a directory on your computer to store the data for this project. Within this directory, create a subdirectory named "RawData".
% The raw data files (.bdf files) should be saved within "RawData" folder.
% IMPORTANT: Replace the path below with the path to your data directory.
my_data_path= 'C:\Users\seyda\Desktop\Github\data\'; 

% Scripts Path:
% Locate the "scripts" directory that stores tutorial scripts on your computer and copy its full path here.
% IMPORTANT: Replace the path below with the path to your scripts directory.
my_scripts_path =  'C:\Users\seyda\Desktop\Github\Five-Steps-EEG-tutorial\scripts\';

% Note on file separator (filesep):
% The symbol used to separate directories in a file path depends on your operating system.
% Windows uses a backslash (\) while Unix/Mac systems use a forward slash (/).
% To make your scripts cross-platform, use the 'filesep' function in MATLAB when constructing file paths.
% This function will automatically use the correct symbol for the current operating system.
% Example: my_full_path = [my_directory_path, filesep, my_filename];
