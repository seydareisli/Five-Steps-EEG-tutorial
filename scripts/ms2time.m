% -------------------------------------------------------------------------
% Name: Seydanur Reisli
% Email: seydareisli@gmail.com
% Last Updated: 07/06/2023
% -------------------------------------------------------------------------

% This function converts a range of millisecond values into indices 
% corresponding to the EEGtimes array.
%
% Inputs:
%   ms: A two-element vector specifying the start and end of the time range in milliseconds.
%   EEGtimes: A 1D array representing time points in an EEG epoch, in milliseconds.
%
% Output:
%   time: A vector of indices corresponding to the input millisecond range in the EEGtimes array.

function time = ms2time(ms,EEGtimes)

    t=EEGtimes;

    % Calculate the step size between each time point in EEGtimes
    stepSize=t(2)-t(1);
    
    % Calculate the initial point in relation to a zero-based time scale
    initial=round(t(1)/stepSize);
    
    % Convert start and end of the time range from milliseconds to array indices
    x1=round(ms(1)/stepSize)+1;
    x2=round(ms(end)/stepSize)+1;
    
    % Generate an index vector for the given millisecond range, aligning with the EEGtimes array
    time = [x1 :x2]-initial;
end


