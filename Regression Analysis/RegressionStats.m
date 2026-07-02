function [param_final, param_p_array, param_residuals_array, param_last_100_array, ...
          param_error_structures, param_y_factors, param_y_range, param_fitted, param_yROIraw] = ...
          RegressionStats(deg, data, data_x, cleaning_dates, first_last100, outFile)

% CLEAN_PARAMETER_SEGMENTS
% Segment-wise cleaning of a parameter time series using interval definitions.
%
% INPUTS
%   data            : numeric data vector (e.g. temp_corrected_trp)
%   data_x          : datetime vector, same length as data
%   cleaning_dates  : N×2 datetime array of [start end] cleaning intervals
%   first_last100   : scalar initial y_factor for segment #1
%   outFile         : (string) output .mat filename
%
% OUTPUTS
%   param_final           : cleaned data vector
%   param_p_array         : N×3 array of polynomial coefficients
%   param_residuals_array : N×1 cell array of residual vectors
%   param_last_100_array  : N×100 array of last 100 values each segment
%   param_error_structures: N×1 cell array of polyfit diagnostics
%   param_y_factors       : N×1 vector of applied y_factor per segment
%   param_range =         : Represents the range of values from the
%   beginning of the segment to the last value

    if nargin < 5 || isempty(outFile)
        outFile = 'parameter_cleaning_results.mat';
    end

    param_y = data;   % working copy of data
    nSeg = size(cleaning_dates, 1);

    % Preallocate arrays
    param_p_array         = zeros(nSeg, (deg + 1) );
    param_residuals_array = cell(nSeg, 1);
    param_last_100_array  = NaN(nSeg, 100);
    param_error_structures = cell(nSeg, 1);
    param_y_factors       = NaN(nSeg, 1);
    param_y_range = NaN(nSeg,1);
    param_yROIraw = cell(nSeg, 1);
    param_fitted = cell(nSeg,1);

    counter = 0;
    % Loop through each interval
    for i = 1:nSeg
        counter = counter + 1;
        disp(counter)
        
        % Identify indices for start/end timestamps
        xID1 = find(data_x == cleaning_dates(i, 1));
        xID2 = find(data_x == cleaning_dates(i, 2));

        % Extract interval region
        x = data_x(xID1:xID2, :);
        y = param_y(xID1:xID2, :);

        param_y_range(i) = y(end) - y(1);      % signed change

        dummy_x = 1:length(x);

        % Clean spikes / fill holes
        y = fil_ol2(y);

        % Store the raw segment 
        param_yROIraw{i} = y;

        % Detrend model
        y_ROI = detrend(y, deg);

        % Fit model
        [p, S] = polyfit(dummy_x, y, deg);

        % Store structure
        param_error_structures{i} = S;

        % Compute fitted model residuals
        fitted_y = polyval(p, dummy_x);
        residuals = y - fitted_y.';

        % Store fitted_y
        param_fitted{i} = fitted_y;

        % Determine y_factor
        if i == 1
            y_factor = first_last100;
        else
            y_factor = y_last_100;
        end

        param_y_factors(i) = y_factor;

        % Apply correction
        y_corrected = y_ROI + y_factor;

        % Insert corrected segment back into main series
        param_y(xID1:xID2) = y_corrected;

        % Compute last-100 mean
        assert(~isempty(y_corrected), 'y_corrected is empty at this point');

        y_last_100 = mean(y_corrected(end-99:end));

        % Store outputs
        param_p_array(i, :)      = p;
        param_residuals_array{i} = residuals;
        param_last_100_array(i, :) = y_corrected(end-99:end).';
    end

    % Final output signal
    param_final = param_y;

    % Save outputs
    save(outFile, ...
        'param_error_structures', 'param_residuals_array', 'param_p_array', ...
        'param_final', 'param_last_100_array', 'param_y_factors', 'param_fitted', ...
        'param_yROIraw');
end
