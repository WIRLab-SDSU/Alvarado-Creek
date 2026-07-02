function current_dataset = setupWQLdata(n,wql_monthsets)

tt = wql_monthsets{n};
[~, idx] = unique(tt.t_wql);            % or tt.Properties.RowTimes
wql_monthsets{n} = tt(sort(idx), :);    % overwrite with cleaned timetable

current_dataset = wql_monthsets{n};