% Define multiple pairs of cleaning dates
load('/MATLAB Drive/Creek Analysis/Sunflower/put_data_here/dec2024_last_100.mat')
load('/MATLAB Drive/Creek Analysis/Sunflower/put_data_here/2025data.mat')

cleaning_dates = split.TRP_2025;

data = temp_corrected_trp; 
data_x = t_wql;
data_y = data;
first_last100 = trp_last_100;
outFile = "trp_result_report";

[trp_final, trp_p_array, trp_residuals_array, trp_last_100_array, ...
          trp_error_structures, trp_y_factors, trp_range] = ...
          clean_parameter_segments(data, data_x, cleaning_dates, first_last100, outFile);

% Plot result

figure;
plot(t_wql, trp_final, 'LineWidth', 1.2);
xlabel('Time');
ylabel('Cleaned Parameter');
title('Parameter After Segment-Wise Cleaning');

% Add vertical lines at all start/end datetimes
all_dates = cleaning_dates(:);   % convert N×2 → 2N×1 list

for k = 1:length(all_dates)
    xline(all_dates(k), '--', 'Color', [0.7 0 0.7], 'LineWidth', 1.0); % purple dashed
end

