function [stdTOD, mTOD, mTOD_str] = stat_rep(y_vec, t_vec)
%STAT_REP  Daily peak timing (midnight->midnight), then across-day circular stats
% Outputs:
%   mTOD      : circular mean peak time-of-day across days (hours, 0..24)
%   stdTOD    : circular std across days (hours)
%   mTOD_str  : formatted 'HH:MM'

    % --- Remove duplicate timestamps (e.g., DST fall-back) ---
    [t_vec, idx] = unique(t_vec);
    y_vec = y_vec(idx);

    % --- Day buckets (midnight start) ---
    dayStart   = dateshift(t_vec, 'start', 'day');
    uniqueDays = unique(dayStart);
    nDays      = numel(uniqueDays);

    % Store per-day circular mean angle (radians) of peak time-of-day
    thetaDayMean = nan(nDays,1);

    for d = 1:nDays
        idxDay = (dayStart == uniqueDays(d));
        t_day  = t_vec(idxDay);
        y_day  = y_vec(idxDay);

        % Skip tiny / empty days
        if numel(y_day) < 5 || all(isnan(y_day))
            continue
        end

        % --- Peaks within this day ---
        % NOTE: within-day time units are datetime, so use duration for MinPeakDistance
        [~, locs] = findpeaks(y_day, t_day);

        if isempty(locs)
            continue
        end

        % --- Convert peak times to hour-of-day then radians (0..2*pi) ---
        h     = hour(locs) + minute(locs)/60 + second(locs)/3600; % 0..24
        theta = h * (2*pi/24);

        % --- Per-day circular mean angle ---
        thetaDayMean(d) = mod(atan2(mean(sin(theta)), mean(cos(theta))), 2*pi);
    end

    % Keep only days that had peaks
    thetaDayMean = thetaDayMean(~isnan(thetaDayMean));

    if isempty(thetaDayMean)
        stdTOD = NaN;
        mTOD = NaN;
        mTOD_str = "NaN";
        return
    end

    % --- Across-day circular mean (equal weight per day) ---
    theta_mean = mod(atan2(mean(sin(thetaDayMean)), mean(cos(thetaDayMean))), 2*pi);

    % Convert to hours
    mTOD = theta_mean * 24 / (2*pi);

    % Format HH:MM
    HH = floor(mTOD);
    MM = round(60 * mod(mTOD,1));
    if MM == 60
        HH = mod(HH+1, 24);
        MM = 0;
    end
    mTOD_str = sprintf('%02d:%02d', HH, MM);

    % --- Across-day circular std ---
    R = abs(mean(exp(1i*thetaDayMean)));
    circ_std = sqrt(-2 * log(R));          % radians
    stdTOD   = circ_std * (24/(2*pi));     % hours
end
