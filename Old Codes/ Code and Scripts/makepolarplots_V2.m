function makepolarplots_V2(y,t, madMult)
% --- Peaks (maxima and minima) ---
[~, locs_1] = findpeaks(y,  t, 'MinPeakDistance', 0.75);
[~, locs_2] = findpeaks(-y, t, 'MinPeakDistance', 0.75);

if isempty(locs_1) || isempty(locs_2)
    warning('No peaks found (max or min). Check MinPeakDistance / data.');
end

% --- Convert peak times to hour-of-day (0..24) ---
h1 = hour(locs_1) + minute(locs_1)/60 + second(locs_1)/3600;
h2 = hour(locs_2) + minute(locs_2)/60 + second(locs_2)/3600;

% --- Convert hours to radians (0..2*pi) ---
theta1 = h1 * (2*pi/24);
theta2 = h2 * (2*pi/24);

% =======================
% OUTLIER FILTER (±3 MAD)
% =======================
theta_med_max_raw = circMedian(theta1);
theta_med_min_raw = circMedian(theta2);

% Circular absolute deviation from median (in HOURS)
dev1_hours = circAbsDevHours(theta1, theta_med_max_raw);
dev2_hours = circAbsDevHours(theta2, theta_med_min_raw);

mad1 = median(dev1_hours, 'omitnan');
mad2 = median(dev2_hours, 'omitnan');

% Protect against mad==0 (all clustered tightly)
if mad1 == 0, mad1 = eps; end
if mad2 == 0, mad2 = eps; end

keep1 = dev1_hours <= madMult*mad1;
keep2 = dev2_hours <= madMult*mad2;

theta1_f = theta1(keep1);
theta2_f = theta2(keep2);

% Safety
if isempty(theta1_f) || isempty(theta2_f)
    warning('All peaks removed by MAD filter. Plotting unfiltered data instead.');
    theta1_f = theta1;
    theta2_f = theta2;
end

% --- Polar axes formatting (clock-style) ---
figure;
pax = polaraxes;
pax.ThetaZeroLocation = 'top';
pax.ThetaDir = 'clockwise';
pax.ThetaTick = 0:45:315;
pax.ThetaTickLabel = {'00','03','06','09','12','15','18','21'};
pax.RTick = [];
hold(pax,'on')

% --- Choose binning in HOURS, then convert to radians ---
binWidthHours = 0.5;
edgesHours = 0:binWidthHours:24;
edgesTheta = edgesHours * (2*pi/24);

% --- Plot histograms (FILTERED) ---
polarhistogram(pax, theta1_f, ...
    'BinEdges', edgesTheta, ...
    'Normalization','probability', ...
    'FaceAlpha',0.45, ...
    'DisplayName','Max peaks (filtered)');

polarhistogram(pax, theta2_f, ...
    'BinEdges', edgesTheta, ...
    'Normalization','probability', ...
    'FaceAlpha',0.45, ...
    'DisplayName','Min peaks (filtered)');

title(pax,'Extrema by time of day (±3 MAD filtered)')

% --- Recompute circular mean + median on FILTERED data ---
theta_mean_max = mod(atan2(mean(sin(theta1_f)), mean(cos(theta1_f))), 2*pi);
theta_mean_min = mod(atan2(mean(sin(theta2_f)), mean(cos(theta2_f))), 2*pi);

theta_med_max  = circMedian(theta1_f);
theta_med_min  = circMedian(theta2_f);

rTop = pax.RLim(2);

% --- Mean lines ---
polarplot(pax, [theta_mean_max theta_mean_max], [0 rTop], ...
    'k-', 'LineWidth', 2, 'DisplayName', 'Mean');

polarplot(pax, [theta_mean_min theta_mean_min], [0 rTop], ...
    'k-', 'LineWidth', 2, 'HandleVisibility', 'off');

% --- Median lines ---
polarplot(pax, [theta_med_max theta_med_max], [0 rTop], ...
    'k:', 'LineWidth', 2, 'DisplayName', 'Median');

polarplot(pax, [theta_med_min theta_med_min], [0 rTop], ...
    'k:', 'LineWidth', 2, 'HandleVisibility', 'off');

legend(pax,'Location','bestoutside')

% --- Label mean/median times (from FILTERED) ---
meanMax_str = thetaToHHMM(theta_mean_max);
meanMin_str = thetaToHHMM(theta_mean_min);
medMax_str  = thetaToHHMM(theta_med_max);
medMin_str  = thetaToHHMM(theta_med_min);

text(pax, theta_mean_max, rTop*1.2, meanMax_str, ...
    'HorizontalAlignment','center', 'FontWeight','bold')
text(pax, theta_mean_min, rTop*1.2, meanMin_str, ...
    'HorizontalAlignment','center', 'FontWeight','bold')

% text(pax, theta_med_max,  rTop*1.32, ['Median ' medMax_str], 'HorizontalAlignment','center', 'FontWeight','bold')
% text(pax, theta_med_min,  rTop*1.32, ['Median ' medMin_str],'HorizontalAlignment','center', 'FontWeight','bold')

% Optional: print how many were removed
fprintf('Max peaks removed: %d / %d (MAD=%.3f h)\n', sum(~keep1), numel(keep1), mad1);
fprintf('Min peaks removed: %d / %d (MAD=%.3f h)\n', sum(~keep2), numel(keep2), mad2);

end

% ---------- helper: circular median on [0, 2*pi) ----------
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

% ---------- helper: circular abs deviation from a reference angle, in HOURS ----------
function dev_hours = circAbsDevHours(theta, theta_ref)
theta = mod(theta(:), 2*pi);
theta_ref = mod(theta_ref, 2*pi);
dev_rad = abs(angle(exp(1i*(theta - theta_ref)))); % in [0, pi]
dev_hours = dev_rad * (24/(2*pi));
end

% ---------- helper: theta (rad) -> "HH:MM" ----------
function s = thetaToHHMM(theta)
h = mod(theta, 2*pi) * 24/(2*pi);
hh = floor(h);
mm = round(60*mod(h,1));
if mm == 60
    mm = 0;
    hh = mod(hh+1, 24);
end
s = sprintf('%02d:%02d', hh, mm);
end
