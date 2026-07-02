function [cdom_final, cdom_outputs] = detrendCDOM( ...
    t_wql, temp_corrected_cdom, cleaning_dates, cdom_first_100, outFile)

%DETRENDCDOM Apply segment-wise detrending/cleaning to corrected CDOM.
%
% Inputs
%   t_wql               - WQL datetime vector
%   temp_corrected_cdom - temperature-corrected CDOM vector
%   cleaning_dates      - N x 2 datetime array of cleaning start/end dates
%   cdom_first_100      - first 100 baseline CDOM values
%   outFile             - output file name or prefix
%
% Outputs
%   cdom_final          - cleaned CDOM result
%   cdom_outputs        - structure containing diagnostics and intermediate outputs

    arguments
        t_wql
        temp_corrected_cdom
        cleaning_dates
        cdom_first_100
        outFile string = "cdom_result_report"
    end

    data = temp_corrected_cdom;
    data_x = t_wql;

    first_last100 = mean(cdom_first_100, "omitnan");

    [cdom_final, cdom_p_array, cdom_residuals_array, cdom_last_100_array, ...
        cdom_error_structures, cdom_y_factors, cdom_range] = ...
        clean_parameter_segments(data, data_x, cleaning_dates, first_last100, outFile);

    cdom_outputs = struct();

    cdom_outputs.p_array = cdom_p_array;
    cdom_outputs.residuals_array = cdom_residuals_array;
    cdom_outputs.last_100_array = cdom_last_100_array;
    cdom_outputs.error_structures = cdom_error_structures;
    cdom_outputs.y_factors = cdom_y_factors;
    cdom_outputs.range = cdom_range;
    cdom_outputs.cleaning_dates = cleaning_dates;
    cdom_outputs.first_last100 = first_last100;
end
