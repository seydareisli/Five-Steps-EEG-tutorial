% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/21/2023
% -------------------------------------------------------------------------

% Set Matlab Layout to Default: Go to Home tab --> Environment / Layout --> Set to Default

% Step 1: Preparing Raw Data
% Uploading raw files to EEGlab
% Defining channel locations
% Saving datasets

% This script calls 'setChanLocs' function which must be saved in your search path. 
% Define necessary paths before running this script (see my_paths.m)

% Automatically define the rest of the file paths 
load_path = [my_data_path, filesep, 'RawData'];
save_path= [my_data_path, filesep, 'AfterStep1'];
mkdir(save_path) ;  % Make sure your save directory exists

% Start eeglab
cd(my_eeglab_path);  addpath(my_eeglab_path);  eeglab;

% Add scripts to your path
addpath(my_scripts_path); cd(my_scripts_path);


% Define subject IDs 
subIDs = {'11049', '11062', '11074', '11204', '11215', '11229', '11386', ...
'10212', '10214', '10260', '10314', '10508', '10790', '10846', '10862', '10876'};

subIDs = {'10260','11215'}

% Loop through each subject
for j = 1:length(subIDs)  
    subjectID = subIDs{j};
    fprintf('___Processing ID: %s\n',subjectID);        
    subject_load_path = [load_path];
    subject_save_path = [save_path,filesep,subjectID,filesep]; mkdir(subject_save_path);
    
    subject_filename = [subjectID,'_fast_1.bdf' ];
    EEG = pop_biosig([subject_load_path,filesep,subject_filename]); %adexplore the EEG structure. events, channenls, time points, etc. 

    % Set channel locations
    EEG = setChanLocs(EEG);        

    % Apply further processing
    EEG = temp_set; clear temp_set new_set


    % If data was recorded when subject was on break, remove intervals
    % EEG = removeIntervals(EEG, subjectID, save_path); 


    % reject channels 
    % If you will not use inspect_data.m after Step 1, run auto rejchan
    % [EEG2, indelec] = pop_rejchan(EEG, 'elec',[1:EEG.nbchan],'threshold',[ -5 3],'norm','on','measure','spec','freqrange',[1 45]);


    % Save the processed dataset
    pop_saveset(EEG, subjectID, subject_save_path);
end

% Note: after this step, conduct a visual inspection to reject bad channels if they exist.
% This could include channels that are unplugged, non-functional, or fully flat.
% Use the 'inspect_data.m' script for this task.

% Also inspect raw data to remove significant bad regions if they exist. 
% (Short or slightly bad data regions can also be removed by ICA later in Step3-4)

% This code assumes that you have only one file per subject
% If you have more then one files per subject, merge them using pop_mergeset function after or within this Step (code available upon request)
