
%turn this into a function 
function processUSGSData(filename, outputfilename)

data_table = timetable(filename.t_wlvl,filename.w_lvl, 'VariableNames', {'water_level'});
%% 

USGSmonthSets = arrayfun(@(m) ...
    data_table(month(data_table.Time) == m, :), ...
    1:9, 'UniformOutput', false);
%% 

save(outputfilename, 'USGSmonthSets')
