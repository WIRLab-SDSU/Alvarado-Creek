function [cleaned_data, outputs] = detrendParameter(data, t, cleaning_dates, baseline_value, outFile)

%DETRENDPARAMETER Apply segment-wise cleaning/detrending to one parameter.
%
% Inputs
%   data           - corrected parameter data, e.g. temp_corrected_cdom
%   t              - datetime vector, e.g. t_wql
%   cleaning_dates - N x 2 datetime array of cleaning date pairs
%   baseline_value - scalar baseline value used by clean_parameter_segments
%   outFile        - output file prefix/name
%
% Outputs
%   cleaned_data   - final cleaned parameter
%   outputs        - structure containing diagnostics

    arguments
        data
        t
        cleaning_dates
        baseline_value
        outFile string = "cleaned_parameter"
    end

    if ~isscalar(baseline_value)
        baseline_value = mean(baseline_value, "omitnan");
    end

    [cleaned_data, p_array, residuals_array, last_100_array, ...
        error_structures, y_factors, value_range] = ...
        clean_parameter_segments(data, t, cleaning_dates, baseline_value, outFile);

    outputs = struct();

    outputs.p_array = p_array;
    outputs.residuals_array = residuals_array;
    outputs.last_100_array = last_100_array;
    outputs.error_structures = error_structures;
    outputs.y_factors = y_factors;
    outputs.value_range = value_range;
    outputs.cleaning_dates = cleaning_dates;
    outputs.baseline_value = baseline_value;
    outputs.outFile = outFile;
end
