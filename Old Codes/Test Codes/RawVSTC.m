% Plot raw and temp corrected data
plot(t_wql, trp, 'Color', 'k', 'LineWidth', 1, 'DisplayName','TRP Raw');
hold on

p = plot(t_wql, temp_corrected_trp, ...
    'LineWidth', 1, 'DisplayName','TRP Temperature Corrected');
p.Color = [0 1 1 0.2];   % cyan with 30% opacity

xl = xline(datetime(2024,9,19,10,56,0), ...
    '--', 'LineWidth', 2, 'DisplayName','Cleaning Date');
xl.Color = [0.7 0 0.7 0.6];   % purple, semi-transparent

xlim([datetime(2024,8,17,11,35,1), ...
      datetime(2024,10,2,8,47,57)])
ylim([51.6 87.1])

legend("EdgeColor","none", "LineWidth",1, ...
       "Position",[0.6684 0.7744 0.1938 0.1511])
