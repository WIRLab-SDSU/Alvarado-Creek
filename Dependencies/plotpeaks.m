function [pks, locs] = plotpeaks(x, y, z)
    % Find peaks
    [pks, locs] = findpeaks(y, x, 'MinPeakDistance', z);
    [pks2, locs2] = findpeaks(-y, x, 'MinPeakDistance', z);
    pks2 = -pks2;

    % Plot data and peaks in current axes
    h1 = plot(x, y, 'k', 'LineWidth', 1.5); % black line for signal
    hold on;
    
    % Max peaks: blue open circles
    h2 = plot(locs, pks, 'o', 'Color', [0 0.45 0.74], ...
        'MarkerFaceColor', 'none', 'MarkerSize', 8, 'LineWidth', 1.5);

    % Min peaks: orange open circles
    h3 = plot(locs2, pks2, 'o', 'Color', [0.85 0.33 0.1], ...
        'MarkerFaceColor', 'none', 'MarkerSize', 8, 'LineWidth', 1.5);

    hold off;

    % Formatting
    ax = gca;
    ax.FontName = 'Arial';
    ax.FontSize = 18;
    ax.TickDir = 'none';   % no tick marks pointing in or out
end
