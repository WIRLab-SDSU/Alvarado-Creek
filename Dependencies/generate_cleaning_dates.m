params = {'TRP_2024','CDOM_2024','TRP_2025','CDOM_2025'}; 

split = struct();
for i = 1:numel(params)
    split.(params{i}) = datetime.empty(0,1);
end

split.('TRP_2025') = [
    datetime('01-01-2025 00:04:10', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('01-15-2025 11:14:10', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('01-15-2025 13:02:41', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('01-29-2025 13:03:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('01-29-2025 13:03:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('02-27-2025 13:13:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('02-27-2025 13:13:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('03-21-2025 10:53:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('03-21-2025 10:53:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('04-11-2025 10:59:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('04-11-2025 10:59:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('04-25-2025 13:19:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('04-25-2025 13:19:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('05-16-2025 13:09:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('05-16-2025 13:39:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-05-2025 09:09:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('06-05-2025 09:09:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-21-2025 12:00:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('06-21-2025 12:00:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-26-2025 12:44:09', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
  ];

split.('CDOM_2025') = [
    datetime('01-01-2025 00:04:10', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('01-15-2025 11:14:10', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('01-15-2025 13:02:41', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('01-29-2025 13:03:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('01-29-2025 13:03:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('02-27-2025 13:13:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('02-27-2025 13:13:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('03-21-2025 10:53:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('03-21-2025 10:53:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('04-11-2025 10:59:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('04-11-2025 10:59:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('04-25-2025 13:19:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('04-25-2025 13:19:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('05-16-2025 13:09:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('05-16-2025 13:39:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-05-2025 09:09:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('06-05-2025 09:09:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-21-2025 12:00:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('06-21-2025 12:00:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-26-2025 12:44:09', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
  ];

split.('CDOM_2024') = [
     datetime('01-04-2024 15:10:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('01-20-2024 10:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('01-20-2024 10:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('02-16-2024 13:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('02-16-2024 13:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('03-22-2024 10:30:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('03-22-2024 10:30:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('04-12-2024 13:58:53', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('04-12-2024 13:58:53', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('05-10-2024 13:31:54', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('05-10-2024 13:31:54', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('05-23-2024 11:15:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('05-23-2024 11:15:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-06-2024 09:25:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('06-06-2024 09:25:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-20-2024 12:32:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('06-20-2024 12:32:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('07-11-2024 11:14:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('07-11-2024 11:14:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('07-25-2024 09:04:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('07-25-2024 09:04:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('08-07-2024 10:50:20', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('08-07-2024 10:50:20', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('08-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('08-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('08-30-2024 10:56:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('08-30-2024 10:56:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('09-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('09-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('10-10-2024 11:08:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('10-10-2024 11:08:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('10-31-2024 11:09:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('10-31-2024 11:09:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('11-21-2024 12:00:38', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('11-21-2024 12:00:38', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('12-02-2024 12:03:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('12-02-2024 12:03:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('12-18-2024 14:04:10', 'InputFormat', 'MM-dd-yyyy HH:mm:ss') 
   ];

split.('TRP_2024') = [
    datetime('01-04-2024 15:10:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('01-20-2024 10:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('01-20-2024 10:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('02-16-2024 13:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('02-16-2024 13:00:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('03-22-2024 10:30:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('03-22-2024 10:30:17', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('04-12-2024 13:58:53', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('04-12-2024 13:58:53', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('05-10-2024 13:31:54', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('05-10-2024 13:31:54', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('05-23-2024 11:15:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('05-23-2024 11:15:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-06-2024 12:00:46', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('06-06-2024 12:00:46', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('06-20-2024 12:32:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')%06-06-2024 09:25:01
    datetime('06-20-2024 12:32:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('07-11-2024 11:14:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('07-11-2024 11:14:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('07-25-2024 09:04:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('07-25-2024 09:04:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('08-07-2024 10:50:20', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('08-07-2024 10:50:20', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('08-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('08-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('08-30-2024 10:56:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('08-30-2024 10:56:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('09-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('09-19-2024 10:16:00', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('10-10-2024 11:08:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('10-10-2024 11:08:01', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('10-31-2024 11:09:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('10-31-2024 11:09:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('11-21-2024 12:00:38', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('11-21-2024 12:00:38', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('12-02-2024 12:03:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss')
    datetime('12-02-2024 12:03:30', 'InputFormat', 'MM-dd-yyyy HH:mm:ss'), datetime('12-18-2024 14:04:10', 'InputFormat', 'MM-dd-yyyy HH:mm:ss') 
   ];