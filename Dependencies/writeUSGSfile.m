function writeUSGSfile(monthname, current_USGS_data)

fname2 = sprintf('USGS_%s.csv', monthname);
writetimetable(current_USGS_data, fname2, 'WriteVariableNames',true);
fprintf('Wrote %s (%d rows)\n', fname2, height(current_USGS_data));