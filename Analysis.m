%% Sunflower Processing Workflow
% Cleaned main workflow with reusable detrending functions.
%
% Required helper functions:
%   detrendParameter.m
%   plotCleanedParameter.m
%
% Required existing project functions:
%   importUSGS.m
%   processUSGSData.m
%   importfile.m
%   prep_set.m
%   TempCorrections.m
%   clean_parameter_segments.m
%   saveerrorstructures.m
%   split_months.m
%   setupdir.m
%   setupWQLdata.m
%   setupUSGSdata.m
%   writeWQLfile.m
%   writeUSGSfile.m
%   get_raw_stats.m
%   qc_diurnal_singlepeak_v3.m
%   plotall.m
%   makepolarplots.m
%   makepolarplots_v4.m
%   meanDiurnalProfileFromTimetable.m
%   norm_smooth.m

clear;
clc;
close all;

%% -------------------- USER SETTINGS --------------------

analysisYear = 2024;

% Month selection
wqlMonth  = 12;   % WQL month number: 1 = Jan, 2 = Feb, ..., 12 = Dec
usgsMonth = 4;    % USGS month-set index. Verify this matches USGSmonthSets.

% File names
usgsCSV = "gage_height_jan-sep.csv";
wqlCSV  = "data_report_12-15-2025_05-07-34.csv";

% USGS output created by processUSGSData
usgsOutputName = "USGS_2025";

% Analysis folder
analysisFolder = string(analysisYear);

% Code paths
addpath("ProjectAlvaradoCreek/data");
addpath("ProjectAlvaradoCreek/Dependencies");;

% Baseline/config files
first100File2024 = "/ProjectAlvaradoCreek/data2024_first_100.mat";
last100File2025  = "/ProjectAlvaradoCreek/data/dec2024_last_100.mat";
dataFile2025     = "/ProjectAlvaradoCreek/data/2025data.mat";

%% -------------------- SET UP ANALYSIS FOLDER --------------------

if ~isfolder(analysisFolder)
    mkdir(analysisFolder);
end

cd(analysisFolder);

%% -------------------- IMPORT AND PROCESS USGS DATA --------------------

USGS_data = importUSGS(usgsCSV);
save("USGS_data.mat", "USGS_data");

% Splits USGS data into months and saves output as usgsOutputName + ".mat"
processUSGSData(USGS_data, usgsOutputName);

%% -------------------- IMPORT AND PROCESS WQL DATA --------------------

data_report = importfile(wqlCSV);
save("data_report.mat", "data_report");

[trp, temp, cdom, t_wql] = prep_set(data_report);

%% -------------------- TEMPERATURE CORRECTIONS --------------------

[temp_corrected_cdom, temp_corrected_trp] = TempCorrections(cdom, trp, temp);

%% -------------------- DETRENDING --------------------
% Replaces:
%   DetrendCDOM2024.m
%   DetrendCDOM2025.m
%   DetrendTRP2024.m
%   DetrendTRP2025.m
%
% The old scripts differed mainly by:
%   1. selected cleaning-date field,
%   2. corrected parameter input,
%   3. baseline source.

switch analysisYear
    case 2024
        load(first100File2024, "split", "cdom_first_100", "trp_first_100");

        cdomCleaningDates = split.CDOM_2024;
        trpCleaningDates  = split.TRP_2024;

        cdomBaseline = cdom_first_100;
        trpBaseline  = trp_first_100;

        baselineMode = "first_100";

    case 2025
        load(last100File2025, "cdom_last_100", "trp_last_100");
        load(dataFile2025, "split");

        cdomCleaningDates = split.CDOM_2025;
        trpCleaningDates  = split.TRP_2025;

        cdomBaseline = cdom_last_100;
        trpBaseline  = trp_last_100;

        baselineMode = "previous_december_last_100";

    otherwise
        error("No detrending configuration is defined for analysisYear = %d.", analysisYear);
end

[cdom_final, cdom_outputs] = detrendParameter( ...
    temp_corrected_cdom, ...
    t_wql, ...
    cdomCleaningDates, ...
    cdomBaseline, ...
    "cdom_result_report");

plotCleanedParameter( ...
    t_wql, ...
    cdom_final, ...
    cdomCleaningDates, ...
    "CDOM After Segment-Wise Cleaning", ...
    "CDOM");

savefig("CDOM_Detrended.fig");

[trp_final, trp_outputs] = detrendParameter( ...
    temp_corrected_trp, ...
    t_wql, ...
    trpCleaningDates, ...
    trpBaseline, ...
    "trp_result_report");

plotCleanedParameter( ...
    t_wql, ...
    trp_final, ...
    trpCleaningDates, ...
    "TRP After Segment-Wise Cleaning", ...
    "TRP");

savefig("TRP_Detrended.fig");

% Save final corrected/detrended parameters and diagnostics
final_params = table(trp_final, cdom_final);

save("final_params.mat", "final_params", "baselineMode");
save("cdom_result_report.mat", "cdom_final", "cdom_outputs", "baselineMode");
save("trp_result_report.mat", "trp_final", "trp_outputs", "baselineMode");

% Save regression error statistics for later.
% This script may need updating if it expects variables with old names like
% cdom_p_array or trp_error_structures directly in the workspace.
saveerrorstructures;

%% -------------------- SPLIT WQL DATA INTO MONTHS --------------------

wql_monthsets = split_months(t_wql, trp_final, cdom_final, temp, 12);

save("monthly_wql_data.mat", "wql_monthsets");
save("cdom_result_report.mat", "cdom_final", "cdom_outputs", "baselineMode");
save("trp_result_report.mat", "trp_final", "trp_outputs", "baselineMode");

%% -------------------- LOAD MONTHLY DATA FOR ANALYSIS --------------------

clearvars -except analysisYear wqlMonth usgsMonth usgsOutputName;

load("monthly_wql_data.mat", "wql_monthsets");
load(usgsOutputName + ".mat", "USGSmonthSets");

%% -------------------- SET UP MONTH-SPECIFIC ANALYSIS --------------------

monthname = setupdir(wqlMonth, analysisYear);

current_dataset   = setupWQLdata(wqlMonth, wql_monthsets);
current_USGS_data = setupUSGSdata(usgsMonth, USGSmonthSets);

save("data.mat", "current_dataset", "current_USGS_data");

writeWQLfile(monthname, current_dataset);

% Optional if USGS data are available for the selected month.
writeUSGSfile(monthname, current_USGS_data);

%% -------------------- PULL VARIABLES --------------------

t_wql = current_dataset.t_wql;
trp   = current_dataset.trp;
cdom  = current_dataset.cdom;
temp  = current_dataset.temp;

t_usgs = current_USGS_data.Time;
w_lvl  = current_USGS_data.water_level;

save("All_Params.mat", "t_usgs", "t_wql", "temp", "cdom", "trp", "w_lvl");

%% -------------------- RAW STATS --------------------

% Needs to be updated if assumptions changed.
get_raw_stats;

save("Peak_Stats.mat", "PstatsTbl");
save("Trough_Stats.mat", "TstatsTbl");

%% -------------------- QUALITY CONTROL FILTERING --------------------

qc_temp = qc_diurnal_singlepeak_v3(temp,  t_wql);
qc_trp  = qc_diurnal_singlepeak_v3(trp,   t_wql);
qc_cdom = qc_diurnal_singlepeak_v3(cdom,  t_wql);
qc_GH   = qc_diurnal_singlepeak_v3(w_lvl, t_usgs);

save("Filtered_Params.mat", "qc_temp", "qc_trp", "qc_cdom", "qc_GH");

%% -------------------- FIGURE DIRECTORY --------------------

figDir = "Figures";

if ~isfolder(figDir)
    mkdir(figDir);
end

cd(figDir);

%% -------------------- PLOT ALL PARAMETERS WITH DETECTED PEAKS --------------------

plotall(wqlMonth, analysisYear, t_wql, t_usgs, temp, trp, cdom, w_lvl);
savefig("All_Timeseries.fig");

%% -------------------- POLAR PLOTS: UNFILTERED --------------------

makepolarplots(temp, t_wql);
title("Temperature Extrema by Time of Day");
savefig("Temp_1.fig");
legend off;

makepolarplots(trp, t_wql);
title("TRP Extrema by Time of Day");
savefig("TRP_1.fig");
legend off;

makepolarplots(cdom, t_wql);
title("CDOM Extrema by Time of Day");
savefig("CDOM_1.fig");
legend off;

makepolarplots(w_lvl, t_usgs);
title("Gauge Height Extrema by Time of Day");
savefig("GH_1.fig");
legend off;

%% -------------------- POLAR PLOTS: FILTERED --------------------

temp_dat = makepolarplots_v4(qc_temp);
title("Temperature Extrema by Time of Day");
savefig("Temp_2.fig");
legend off;

trp_dat = makepolarplots_v4(qc_trp);
title("TRP Extrema by Time of Day");
savefig("TRP_2.fig");
legend off;

cdom_dat = makepolarplots_v4(qc_cdom);
title("CDOM Extrema by Time of Day");
savefig("CDOM_2.fig");
legend off;

gh_dat = makepolarplots_v4(qc_GH);
title("Gauge Height Extrema by Time of Day");
savefig("GH_2.fig");
legend off;

%% -------------------- MEAN DIURNAL PROFILES --------------------

trp_cumsum  = meanDiurnalProfileFromTimetable(current_dataset,   qc_trp,  "trp",         10);
cdom_cumsum = meanDiurnalProfileFromTimetable(current_dataset,   qc_cdom, "cdom",        10);
temp_cumsum = meanDiurnalProfileFromTimetable(current_dataset,   qc_temp, "temp",        10);
wlvl_cumsum = meanDiurnalProfileFromTimetable(current_USGS_data, qc_GH,   "water_level", 15);

% Normalize by z-scores
trp_cumsum  = norm_smooth(trp_cumsum);
cdom_cumsum = norm_smooth(cdom_cumsum);
temp_cumsum = norm_smooth(temp_cumsum);
wlvl_cumsum = norm_smooth(wlvl_cumsum);

%% -------------------- PLOT Z-SCORED DAILY PROFILES --------------------

figure;

plot(cdom_cumsum.Hour, cdom_cumsum.MeanValue, ...
    "DisplayName", "CDOM", "Color", "magenta");
hold on;

plot(trp_cumsum.Hour, trp_cumsum.MeanValue, ...
    "DisplayName", "TRP", "Color", "cyan");

plot(temp_cumsum.Hour, temp_cumsum.MeanValue, ...
    "DisplayName", "Temperature");

plot(wlvl_cumsum.Hour, wlvl_cumsum.MeanValue, ...
    "DisplayName", "Gauge Height", "Color", "blue");

hold off;

ax = gca;
ax.FontName = "Arial";
ax.FontSize = 18;
ax.LineWidth = 1;
ax.TickDir = "none";

lines = findobj(gcf, "Type", "line");
set(lines, "LineWidth", 1);

legend("Location", "best", "Box", "off", "Color", "none");

annotation("textbox", ...
    [0.02878 0.05116 0.06011 0.06047], ...
    "String", "a.", ...
    "FontName", "Arial", ...
    "FontSize", 18, ...
    "FontWeight", "bold", ...
    "EdgeColor", "none");

xlim([0.0 23.4]);
ylim([-1.91 1.69]);

title("Z-Scored Average Daily Value, " + string(monthname) + " " + string(analysisYear));
xlabel("Hour");
ylabel("Z-Score");

savefig("CumSumZScored.fig");

%% -------------------- SAVE FINAL MONTHLY OUTPUTS --------------------

cd ..;

save("All_Filtered_Param_Stats.mat", "temp_dat", "trp_dat", "cdom_dat", "gh_dat");
save("CumSum.mat", "trp_cumsum", "cdom_cumsum", "temp_cumsum", "wlvl_cumsum");

%% -------------------- CLEAN UP --------------------

clear;
clc;

cd ..;
