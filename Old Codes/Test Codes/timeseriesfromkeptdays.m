function keptTS = timeseriesfromkeptdays(ts, qc, param)
% timeseriesfromkeptdays
% ts    : timetable with RowTimes (datetime)
% qc    : table with variables day (start-of-day datetime) and keepDay (logical)
% param : string/char name of column in ts (e.g., "temp", "cdom")
%
% Output:
% keptTS: timetable containing only data from days marked keepDay = true

% Extract requested variable
time = ts.Properties.RowTimes;
data = ts.(param);

% Build clean timetable with just that variable
keptTS = timetable(time, data, 'VariableNames', {char(param)});

% Find days to keep
keptDays = qc.day(qc.keepDay);
keptDays = unique(dateshift(keptDays, 'start', 'day'));

if isempty(keptDays)
    warning('No kept days found in qc.keepDay. Returning empty timetable.');
    keptTS = keptTS([],:);
    return
end

% Get day for each timestamp in ts
tsDays = dateshift(keptTS.Properties.RowTimes, 'start', 'day');

% Keep only rows whose day is in keptDays
idxKeep = ismember(tsDays, keptDays);

% Subset timetable
keptTS = keptTS(idxKeep,:);

fprintf('Kept %d rows from %d selected days.\n', height(keptTS), numel(keptDays));
end