function qc = qc_diurnal_singlepeak_v3(y, t, opts)
% QC for single diurnal max/min per day with MANUAL keep/reject review.
% - Per-day findpeaks for max and min
% - Optional amplitude threshold
% - No harmonic R2 filter (removed)
% - Interactive review: press k (keep) or r (reject) for each day

arguments
    y (:,1) double
    t (:,1) datetime
    opts.minPeakDistHours (1,1) double = 24
    opts.minPromFrac (1,1) double = 0
    opts.ampMin double = []                 % optional
end

% group by day
day0 = dateshift(t,'start','day');
uDays = unique(day0);

nD = numel(uDays);

keep = false(nD,1);
reason = strings(nD,1);
reason(:) = "not_reviewed";

nMax = zeros(nD,1); nMin = zeros(nD,1);
amp = nan(nD,1);
tMax = NaT(nD,1); tMin = NaT(nD,1);

% flags
tooFewSamples = false(nD,1);
lowAmp        = false(nD,1);
noMax         = false(nD,1);
multiMax      = false(nD,1);
noMin         = false(nD,1);
multiMin      = false(nD,1);

ampOK_vec = true(nD,1);

minN = 24*6*0.6;  % ~60% of a day at 10-min sampling

for k = 1:nD
    idx = (day0 == uDays(k));
    ty = t(idx);
    yy = y(idx);

    % ---- coverage check ----
    if numel(yy) < minN
        keep(k) = false;
        tooFewSamples(k) = true;
        reason(k) = "too_few_samples";
        continue
    end

    % robust daily amplitude
    amp(k) = prctile(yy,95) - prctile(yy,5);

    % amplitude threshold (optional)
    if isempty(opts.ampMin)
        ampOK = true;
    else
        ampOK = amp(k) >= opts.ampMin;
    end
    ampOK_vec(k) = ampOK;
    if ~ampOK
        lowAmp(k) = true;
        % don't auto-reject yet; still allow manual decision
    end

    % ---- peaks ----
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

    if nMax(k) == 0, noMax(k) = true; end
    if nMax(k) > 1, multiMax(k) = true; end
    if nMin(k) == 0, noMin(k) = true; end
    if nMin(k) > 1, multiMin(k) = true; end

    if nMax(k) == 1, tMax(k) = locMax; end
    if nMin(k) == 1, tMin(k) = locMin; end

    % Values at peak times for plotting
    yMax = pMax;       % peak heights in yy
    yMin = -pMinN;     % convert back to yy units

    % ---- plot for review ----
    if k == 1
        fig = figure('Name','Daily QC review', 'Color','w');
        ax = axes(fig); hold(ax,'on'); grid(ax,'on');
    end
    cla(ax)

    plot(ax, ty, yy, 'k-')
    plot(ax, locMax, yMax, 'r^', 'MarkerFaceColor','r')
    plot(ax, locMin, yMin, 'bv', 'MarkerFaceColor','b')

    % Show auto-diagnostics in the title
    title(ax, sprintf('%s | nMax=%d nMin=%d | amp=%.3g | ampOK=%d\nPress: k=keep, r=reject, q=quit', ...
        datestr(uDays(k)), nMax(k), nMin(k), amp(k), ampOK))

    drawnow

    % ---- manual decision ----
    decision = '';
    while ~ismember(decision, {'k','r','q'})
        decision = lower(getkeywait());
    end

    if decision == 'q'
        % stop early; remaining days stay "not_reviewed"
        break
    elseif decision == 'k'
        keep(k) = true;
        reason(k) = "kept_manual";
    else % 'r'
        keep(k) = false;
        reason(k) = "rejected_manual";
    end

    % Optional: if rejected, you might want a more specific reason
    if ~keep(k)
        if lowAmp(k), reason(k) = "rejected_low_amplitude_manual"; end
        if noMax(k),  reason(k) = "rejected_no_max_manual"; end
        if noMin(k),  reason(k) = "rejected_no_min_manual"; end
        if multiMax(k), reason(k) = "rejected_multi_max_manual"; end
        if multiMin(k), reason(k) = "rejected_multi_min_manual"; end
        % (If multiple flags, last one wins; tell me if you want a joined list)
    end

end

qc = table(uDays, keep, reason, ...
    nMax, nMin, amp, tMax, tMin, ...
    ampOK_vec, ...
    tooFewSamples, lowAmp, noMax, multiMax, noMin, multiMin, ...
    'VariableNames', {'day','keepDay','reason', ...
        'nMax','nMin','amp_95_5','tMax','tMin', ...
        'ampOK', ...
        'tooFewSamples','lowAmp','noMax','multiMax','noMin','multiMin'});

end

% -------- helper: wait for a single key press --------
function ch = getkeywait()
% Returns a single character from keyboard without needing Enter
% Works in a figure context.
waitforbuttonpress;
ch = get(gcf,'CurrentCharacter');
end
