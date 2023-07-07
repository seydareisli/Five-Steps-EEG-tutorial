% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 07/07/2023
% -------------------------------------------------------------------------
% Introduction to Plotting in Matlab

%--------------------------------------------
% Part I: The basics of plotting in Matlab via single subject data

% Define your file paths
load_path = [my_data_path, '\AfterStep5\'];


% Load sample subject data 
% (This loads first subject's avgERPs which has a size of n_times x n_cases x n_chans)
subID='11049';
load([my_data_path, filesep,'AfterStep5',filesep,subID,filesep,subID,'.mat'],'avgERPs','t');


% Decide what channel and case you want to plot  
ch=34;  % In Biosemi 64 channel cap, Cz: 48, Cpz:32, Pz: 31, Poz:30, etc. 
cs=3;  % Pick a case which you defined in Step 5 with port codes


% Select your data for plotting
V = avgERPs(:,cs,ch); % Select all time points for a given case and channel


% Open a new figure and plot the data using default properties
figure;
plot(t, V);

% Specify plot properties like line width and color
myColor=[1/255, 66/255, 66/255];
plot(t, V,'lineWidth',3, 'color', myColor);

% Plot 2 figures within a larger figure using subplot
figure; 
subplot(2,1,1); plot(t, V);
subplot(2,1,2); plot(t, V,'lineWidth',3, 'color', myColor);

% Add vertical or horizontal lines at 0
subplot(2,1,1); yline(0,'--k'); 
subplot(2,1,2); xline(0,'--k');

% Adjust y-axis limits
subplot(2,1,1); ylim([-15 10]);
subplot(2,1,2); ylim([-15 10]);


%--------------------------------------------
% Part II: Plotting group averages with allERPs

% Load allERPs
load([my_data_path,filesep,'allERPs.mat'],'allERPs','subIDs','t');


% Define groups (adjust the next two lines based on your subjects)
ind_autism=[1:7];
ind_control=[8:16];

% Compute the average of control data
V=allERPs(:,:,:,ind_control);
V_NT = mean(V,4);

% Compute the average of autism data
V=allERPs(:,:,:,ind_autism);
V_ASD = mean(V,4);


%--------------------------------
% Part III:  Plot group averages for a given channel and condition/trigger
ch=31;
cs=3;

figure;
plot(t, V_NT(:,cs,ch),color='b'); % b for blue
hold on; % use "hold on" to plot on top of the previous plot
plot(t, V_ASD(:,cs,ch),color='r'); % r for red
title(['Channel', num2str(ch)])

%----------------------------------------

% Plot channel numbers on a topomap to pick channels 
figure; topoplot('',chanlocs,'maplimits', maplim,'electrodes','numbers');

%--------------------------------
% Part IV:  Plot average of several channels rather than a single channel

chans_near_Pz=[30,31,32,20,57]; %Pz:31
cs=3;

figure;
V1=mean(V_NT(:,cs,chans_near_Pz),3); % average of selected five channels
V2=mean(V_ASD(:,cs,chans_near_Pz),3);

plot(t, V1 ,color='b'); % b for blue
hold on; % use "hold on" to plot on top of the previous plot
plot(t, V2 ,color='r'); % r for red
title('Avg of five channels near Pz')

%----------------------------------------
% Part V: Topoplots


% Select time interval for topography around 170 ms for average of neurotypical 
x=170;  y =10;  
time_interval = [x-y: x+y];

% Convert milliseconds to time points using ms2time function
time = ms2time(time_interval,t);

% Select data for time points of interest 
cs=3;
V_NT_topo = V_NT(time_interval,cs,:);

% Average selected time points
V_NT_topo_avg = mean(V_NT_topo, 1);
data = squeeze(V_NT_topo_avg);

% Load channel locations and plot topography
load('chanlocs64.mat');
figure; 
topoplot(data,chanlocs);

% Define map limits and plot the topography
maplim = [-3 3];
figure; topoplot(data,chanlocs,'maplimits', maplim,'electrodes','off'); cbar('vert'); 

% Add title
sgtitle(['NT ', num2str(x),'ms'] );



