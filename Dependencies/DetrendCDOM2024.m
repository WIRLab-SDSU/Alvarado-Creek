% Define multiple pairs of cleaning dates
load('2024_first_100.mat')
% we can make some commentary about the degree of fouling wet seasons vs
% dry seasons 
% manually input dates
cleaning_dates = split.CDOM_2024;

data = temp_corrected_cdom; 
data_x = t_wql;
data_y = data;
first_last100 = mean(cdom_first_100);
outFile = "cdom_result_report";

[cdom_final, cdom_p_array, cdom_residuals_array, cdom_last_100_array, ...
          cdom_error_structures, cdom_y_factors, cdom_range] = ...
          clean_parameter_segments(data, data_x, cleaning_dates, first_last100, outFile);

% Plot result

figure;
plot(t_wql, cdom_final, 'LineWidth', 1.2);
xlabel('Time');
ylabel('Cleaned Parameter');
title('Parameter After Segment-Wise Cleaning');

% Add vertical lines at all start/end datetimes
all_dates = cleaning_dates(:);   % convert N×2 → 2N×1 list

for k = 1:length(all_dates)
    xl = xline(all_dates(k), '--', ...
        'Color', [0.7 0 0.7], 'LineWidth', 1.0);

    xl.HandleVisibility = 'off';
    xl.PickableParts   = 'none';
    xl.HitTest         = 'off';
end
