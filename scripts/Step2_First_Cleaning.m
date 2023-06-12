% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/12/2023
% -------------------------------------------------------------------------

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
    EEG = pop_loadset('filename', [subjectID, '.set'] , 'filepath', subject_load_path);
    
    % Downsample the data if needed
    EEG = pop_resample(EEG, 256); % Resample data


    % High pass filter to remove slow drifts (below 0.01 Hz)
    % Low pass filter to remove high frequency noise (above 45 Hz)
    EEG = pop_eegfiltnew(EEG, 0.01, 45, [], 0, [], 0);

    
    % Remove unnecessary channels, ensure these channels match with your dataset
    EEG = pop_select(EEG,'nochannel',{'RH','LH','RTM','LTM','RBM','LBM','Snas'}); 
    
    % Reject channels based on their spectrum, it rejects channels whose spectrum is above 3 standard deviations from the mean
    EEG = pop_rejchan(EEG, 'elec',[1:EEG.nbchan],'threshold',[-inf 3],'norm','on','measure','spec','freqrange',[1 45]);
    
    % Save the cleaned dataset
    pop_saveset(EEG, 'filename', subjectID , 'filepath', subject_save_path);
end