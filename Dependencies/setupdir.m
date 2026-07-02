function monthName = setupdir(month,year)

monthNames = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};

monthName = sprintf('data_%s_%d', monthNames{month}, year); % Example month name, adjust as needed
mkdir(monthName);       % Create a new directory for the current month
cd(monthName);          % Navigate into the new month directory

