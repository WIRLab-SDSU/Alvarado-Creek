function extrema = review_extrema_save(y, t, madMult, outBase)
% review_extrema_save
% - Detect maxima/minima extrema from (y,t)
% - Filter extrema times using circular MAD * madMult
% - Manual review: add/remove extrema interactively on a time-series plot
% - Save results (MAT + CSV)
%
% Inputs
%   y       : numeric vector
%   t       : datetime vector (same length as y)
%   madMult : scalar (e.g. 3, 2.5, 2)
%   outBase : base filename (e.g. "CDOM_extrema" or "CDOM_extrema.mat")
%
% Output
%   extrema : struct with fields locsMax, locsMin, etc.

if nargin < 3 || isempty(madMult)
    madMult = 3;
end
if nargin < 4 || isempty(outBase)
    outBase = "extrema_out";
end

% Make outBase robust for save()
outBase = string(outBase);
[p, n, e] = fileparts(outBase);
if strlength(p) == 0
    p = pwd;
end
if strlength(n) == 0
    n = "extrema_out";
end

% -------------------------
% 1) Detect extrema (raw)
% -------------------------
% NOTE: MinPeakDistance is in "t units". With datetime it is duration.
minPeakDist = hours(0.75);  % adjust if needed

[~, locsMax_raw] = findpeaks(y,  t, 'MinPeakDistance', minPeakDist);
[~, locsMin_raw] = findpeaks(-y, t, 'MinPeakDistance', minPeakDist);

if isempty(locsMax_raw) || isempty(locsMin_raw)
    warning('No peaks found (max or min). Check MinPeakDistance / data.');
end

% -------------------------
% 2) MAD filter on time-of-day (circular)
% -------------------------
thetaMax = timeToTheta(locsMax_raw);
thetaMin = timeToTheta(locsMin_raw);

theta_med_max = circMedian(thetaMax);
theta_med_min = circMedian(thetaMin);

devMax_h = circAbsDevHours(thetaMax, theta_med_max);
devMin_h = circAbsDevHours(thetaMin, theta_med_min);

madMax_h = median(devMax_h, 'omitnan'); if madMax_h == 0, madMax_h = eps; end
madMin_h = median(devMin_h, 'omitnan'); if madMin_h == 0, madMin_h = eps; end

keepMax = devMax_h <= madMult * madMax_h;
keepMin = devMin_h <= madMult * madMin_h;

locsMax = locsMax_raw(keepMax);
locsMin = locsMin_raw(keepMin);

% Safety fallback
if isempty(locsMax) || isempty(locsMin)
    warning('All extrema removed by MAD filter. Using unfiltered extrema for review.');
    locsMax = locsMax_raw;
    locsMin = locsMin_raw;
end

fprintf('MAD filter (x%.2f): removed max %d/%d (MAD=%.3f h), min %d/%d (MAD=%.3f h)\n', ...
    madMult, sum(~keepMax), numel(keepMax), madMax_h, sum(~keepMin), numel(keepMin), madMin_h);

% -------------------------
% 3) Manual review (interactive)
% -------------------------
[locsMax_final, locsMin_final] = manualReviewExtrema(y, t, locsMax, locsMin);

% Sort & unique (important after edits)
locsMax_final = unique(locsMax_final(:));
locsMin_final = unique(locsMin_final(:));

% -------------------------
% 4) Save results
% -------------------------
extrema = struct();
extrema.madMult = madMult;
extrema.minPeakDistance = minPeakDist;
extrema.locsMax_raw = locsMax_raw;
extrema.locsMin_raw = locsMin_raw;
extrema.locsMax_final = locsMax_final;
extrema.locsMin_final = locsMin_final;

matFile = fullfile(p, n + ".mat");
csvFile = fullfile(p, n + ".csv");

save(char(matFile), "extrema");

% also write a tidy CSV (one row per extrema)
type = [repmat("max", numel(locsMax_final), 1); repmat("min", numel(locsMin_final), 1)];
time = [locsMax_final; locsMin_final];
T = table(type, time, 'VariableNames', {'type','time'});
writetable(T, csvFile);

fprintf('Saved:\n  %s\n  %s\n', matFile, csvFile);

end

% ============================================================
% ===================== MANUAL REVIEW UI ======================
% ============================================================
function [locsMax, locsMin] = manualReviewExtrema(y, t, locsMax, locsMin)

fig = figure('Name','Manual extrema review', 'Color','w');
ax = axes(fig);
hold(ax,'on');
grid(ax,'on');

plt = plot(ax, t, y, '-', 'DisplayName','signal'); %#ok<NASGU>
hMax = plot(ax, locsMax, interp1(t,y,locsMax,'linear','extrap'), 'r^', ...
    'MarkerFaceColor','r','DisplayName','max');
hMin = plot(ax, locsMin, interp1(t,y,locsMin,'linear','extrap'), 'bv', ...
    'MarkerFaceColor','b','DisplayName','min');

legend(ax,'Location','best');
title(ax, "Extrema review: click to edit (instructions in Command Window)");

fprintf('\n=== Manual extrema review ===\n');
fprintf('Actions:\n');
fprintf('  d = delete nearest extrema (max or min)\n');
fprintf('  x = delete nearest MAX\n');
fprintf('  n = delete nearest MIN\n');
fprintf('  a = add MAX at clicked time (snaps to nearest sample)\n');
fprintf('  s = add MIN at clicked time (snaps to nearest sample)\n');
fprintf('  z = zoom on/off (toggle)\n');
fprintf('  q = finish and save\n');
fprintf('How it works:\n');
fprintf('  - You click once on the plot after choosing an action.\n');
fprintf('  - Adds snap to the nearest timestamp in t.\n\n');

zoomState = false;

while isvalid(fig)
    drawnow;
    cmd = lower(strtrim(input('Enter action (d/x/n/a/s/z/q): ','s')));

    if isempty(cmd)
        continue;
    end

    if cmd == "q"
        break;
    elseif cmd == "z"
        zoomState = ~zoomState;
        zoom(fig, zoomState);
        fprintf('Zoom %s\n', ternary(zoomState,'ON','OFF'));
        continue;
    end

    % For add/delete actions we need a click
    fprintf('Click on the plot...\n');
    [xClick, ~] = ginput(1);  % datetime axes -> xClick is datenum
    if isempty(xClick), continue; end
    tClick = datetime(xClick, 'ConvertFrom','datenum');

    % find nearest sample time in t
    [~, idx] = min(abs(t - tClick));
    tSnap = t(idx);

    switch cmd
        case "d"
            % delete nearest extrema regardless of type
            [locsMax, locsMin] = deleteNearestEither(locsMax, locsMin, tSnap);

        case "x"
            locsMax = deleteNearest(locsMax, tSnap);

        case "n"
            locsMin = deleteNearest(locsMin, tSnap);

        case "a"
            locsMax = unique([locsMax; tSnap]);

        case "s"
            locsMin = unique([locsMin; tSnap]);

        otherwise
            fprintf('Unknown action.\n');
    end

    % update markers
    if isvalid(hMax)
        set(hMax, 'XData', locsMax, 'YData', interp1(t,y,locsMax,'linear','extrap'));
    end
    if isvalid(hMin)
        set(hMin, 'XData', locsMin, 'YData', interp1(t,y,locsMin,'linear','extrap'));
    end
end

if isvalid(fig)
    close(fig);
end

end

function locs = deleteNearest(locs, tSnap)
if isempty(locs), return; end
[~, k] = min(abs(locs - tSnap));
locs(k) = [];
end

function [locsMax, locsMin] = deleteNearestEither(locsMax, locsMin, tSnap)
dMax = inf; dMin = inf;
if ~isempty(locsMax), dMax = min(abs(locsMax - tSnap)); end
if ~isempty(locsMin), dMin = min(abs(locsMin - tSnap)); end

if dMax <= dMin
    locsMax = deleteNearest(locsMax, tSnap);
else
    locsMin = deleteNearest(locsMin, tSnap);
end
end

function out = ternary(cond, a, b)
if cond, out = a; else, out = b; end
end

% ============================================================
% ===================== CIRCULAR HELPERS ======================
% ============================================================
function theta = timeToTheta(tt)
% Convert datetime vector -> hour-of-day -> radians (0..2*pi)
h = hour(tt) + minute(tt)/60 + second(tt)/3600;
theta = h * (2*pi/24);
theta = mod(theta(:), 2*pi);
end

function thMed = circMedian(theta)
theta = mod(theta(:), 2*pi);
n = numel(theta);
if n == 0
    thMed = NaN;
    return
end
cand = theta;
D = abs(angle(exp(1i*(cand - theta.')))); % circular distances (radians)
sumD = sum(D, 2);
[~, idx] = min(sumD);
thMed = cand(idx);
end

function dev_hours = circAbsDevHours(theta, theta_ref)
theta = mod(theta(:), 2*pi);
theta_ref = mod(theta_ref, 2*pi);
dev_rad = abs(angle(exp(1i*(theta - theta_ref)))); % [0, pi]
dev_hours = dev_rad * (24/(2*pi));
end


%[appendix]{"version":"1.0"}
%---
