% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/12/2023
% -------------------------------------------------------------------------

% Start eeglab
cd(my_eeglab_path);  addpath(my_eeglab_path);  eeglab;


% Define your file paths
load_path = [my_data_path, '\AfterStep1\'];
save_path = [my_data_path, '\AfterStep2\'];
mkdir(save_path); % Ensure save directory exists


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
    % If you used inspect_data.m, you may need to load [subjectID, '_inspected.set']
    EEG = pop_loadset('filename', [subjectID, '.set'] , 'filepath', subject_load_path);
    
    % Downsample the data (optional)
    EEG = pop_resample(EEG, 512);  


    % High pass filter to remove slow drifts (below 0.05 Hz)
    % Low pass filter to remove high frequency noise (above 45 Hz)
    EEG = pop_eegfiltnew(EEG, 0.05, 45, [], 0, [], 0);

        
    % Optional second rejection of channels
    % EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan],'threshold',[-inf 3],'norm','on','measure','spec','freqrange',[1 45]);
    
    % Save the cleaned dataset
    pop_saveset(EEG, 'filename', subjectID , 'filepath', subject_save_path);
end