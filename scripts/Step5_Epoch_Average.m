% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/28/2023
% -------------------------------------------------------------------------
% Step 5 
% Interpolate missing channels
% Extract data epochs time-locked to stimulus
% Reject trials based on criteria
% Re-reference and baseline correction
% Average across trials and merge data


% Define your file paths
load_path = [my_data_path, '\AfterStep4\'];
save_path = [my_data_path, '\AfterStep5\'];
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


    % Interpolate 
    load('chanlocs64.mat'); % or just upload a 64-chan-EEG and get EEG.chanlocs
    EEG = pop_interp(EEG, chanlocs, 'spherical'); EEG = eeg_checkset( EEG );

    EEG = fixPortCodes(EEG);
    

    % Define trigger codes (to time lock to stimulus in the next step)
    stimuliTrigArr = {1,21,22,31,32,121,122,131,132};
    cases = {21,22,31,32,121,122,131};


    % Extract data epochs from -100 to 600 ms (in second)
    EEG = pop_epoch(EEG,stimuliTrigArr,[-0.1 0.6]); EEG = eeg_checkset( EEG );
    
    % Remove baseline (in millisecond) 
    EEG = pop_rmbase( EEG, [-100 0] ,[]); 
    
    % Create events and evConds that way:
    ERPs = EEG.data; 
    t=EEG.times; 
    events=[];  
    n_trials=size(ERPs,3); 
    for e=1:n_trials
        code=EEG.epoch(e).eventtype{1}; 
        events=[events code]; 
    end
    clear EEG

    %define a threshold for rejecting trials above/below a certain amplitude
    thr=80; 

    %You could also define a specific threshold for each subject separately
    %maxVals = squeeze(max(max(abs(ERPs)))); maxVals(maxVals>150) = [];
    %thr = mean(maxVals) + 2* std(maxVals)

    %Start an empty variable to keep indices of bad trials 
    ind_bad_trials = []; 

    %Reject trials 
    n_trials=size(ERPs,3);
    
    %Loop through all trials
    for e=1:n_trials
        if max(max(abs(ERPs(:,:,e))))>thr %get the maximum of all channels, all time points
            ind_bad_trials= [ ind_bad_trials e]; 
        end
    end

    ERPs(:,:,ind_bad_trials) = []; 
    events(:,ind_bad_trials) = [];  
    n_trials=size(ERPs,3);
    
    
    % Calculate the average of all channels as ref_data
    ref_data=mean(ERPs,1); 

    % You can also reference to the average of select channels (eg., ch1, ch2)
    % ref_data=mean(ERPs([ch1 ch2],:,:),1); 

    % Reference to ref_data
    ERPs = ERPs - ref_data; 

    % Get ready to create a 3D variable called "avgERPs"(3D:timepoints,cases,channels) 
    n_times = length(t); 
    n_cases = length(stimuliTrigArr); % 9 
    n_chans = length(chanlocs); % 64

    % Create a placeholder variable with all zeros to store averaged voltages
    % Once we're in the loop later, zeros will transform to real numbers
    avgERPs = zeros(n_times, n_cases, n_chans); 

    % Loop through all channels and cases, and average across trials for
    % each trial type (cases). Save results to avgERPs (replacing zeros)
    for ch=1:n_chans
        for cs=1:length(cases)
            trig = cases{cs};
            ind_trig = find(ismember(events, trig)); %find indices of trials for this trig
            data=ERPs(ch,:,ind_trig); % select data belonging to those trials
            avgERPs(:,cs,ch) = mean(data,3); % average across trials for this trig
        end
    end

    save([subject_save_path,filesep,subjectID,'.mat'],'avgERPs','events','t');

end

% Pre-processing is complete now! Ready to plot waveforms and topos.

