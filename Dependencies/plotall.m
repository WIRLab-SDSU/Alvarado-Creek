function plotall(n,yr,t_wql,t_usgs,temp,trp,cdom,w_lvl)
figure;

monthNames = {'Jan','Feb','Mar','Apr','May','Jun', ...
              'Jul','Aug','Sep','Oct','Nov','Dec'};
year = yr;

% First subplot: Tryptophan
ax1 = subplot(4,1,1);
plotpeaks(t_wql, trp, 0.75);
title(sprintf('%s Trp %d Peaks',monthNames{n}, year))
ylabel('RFU');

% Second subplot: Temperature
ax2 = subplot(4,1,2);
plotpeaks(t_wql, temp, 0.75);
title(sprintf('%s Temp %d Peaks',monthNames{n}, year))
ylabel('°C');

% Third subplot: CDOM
ax3 = subplot(4,1,3);
plotpeaks(t_wql, cdom, 0.75);
title(sprintf('%s CDOM %d Peaks',monthNames{n}, year))
ylabel('RFU');
xlabel('Date');

ax4 = subplot(4,1,4);
plotpeaks(t_usgs, w_lvl, 0.75);
title(sprintf('%s WLvl %d Peaks', monthNames{n}, year));
ylabel('m');
xlabel('Date');


hold off
