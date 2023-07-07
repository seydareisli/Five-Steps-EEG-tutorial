% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/22/2023
% -------------------------------------------------------------------------
% Step 4: IC Labeling
% Run ICLabel to label Independent Components (ICs) that ICA generated
% Define a criteria for rejecting ICs
% Reject ICs 
% Plot and save rejected components
% Perform visual inspections and data quality checks


% Define your file paths
load_path = [my_data_path, '\AfterStep3\'];
save_path = [my_data_path, '\AfterStep4\'];
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

    % Temporarily epoch the data for better ICLabel performance
    % Include all stimuli and response codes in stimuliTrigArr to epoch
    stimuliTrigArr = {1,21,22,31,32,121,122,131,132};
    EEGtemp = pop_epoch(EEG,stimuliTrigArr,[-0.1 0.9]); EEG = eeg_checkset( EEG );

    % Run ICLabel
    % Check https://labeling.ucsd.edu/tutorial/labels for more information
    EEGtemp = pop_iclabel(EEGtemp, 'beta'); EEGtemp = eeg_checkset(EEGtemp);

    % Create a variable (ICLabel_Matrix) to store ICLabel output
    % (Columns of this matrix : brain,muscle,eye,heart,line,channel,others)
    ICLabel_Matrix = EEGtemp.etc.ic_classification.ICLabel.classifications; 
    
    % Simplify the matrix by rounding the numbers and save it for documentation
    ICLabel_Matrix_Summary = round(ICLabel_Matrix*100);
    save([subject_save_path,'ICLabel_Matrix_Summary ',subjectID,'.mat'],'ICLabel_Matrix_Summary');

    % Calculate sum of noisy components
    % (Columns 2-6: muscle,eye,heart,line,channel)
    sum_of_noise = sum(ICLabel_Matrix(:,2:6),2); 

    % Identify components that have more than 50% chance of being noise
    % components and less than less then 5% chance of being brain component
    ind_noise = find(sum_of_noise>0.5 & ICLabel_Matrix(:,1)<0.05);              
    
    % Identify components that have more than 70% likihood of eye  noise
    ind_eye = find(ICLabel_Matrix(:,3)>0.5);              

    % Reject selected components. Use ind_noise OR ind_eye as criteria
    % Do it on un-epoched EEG structure (i.e., EEG, not EEGtemp)
    EEG = pop_subcomp( EEG, ind_eye, 0); EEG = eeg_checkset(EEG); 
   
    % Plot topographies of rejected ICs
    n=25; % to plot the first 25 components
    ind2mark = ind_noise(find(ind_noise<n+1)); % indices of matrices to reject
    pop_topoplot(EEG,0, [1:n]); % plot topographies

    % On top of each topo, add labels of IC# or 'REMOVED'
    for r=1:n; subplot(5,5,r); title([num2str(r)]); end 
    for r=1:length(ind2mark); subplot(5,5,ind2mark(r)); title('REMOVED'); end

    % Add subject ID on top of the plot and save the figure as image file
    sgtitle([ '                    ' subjectID]);
    print('-dtiff','-r500',[subject_save_path, 'IC topos ', subjectID,'.jpeg']);  close;
    
    % Save dataset
    pop_saveset(EEG, 'filename', subjectID , 'filepath', subject_save_path);

end



