% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/22/2023
% -------------------------------------------------------------------------
% Step 3: Independent Component Analysis (ICA)
% Run ICA after a temporary 1 Hz filter
% Apply IC weight matrices on unfiltered data


% Start eeglab
cd(my_eeglab_path);  addpath(my_eeglab_path);  eeglab;

% Add scripts to your path
addpath(my_scripts_path); cd(my_scripts_path);


% Define your file paths
load_path = [my_data_path, '\AfterStep2\'];
save_path = [my_data_path, '\AfterStep3\'];
mkdir(save_path); % Ensure save directory exists

% Define subject IDs 
subIDs = {'11049', '11062', '11074', '11204', '11215', '11229', '11386', ...
'10212', '10214', '10260', '10314', '10508', '10790', '10846', '10862', '10876'};

% Loop through each subject
for j = 1:length(subIDs)
    % Define subjectID for the current iteration
    subjectID = subIDs{j};
    
    % Print out the subject ID currently being processed
    fprintf('___Processing ID: %s\n', subjectID);        
    
    % Define the full path to the subject's .set file
    subject_load_path = [load_path, subjectID, filesep];
    subject_save_path = [save_path, subjectID, filesep]; mkdir(subject_save_path); 

    % Load the subject's EEG dataset
    EEG = pop_loadset('filename', [subjectID, '.set'] , 'filepath', subject_load_path);

    % Apply a temporary high pass filter to remove slow drifts (below 1 Hz)
    EEG_1Hz_filtered = pop_eegfiltnew(EEG, 1, [], [], 0, [], 0);


    % Run Independent Component Analysis (ICA)
    tic; %start counting the time
    EEG_ICAed = pop_runica(EEG_1Hz_filtered, 'extended',1); 
    toc/60 % see how many minutes it took

    % Get ICA weights
    wei =  EEG_ICAed.icaweights;
    sph =  EEG_ICAed.icasphere;

    % Re-Load the old EEG dataset and apply ICA weights
    EEG_05Hz_filtered = pop_loadset('filename', [subjectID, '.set'] , 'filepath', subject_load_path);
    
    % APPLY ICA 
    EEG_05Hz_filtered.icaweights = wei;
    EEG_05Hz_filtered.icasphere = sph;
    EEG_05Hz_filtered = eeg_checkset(EEG_05Hz_filtered, 'ica');
    
    EEG=EEG_05Hz_filtered; 
 
    % Save dataset
    pop_saveset(EEG, 'filename', subjectID , 'filepath', subject_save_path);
end