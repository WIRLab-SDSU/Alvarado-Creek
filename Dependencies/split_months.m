function monthSets_final = split_months(t_wql, trp_final, cdom_final, temp, x)
% Make a timetable 

data_table_final = timetable(t_wql,trp_final,cdom_final,temp, 'VariableNames', {'trp','cdom','temp'});

% Split the data into each month

monthSets_final = arrayfun(@(m) ...
    data_table_final(month(data_table_final.t_wql)==m , :) , ...   % rows whose month == m
    1:x, 'UniformOutput', false);