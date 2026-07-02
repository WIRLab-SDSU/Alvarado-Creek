%% ---- pick one day to test ----
y = trp; % your parameter vector (double)
t = t_wql; % t: your datetime vector (same length)
testDay = datetime(2024,9,9);   % <-- change to a day you want to inspect

dayStart = dateshift(testDay,'start','day');
dayEnd   = dayStart + days(1);

idx = (t >= dayStart) & (t < dayEnd) & ~isnan(y);
ty = t(idx);
yy = y(idx);

if numel(yy) < 20
    error('Not enough samples on %s to fit.', datestr(testDay));
end

%% ---- fit a 24h harmonic: y = a0 + a1*sin(wt) + b1*cos(wt) ----
t0 = dateshift(ty(1),'start','day');
th = hours(ty - t0);            % hours since midnight
w  = 2*pi/24;

X = [ones(size(th)), sin(w*th), cos(w*th)];
beta = X \ yy;

yhat = X * beta;
res  = yy - yhat;

% Diurnal amplitude of fitted sinusoid
A = hypot(beta(2), beta(3));    % sqrt(a1^2 + b1^2)

%% ---- SNR (RMS-based) ----
snr_linear = rms(yhat) / rms(res);
snr_dB = 20*log10(snr_linear);

%% ---- Robust SNR option (less sensitive to outliers) ----
sig_rob = iqr(yhat)/1.349;      % robust std proxy
noi_rob = iqr(res)/1.349;
snr_rob_linear = sig_rob / noi_rob;
snr_rob_dB = 20*log10(snr_rob_linear);

%% ---- plots ----
figure('Color','w');

subplot(2,1,1)
plot(ty, yy, 'k-'); hold on; grid on
plot(ty, yhat, 'LineWidth', 1.5);
title(sprintf('%s: 24h sinusoid fit | Amp=%.3g | SNR=%.2f (%.2f dB)', ...
    datestr(dayStart,'yyyy-mm-dd'), A, snr_linear, snr_dB))
xlabel('Time'); ylabel('y')

subplot(2,1,2)
plot(ty, res, 'k-'); grid on
yline(0,'--');
title(sprintf('Residuals | Robust SNR=%.2f (%.2f dB)', snr_rob_linear, snr_rob_dB))
xlabel('Time'); ylabel('y - fit')

%% ---- print summary ----
fprintf('Day: %s\n', datestr(dayStart,'yyyy-mm-dd'));
fprintf('Fit: y = a0 + a1*sin(wt) + b1*cos(wt), w=2*pi/24\n');
fprintf('a0=%.6g, a1=%.6g, b1=%.6g, Amp=%.6g\n', beta(1), beta(2), beta(3), A);
fprintf('SNR (RMS):   %.3f (%.2f dB)\n', snr_linear, snr_dB);
fprintf('SNR (robust):%.3f (%.2f dB)\n', snr_rob_linear, snr_rob_dB);
