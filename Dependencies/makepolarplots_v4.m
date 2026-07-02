function statsTbl = makepolarplots_v4(qc)

% Keep only days you accepted AND that actually have a peak time
locsMax = qc.tMax(qc.keepDay & ~isnat(qc.tMax));
locsMin = qc.tMin(qc.keepDay & ~isnat(qc.tMin));

hMax = hour(locsMax) + minute(locsMax)/60 + second(locsMax)/3600;
hMin = hour(locsMin) + minute(locsMin)/60 + second(locsMin)/3600;

thetaMax = hMax * (2*pi/24);
thetaMin = hMin * (2*pi/24);



% STATS
% =======================
% STATS (computed on what you plot: thetaMax/thetaMin)
% =======================

% Circular means (radians)
theta_mean_max = mod(atan2(mean(sin(thetaMax)), mean(cos(thetaMax))), 2*pi);
theta_mean_min = mod(atan2(mean(sin(thetaMin)), mean(cos(thetaMin))), 2*pi);

% Circular medians (radians)
theta_med_max  = circMedian(thetaMax);
theta_med_min  = circMedian(thetaMin);

% Circular std (radians -> hours)
std_max_h = circStd(thetaMax) * (24/(2*pi));
std_min_h = circStd(thetaMin) * (24/(2*pi));

% Circular MAD (hours): median absolute circular deviation from circular median
mad_max_h = median(circAbsDevHours(thetaMax, theta_med_max), 'omitnan');
mad_min_h = median(circAbsDevHours(thetaMin, theta_med_min), 'omitnan');

% Convert mean/median to hours + HH:MM strings
mean_max_h = theta_mean_max * 24/(2*pi);
mean_min_h = theta_mean_min * 24/(2*pi);
med_max_h  = theta_med_max  * 24/(2*pi);
med_min_h  = theta_med_min  * 24/(2*pi);

meanMax_str = thetaToHHMM(theta_mean_max);
meanMin_str = thetaToHHMM(theta_mean_min);
medMax_str  = thetaToHHMM(theta_med_max);
medMin_str  = thetaToHHMM(theta_med_min);

nMax = numel(thetaMax);
nMin = numel(thetaMin);

statsTbl = table( ...
    ["Max"; "Min"], ...
    [nMax; nMin], ...
    [mean_max_h; mean_min_h], ...
    [meanMax_str; meanMin_str], ...
    [med_max_h;  med_min_h], ...
    [medMax_str;  medMin_str], ...
    [std_max_h;  std_min_h], ...
    [mad_max_h;  mad_min_h], ...
    'VariableNames', {'Extrema','N','MeanHour','MeanHHMM','MedianHour','MedianHHMM','StdHour','MADHour'} );


% Plotting 
figure;
pax = polaraxes;
pax.ThetaZeroLocation = 'top';
pax.ThetaDir = 'clockwise';
pax.ThetaTick = 0:45:315;
pax.ThetaTickLabel = {'00','03','06','09','12','15','18','21'};
pax.RTick = [];
hold(pax,'on')

% bins in hours -> radians
binWidthHours = 1;
edgesTheta = (0:binWidthHours:24) * (2*pi/24);

polarhistogram(pax, thetaMax, 'BinEdges', edgesTheta, ...
    'Normalization','probability', 'FaceAlpha',0.45, ...
    'DisplayName','Max peaks (filtered days)');

polarhistogram(pax, thetaMin, 'BinEdges', edgesTheta, ...
    'Normalization','probability', 'FaceAlpha',0.45, ...
    'DisplayName','Min peaks (filtered days)');

title(pax,'Extrema by time of day (kept days)')
legend(pax,'Location','bestoutside')

% Mean and median directions (circular)
thetaMeanMax = mod(atan2(mean(sin(thetaMax)), mean(cos(thetaMax))), 2*pi);
thetaMeanMin = mod(atan2(mean(sin(thetaMin)), mean(cos(thetaMin))), 2*pi);

thetaMedMax = circMedian(thetaMax);
thetaMedMin = circMedian(thetaMin);

rlim(pax,'auto'); rTop = pax.RLim(2);
rlim(pax,[0 rTop*1.3]); rTop = pax.RLim(2);

polarplot(pax, [thetaMeanMax thetaMeanMax], [0 rTop], 'k:', 'LineWidth', 1, 'DisplayName','Mean');
polarplot(pax, [thetaMeanMin thetaMeanMin], [0 rTop], 'k:', 'LineWidth', 1, 'HandleVisibility','off');

polarplot(pax, [thetaMedMax thetaMedMax], [0 rTop], 'k-', 'LineWidth', 1, 'DisplayName','Median');
polarplot(pax, [thetaMedMin thetaMedMin], [0 rTop], 'k-', 'LineWidth', 1, 'HandleVisibility','off');

% Aesthetics
hPolaraxes = findobj(gcf,"Type","polaraxes");
hPolaraxes.FontName = "Arial";
hPolaraxes.FontSize = 18;
hPolaraxes.LineWidth = 1;

end

function thMed = circMedian(theta)
theta = mod(theta(:), 2*pi);
n = numel(theta);
if n == 0, thMed = NaN; return; end
cand = theta;
D = abs(angle(exp(1i*(cand - theta.'))));
sumD = sum(D, 2);
[~, idx] = min(sumD);
thMed = cand(idx);
end

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

function dev_hours = circAbsDevHours(theta, theta_ref)
theta = mod(theta(:), 2*pi);
theta_ref = mod(theta_ref, 2*pi);
dev_rad = abs(angle(exp(1i*(theta - theta_ref)))); % in [0, pi]
dev_hours = dev_rad * (24/(2*pi));
end

function s = circStd(theta)
% Circular standard deviation (radians)
theta = mod(theta(:), 2*pi);
theta = theta(~isnan(theta));
if isempty(theta)
    s = NaN;
    return
end
R = abs(mean(exp(1i*theta)));   % mean resultant length
s = sqrt(-2*log(max(R, eps)));  % radians
end
