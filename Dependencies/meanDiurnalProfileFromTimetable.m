function results = meanDiurnalProfileFromTimetable(ts, qc, param, n)
% meanDiurnalProfileFromTimetable
% ts    : timetable with RowTimes (datetime)
% qc    : table with variables day (start-of-day datetime) and keepDay (logical)
% param : string/char name of column in ts (e.g., "temp", "cdom")
% n     : sampling interval in minutes (e.g., 10)
%
% Output:
% results: table with Hour and MeanValue (mean across kept days)

time = ts.Properties.RowTimes;
data = ts.(param);
cleanTS = timetable(time, data);

% Days to include
keptDays = qc.day(qc.keepDay);
keptDays = unique(dateshift(keptDays, 'start', 'day'));

if isempty(keptDays)
    warning('No kept days found in qc.keepDay. Returning empty results.');
    results = table([], [], 'VariableNames', {'Hour','MeanValue'});
    return
end

% Pull day chunks
dailyTables = cell(numel(keptDays), 1);
hasData = false(numel(keptDays), 1);

for i = 1:numel(keptDays)
    dayStart = keptDays(i);
    dayEnd   = dayStart + days(1) - minutes(n);

    dayTT = cleanTS(timerange(dayStart, dayEnd, 'closed'), :);

    if height(dayTT) > 0 && any(~isnan(dayTT.data))
        dailyTables{i} = dayTT;
        hasData(i) = true;
    end
end

dailyTables = dailyTables(hasData);

fprintf('Using %d kept days (with data) for mean diurnal profile.\n', numel(dailyTables));

if isempty(dailyTables)
    warning('No kept days contained usable data. Returning empty results.');
    results = table([], [], 'VariableNames', {'Hour','MeanValue'});
    return
end

% Reference time-of-day axis from first valid day
refTime = dailyTables{1}.time;
hoursOfDay = hour(refTime) + minute(refTime)/60 + second(refTime)/3600;

% Align lengths (as in your original)
minLength = min(cellfun(@height, dailyTables));

sumVals = zeros(minLength, 1);
nUsed = 0;

for i = 1:numel(dailyTables)
    v = dailyTables{i}.data(1:minLength);

    if all(isnan(v))
        continue
    end

    % Optionally, fill small gaps to avoid NaN propagation in averaging:
    % v = fillmissing(v,'linear');

    sumVals = sumVals + v;
    nUsed = nUsed + 1;
end

if nUsed == 0
    warning('All kept days were NaN after trimming. Returning empty results.');
    results = table([], [], 'VariableNames', {'Hour','MeanValue'});
    return
end

x = hoursOfDay(1:minLength);
y = sumVals / nUsed;

results = table(x, y, 'VariableNames', {'Hour','MeanValue'});
end
