% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 07/06/2023
% -------------------------------------------------------------------------
% Merge all data after Step 5 
% load avgERPs (3D Matrix we saved for each subject in Step 5) 
% merge them into a single variable (4D Matrix called allERPs)
%avgERPs: 3D: n_times x n_cases n_chans
%allERPs: 3D: n_times x n_cases n_chans x n_subj


% Define your file paths
load_path = [my_data_path, '\AfterStep5\'];

% Define subjects
subIDs = {'11049', '11062', '11074', '11204', '11215', '11229', '11386', ...
'10212', '10214', '10260', '10314', '10508', '10790', '10846', '10862', '10876'};
n_subj = length (subIDs);


% Load sample subject data to get n_times , n_cases , n_chans
subID=subIDs{1};
load([load_path,filesep,subID,filesep,subID,'.mat'],'avgERPs','events','t');
[n_times , n_cases , n_chans] = size(avgERPs);


% Define a dummy allERPs variable with a size of n_times x n_cases n_chans x n_subj
allERPs= zeros(n_times , n_cases , n_chans, n_subj); 


% Change these zeros to real numbers within a loop
for j = 1:length(subIDs)
    subjectID = subIDs{j};
    load([load_path, filesep, subjectID, filesep, subjectID,'.mat']);
    allERPs(:,:,:,j) = avgERPs;
end

% print a random value to make sure it's non zero: 
allERPs(3,3,3,3) % check point)


% save allERPs
save([my_data_path,filesep,'allERPs.mat'],'allERPs','subIDs','t');


