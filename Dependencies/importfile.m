function data_report = importfile(filename, dataLines)
%IMPORTFILE Import data from a text file
%  DATA_REPORT_12_15_2025_05_07_34 = IMPORTFILE(FILENAME) reads data
%  from text file FILENAME for the default selection.  Returns the data
%  as a table.
%
%  DATA_REPORT = IMPORTFILE(FILE, DATALINES) reads
%  data for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  data_report = importfile("/MATLAB Drive/sunflower/New Data 2025/data_report_12-15-2025_05-07-34.csv", [2, Inf]);
%
%  
%


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["dateTime", "trp", "cdom", "temp"];
opts.VariableTypes = ["datetime", "double", "double", "double"];

% Specify file level properties
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "dateTime", "InputFormat", "MM-dd-yyyy HH:mm:ss", "DatetimeFormat", "preserveinput");

% Import the data
data_report = readtable(filename, opts);

end