% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/12/2023
% -------------------------------------------------------------------------


% Step 1: Preparing Raw Data
% Uploading raw files to EEGlab
% Defining channel locations
% Merging data across sessions
% Removing data during breaks
% Saving datasets

% This script calls 'setChanLocs' and 'removeIntervals' functions. 
% Make sure that these are in your working directory.
% Make sure to set elab and my_data_path.


% Manually edit the following three lines to define your file paths
my_data_path= 'C:\Users\YourUserName\Five-Steps-EEG-tutorial\data\'; 
my_eeglab_path = 'C:\Users\YourUserName\eeglab2022.1';
my_scripts_path =  'C:\Users\YourUserName\Five-Steps-EEG-tutorial\scripts');


% Automatically define the rest of the file paths 
load_path = [my_data_path, 'RawData\'];
save_path= [my_data_path,'\AfterStep1\'];
mkdir(save_path) ;  % Make sure your save directory exists

% Start eeglab
cd(my_eeglab_path);  addpath(my_eeglab_path);  eeglab;

% Add scripts to your path
addpath(scripts); cd(scripts);

% Define your subject IDs and their corresponding groups
subIDs = {'9011'};
subGrps = {'Patient'};

% Loop through each subject
for j = 1:length(subIDs)  
    subjectID = subIDs{j};
    fprintf('___Processing ID: %s\n',subjectID);        
    subject_load_path = [load_path,filesep,subjectID,filesep];
    subject_save_path = [save_path,filesep,subjectID,filesep]; mkdir(subject_save_path);
    
    % List all the session files for this subject
    files = dir([subject_load_path,'*.bdf']);

    % Loop through each session file
    for k = 1:length(files)
        fprintf('___File: %s\n',files(k).name); 
        EEG = pop_biosig([subject_load_path,files(k).name]);

        EEG = setChanLocs(EEG); % Set channel locations
        EEG.data = double(EEG.data); 
        
        % Merge data across sessions
        if k == 1
            temp_set = EEG; 
        else
            new_set = EEG; 
            temp_set = pop_mergeset(temp_set, new_set, 1); 
        end
    end

    % Apply further processing
    EEG = temp_set; clear temp_set new_set
    EEG = removeIntervals(EEG, subjectID, save_path); % Remove data during breaks

    % Save the processed dataset
    pop_saveset(EEG, subjectID, subject_save_path);
end

% Note: after this step, conduct a visual inspection to identify and remove significant bad regions if they exist. Reject unplugged, non-functional, or fully flat channels 