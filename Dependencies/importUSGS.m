function data = importUSGS(filename, dataLines)
%IMPORTFILE1 Import data from a text file
%  GAGE_HEIGHT_JAN_SEP = IMPORTUSGS(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  GAGE_HEIGHT_JAN_SEP = IMPORTUSGS(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  gage_height_jan_sep = importUSGS("/MATLAB Drive/sunflower/New Data 2025/gage_height_jan-sep.csv", [2, Inf]);
%


%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["agency_cd", "site_no", "t_wlvl", "w_lvl", "X_00065_00000_cd", "tz_cd"];
opts.SelectedVariableNames = ["t_wlvl", "w_lvl"];
opts.VariableTypes = ["string", "string", "datetime", "double", "string", "string"];

% Specify file level properties
opts.ImportErrorRule = "omitrow";
opts.MissingRule = "omitrow";
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["agency_cd", "site_no", "X_00065_00000_cd", "tz_cd"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["agency_cd", "site_no", "X_00065_00000_cd", "tz_cd"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "t_wlvl", "InputFormat", "yyyy-MM-dd HH:mm:ss", "DatetimeFormat", "preserveinput");

% Import the data
data = readtable(filename, opts);

end