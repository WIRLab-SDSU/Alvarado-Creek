function qc = qc_diurnal_singlepeak_v2(y, t, opts)
% y: numeric, t: datetime (10-min)
% Returns qc table with per-day stats and keepDay + rejection reason
% (R2 / harmonic filter removed)

arguments
    y (:,1) double
    t (:,1) datetime
    opts.minPeakDistHours (1,1) double = 24
    opts.minPromFrac (1,1) double = 0
    opts.ampMin double = []
end

% group by day
day0 = dateshift(t,'start','day');
uDays = unique(day0);

nD = numel(uDays);
keep = false(nD,1);

nMax = zeros(nD,1); nMin = zeros(nD,1);
amp = nan(nD,1);
tMax = NaT(nD,1); tMin = NaT(nD,1);

% reason + flags
reason = strings(nD,1);

tooFewSamples = false(nD,1);
lowAmp        = false(nD,1);
noMax         = false(nD,1);
multiMax      = false(nD,1);
noMin         = false(nD,1);
multiMin      = false(nD,1);

ampOK_vec = true(nD,1);

minN = 24*6*0.6;  % ~60% of day (10-min => 6/hr)

for k = 1:nD
    idx = (day0 == uDays(k));
    ty = t(idx);
    yy = y(idx);

    % coverage check
    if numel(yy) < minN
        keep(k) = false;
        tooFewSamples(k) = true;
        reason(k) = "too_few_samples";
        continue
    end

    % robust daily amplitude
    amp(k) = prctile(yy,95) - prctile(yy,5);

    % amplitude threshold (if provided)
    if isempty(opts.ampMin)
        ampOK = true;
    else
        ampOK = amp(k) >= opts.ampMin;
    end
    ampOK_vec(k) = ampOK;

    if ~ampOK
        keep(k) = false;
        lowAmp(k) = true;
        reason(k) = "low_amplitude";
        % keep going so you can still see peaks/plot for diagnosis
    end

    % peak-finding settings
    minDist = hours(opts.minPeakDistHours);
    minProm = opts.minPromFrac * amp(k);

    [pMax, locMax] = findpeaks(yy, ty, ...
        'MinPeakDistance', minDist, ...
        'MinPeakProminence', minProm);

    [pMinN, locMin] = findpeaks(-yy, ty, ...
        'MinPeakDistance', minDist, ...
        'MinPeakProminence', minProm);

    nMax(k) = numel(locMax);
    nMin(k) = numel(locMin);

    if nMax(k) == 1, tMax(k) = locMax; end
    if nMin(k) == 1, tMin(k) = locMin; end

    % Values at peak times for plotting
    yMax = pMax;
    yMin = -pMinN;

    % plotting for visual inspection
    if k == 1
        fig = figure; ax = axes(fig); hold(ax,'on'); grid(ax,'on');
    end
    cla(ax)

    plot(ax, ty, yy, 'k-')
    plot(ax, locMax, yMax, 'r^', 'MarkerFaceColor','r')
    plot(ax, locMin, yMin, 'bv', 'MarkerFaceColor','b')

    title(ax, sprintf('%s | nMax=%d nMin=%d | amp=%.3g', ...
        datestr(uDays(k)), numel(locMax), numel(locMin), amp(k)))

    drawnow
    pause  % press a key to advance to next day

    % determine rejection reason (first failure wins unless low_amp already set)
    if reason(k) == ""
        if nMax(k) == 0
            noMax(k) = true;
            reason(k) = "no_max";
        elseif nMax(k) > 1
            multiMax(k) = true;
            reason(k) = "multi_max";
        elseif nMin(k) == 0
            noMin(k) = true;
            reason(k) = "no_min";
        elseif nMin(k) > 1
            multiMin(k) = true;
            reason(k) = "multi_min";
        else
            reason(k) = "kept";
        end
    else
        % low amplitude was flagged; still track peak issues for diagnosis
        if nMax(k) == 0, noMax(k) = true; end
        if nMax(k) > 1, multiMax(k) = true; end
        if nMin(k) == 0, noMin(k) = true; end
        if nMin(k) > 1, multiMin(k) = true; end
    end

    keep(k) = (nMax(k)==1) && (nMin(k)==1) && ampOK;
end

qc = table(uDays, keep, reason, ...
    nMax, nMin, amp, tMax, tMin, ...
    ampOK_vec, ...
    tooFewSamples, lowAmp, noMax, multiMax, noMin, multiMin, ...
    'VariableNames', { ...
        'day','keepDay','reason', ...
        'nMax','nMin','amp_95_5','tMax','tMin', ...
        'ampOK', ...
        'tooFewSamples','lowAmp','noMax','multiMax','noMin','multiMin'});

end
