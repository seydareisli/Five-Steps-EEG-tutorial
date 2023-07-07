% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 06/21/2023
% -------------------------------------------------------------------------

% EEG Data Visual Inspection  
% This script is designed to facilitate a semi-automated visual inspection of EEG data.
% It uses the pop_eegplot function to open a GUI for manual inspection of the data.

% List of Subject IDs
subIDs = {'11049', '11062', '11074', '11204', '11215', '11229', '11386', ...
'10212', '10214', '10260', '10314', '10508', '10790', '10846', '10862', '10876'};

% Index for selecting a subject from subIDs list
% For instance, set j = 3 to select the third subject in the list
j = 3; 
subjectID = subIDs{j};

% Define the path where your data is located
subject_load_path = [my_data_path, '\AfterStep1\', subjectID, filesep];

% Load the EEG data for the selected subject
EEG = pop_loadset('filename', [subjectID, '.set'] , 'filepath', subject_load_path);

% Identify potentially noisy channels with the pop_rejchan function
% Record the identified channels for reference
[EEGafterRej, indelec] = pop_rejchan(EEG, 'elec',[1:EEG.nbchan],'threshold',[ -inf 3],'norm','on','measure','spec','freqrange',[1 45]);

% Apply a 1 Hz high-pass filter to the data to remove drifts, simplifying visual inspection
EEGfilt1Hz = pop_eegfiltnew(EEG, 1, [], [], 0, [], 0);

% Visually inspect the EEG data to confirm the identified bad channels
% When the GUI pops up, set the time range to 20 ms for easier visual inspection
pop_eegplot( EEGfilt1Hz, 1, 0, 1);
pop_eegplot( EEG, 1, 0, 1);

% Specify the channels to reject based on your inspection
% TODO: Modify this list for each subject based on your visual inspection
chans_to_reject = {'Iz','PO8'};

% Reject the specified channels from the data
EEG = pop_select(EEG,'nochannel',chans_to_reject); 

% Save the inspected data with the suffix "_inspected"
pop_saveset(EEG, 'filename',[subjectID,'_inspected'],'filepath',subject_load_path);

% Document your findings for each subject. Consider the following questions:
% 1. Did pop_rejchan identify any bad channels? If so, which ones?
% 2. Does the subject's README file mention any bad channels?
% 3. Are there any channels that are fully flat?
% 4. After your visual inspection, which channels do you decide to reject?


%-----------------------------------------------------------

% Also inspect raw data to remove significant bad regions if they exist. 
% (Short or slightly bad data regions can also be removed by ICA later in Step3-4)

% Try the eegrej function by defining the time interval to reject. 
% e.g., EEG = eeg_eegrej( EEG, [start_time   end_time ]), 
% or plot the data for scrolling, and highlight the regions to reject via mouse
% and save the dataset after rejection

