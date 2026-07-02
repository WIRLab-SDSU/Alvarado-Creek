addpath('/MATLAB Drive/Creek Analysis/Sunflower/put_data_here')
addpath('/MATLAB Drive/Creek Analysis/Sunflower/Dependencies')

generate_cleaning_dates;



First_100_2024 = load('/MATLAB Drive/Creek Analysis/Sunflower/put_data_here/2024_first_100.mat');
First_100_2025 = load('/MATLAB Drive/Creek Analysis/Sunflower/put_data_here/dec2024_last_100.mat');

data_2024 = load('/MATLAB Drive/Creek Analysis/Sunflower/put_data_here/2024data.mat');
data_2025 = load('/MATLAB Drive/Creek Analysis/Sunflower/put_data_here/2025data.mat');


cdom2024 = data_2024.temp_corrected_cdom;
trp2024 = data_2024 .temp_corrected_trp;
cdom2025 = data_2025.temp_corrected_cdom;
trp2025 = data_2025.temp_corrected_trp;

% make a list of names
outFilenames = ["First Order", "Second Order", "Third Order", "Fourth Order", "Fifth Order"];


%% 

data_x = data_2024.t_wql;
cdom_first100 = mean(First_100_2024.cdom_first_100);
trp_first100 = mean(First_100_2024.trp_first_100);

%%
% CDOM 2024
for j = 1:5
    [param_final, param_p_array, param_residuals_array, param_last_100_array, ...
    param_error_structures, param_y_factors, param_y_range] = ...
    RegressionStats(j, cdom2024, data_x, split.CDOM_2024, cdom_first100, outFilenames(j));
end
%%
% TRP 2024
for j = 1:5
    [param_final, param_p_array, param_residuals_array, param_last_100_array, ...
        param_error_structures, param_y_factors, param_y_range] = ...
        RegressionStats(j, trp2024, data_x, split.TRP_2024, trp_first100, outFilenames(j));
end
%%

data_x = data_2025.t_wql;
cdom_first100 = First_100_2025.cdom_last_100;
trp_first100 = First_100_2025.trp_last_100;
%%
% CDOM 2025
for j = 1:5
    [param_final, param_p_array, param_residuals_array, param_last_100_array, ...
        param_error_structures, param_y_factors, param_y_range] = ...
        RegressionStats(j, cdom2025, data_x, split.CDOM_2025, cdom_first100, outFilenames(j));
end
%%
% TRP 2025
for j = 1:5
    [param_final, param_p_array, param_residuals_array, param_last_100_array, ...
        param_error_structures, param_y_factors, param_y_range] = ...
        RegressionStats(j, trp2025, data_x, split.TRP_2025, trp_first100, outFilenames(j));
end
