function writeWQLfile(monthname, current_dataset)

fname = sprintf('WQL_%s.csv', monthname);
writetimetable(current_dataset, fname, 'WriteVariableNames',true);
fprintf('Wrote %s (%d rows)\n', fname, height(current_dataset));

%[appendix]{"version":"1.0"}
%---
