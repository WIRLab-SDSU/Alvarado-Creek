% --- Peaks (maxima and minima) ---
[pks_1, locs_1] = findpeaks(w_lvl, t_usgs, 'MinPeakDistance', 0.75);
[pks_2, locs_2] = findpeaks(-w_lvl, t_usgs, 'MinPeakDistance', 0.75);

% Safety: if no peaks, avoid empty plots
if isempty(locs_1) || isempty(locs_2)
    warning('No peaks found (max or min). Check MinPeakDistance / data.');
end

% --- Convert peak times to hour-of-day (0..24) ---
h1 = hour(locs_1) + minute(locs_1)/60 + second(locs_1)/3600;
h2 = hour(locs_2) + minute(locs_2)/60 + second(locs_2)/3600;

% --- Convert hours to radians (0..2*pi) ---
theta1 = h1 * (2*pi/24);
theta2 = h2 * (2*pi/24);

% --- Polar axes formatting (clock-style) ---
figure
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

% --- Plot histograms (force bin edges via name-value) ---
polarhistogram(pax, theta1, ...
    'BinEdges', edgesTheta, ...
    'Normalization','probability', ...
    'FaceAlpha',0.45, ...
    'DisplayName','Max peaks');

polarhistogram(pax, theta2, ...
    'BinEdges', edgesTheta, ...
    'Normalization','probability', ...
    'FaceAlpha',0.45, ...
    'DisplayName','Min peaks');

legend(pax,'Location','bestoutside')
title(pax,'Extrema by time of day')

theta_mean_max = mod(atan2(mean(sin(theta1)), mean(cos(theta1))), 2*pi);
theta_mean_min = mod(atan2(mean(sin(theta2)), mean(cos(theta2))), 2*pi);

rTop = pax.RLim(2);

polarplot(pax, [theta_mean_max theta_mean_max], [0 rTop], 'k-', 'LineWidth', 2)
polarplot(pax, [theta_mean_min theta_mean_min], [0 rTop], 'k-', 'LineWidth', 2)

% Convert mean peak time for maxima back into hours
hour_meanMax = theta_mean_max * 24 / (2*pi);
hourmeanMax_str  = sprintf('%02d:%02d', floor(hour_meanMax), round(60*mod(hour_meanMax,1)));

% Convert mean peak times for minima back into hours
hour_meanMin = theta_mean_min * 24 / (2*pi);
hourmeanMin_str  = sprintf('%02d:%02d', floor(hour_meanMin), round(60*mod(hour_meanMin,1)));

% Mark the mean peak times for maxima on the polar plot
text(pax, theta_mean_max, rTop*1.2, hourmeanMax_str, ...
    'HorizontalAlignment','center', 'FontWeight','bold')

% Mark the mean peak times for minima on the polar plot
text(pax, theta_mean_min, rTop*1.3, hourmeanMin_str, ...
    'HorizontalAlignment','center', 'FontWeight','bold')