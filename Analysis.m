%%% Set up files %%%
%%
% Start by creating a new folder to perform analysis 
mkdir('2024');
cd("2024")
% Navigate to this folder and ensure that the necessary CSV files are
% inside it, if not, put them in this folder. 
%%
% add codes to path, change this path to wherever the codes are located
addpath("/MATLAB Drive/sunflower_v2/ Code and Scripts")
addpath("/MATLAB Drive/sunflower_v2/Test Codes")
%%
%%% Importing and processing USGS data %%%
%%
USGS_data = importUSGS("gage_height_jan-sep.csv"); % replace USGS.csv with path to the USGS water CSV file name
%%
save("USGS_data","USGS_data");
%%
processUSGSData(USGS_data, "USGS_2025"); % split USGS into months, save it as .mat
%%
%%
%%% Importing and processing WQL data %%%
%%
data_report = importfile("data_report_12-15-2025_05-07-34.csv"); % load in CSV data
save("data_report.mat", "data_report");
%%
[trp, temp, cdom, t_wql] = prep_set(data_report_2024); % extract variables 
%%
%%% Temperature Corrections %%% 
[temp_corrected_cdom, temp_corrected_trp] = TempCorrections(cdom, trp, temp); % apply temp corrections
%%
% Make a comparison function to compare normal vs detrended plots 
%%
%%% Detrending %%%
% open DetrendCDOM.m and DetrendTRP.m to manually enter date pairs, save
% and when done with changes. 
generate_cleaning_dates
%%
% Run this section to Detrend CDOM
DetrendCDOM2024
savefig("CDOM_Detrended.fig");
%%
% Run this section to Detrend TRP
DetrendTRP2024
savefig("TRP_Detrended")
%%
% Save TRP and CDOM final
final_params = table(trp_final,cdom_final);
%%
% Save regression error statistics for later 
saveerrorstructures
%%
%%% Spliting WQL data into months for downstream analysis 
wql_monthsets = split_months(t_wql, trp_final, cdom_final, temp, 12);
%%
% Save the monthly sets we need for the rest of the analysis in a .mat file
save('monthly_wql_data.mat', 'wql_monthsets');
%%
% Save final corrected TRP and CDOM into own mat files for analysis 
save("cdom_result_report.mat", 'cdom_final');
save("trp_result_report.mat", 'trp_final');
%%
%%% Now we clear workspace vars for the rest of the analysis 
clear
%%
%[text] ## We continue the analysis with the monthly sets. 
%%
% in case it isn't already on path 
addpath '/MATLAB Drive/sunflower_v1/Correction Analysis/Codes'
%%
% Load the monthly data for further analysis, bring into workspace
load('monthly_wql_data.mat', 'wql_monthsets');
load('USGS_2025.mat', 'USGSmonthSets'); 
%%
%addpath '/MATLAB Drive/sunflower/Correction Analysis/Prepare Data/2024/USGS/'
%%
%load("monthSets.mat")
%load('USGS/USGSMonthSets.mat');
%%
% Make a new dir, for the month we are working with ex: 
% etc...
n = 12; % 1 = Jan, 2 = Feb etc...
m = 4; % adjust for USGS
monthname = setupdir(n,2024);
%%
% Setup WQL dataset
current_dataset = setupWQLdata(n, wql_monthsets);

% Setup USGS data
current_USGS_data = setupUSGSdata(m,USGSmonthSets);

% Save data into .mat
save("data.mat", "current_dataset","current_USGS_data");
%%
% Save as CSVs
writeWQLfile(monthname, current_dataset);
%%
% OPTIONAL IF USGS DATA AVAILABLE, if not available, skip this section 
writeUSGSfile(monthname,current_USGS_data);
%%
%%% Pull vars %%%
t_wql       = current_dataset.t_wql;
trp         = current_dataset.trp;
cdom        = current_dataset.cdom;
temp        = current_dataset.temp; 
%%
% Pull USGS vars 
t_usgs      = current_USGS_data.Time;
w_lvl       = current_USGS_data.water_level;
%%
save("All_Params", "t_usgs", "t_wql", "temp", "cdom", "trp", "w_lvl");
%%
get_raw_stats % needs to be updated 

%%
% Save stat tables
save("Peak_Stats.mat","PstatsTbl");
save("Trough_Stats.mat","TstatsTbl");
%%
% Filter parameters
qc_temp = qc_diurnal_singlepeak_v3(temp,t_wql);
qc_trp = qc_diurnal_singlepeak_v3(trp,t_wql);
qc_cdom = qc_diurnal_singlepeak_v3(cdom,t_wql);
qc_GH = qc_diurnal_singlepeak_v3(w_lvl,t_usgs);
%%
% Save
save("Filtered_Params.mat", "qc_temp", "qc_trp", "qc_cdom", "qc_GH");
%%
%[text] ## Make Directory for figures 
mkdir("Figures")
cd("Figures")
%%

% Plot all params w detected peaks 
plotall(n,2024,t_wql,t_usgs,temp,trp,cdom,w_lvl);
savefig("All_Timeseries.fig")
%%
% Plot histograms before filtering 
%%
makepolarplots(temp,t_wql);
title("Temp Extrerema by Time of Day")
savefig("Temp_1.fig")
legend off
makepolarplots(trp,t_wql);
title("Trp Extrema by Time of Day")
savefig("Trp_1.fig")
legend off
makepolarplots(cdom,t_wql);
title("CDOM Extrema by Time of Day")
savefig("CDOM_1.fig")
legend off
makepolarplots(w_lvl, t_usgs);
title("Gauge Height by Time of Day")
savefig("GH_1.fig")
legend off

%%
% Plot filtered histograms 
temp_dat = makepolarplots_v4(qc_temp);
title("Temp Extrema by Time of Day")
savefig("Temp_2.fig")
legend off
trp_dat = makepolarplots_v4(qc_trp);
title("Trp Extrema by Time of Day")
savefig("Trp_2.fig")
legend off 
cdom_dat = makepolarplots_v4(qc_cdom);
title("CDOM Extrema by Time of Day")
savefig("CDOM_2.fig")
legend off
gh_dat = makepolarplots_v4(qc_GH);
title("Gauge Height by Time of Day")
savefig("GH_2.fig")
legend off
%%
% Make cumulative sum plots 

[trp_cumsum] = meanDiurnalProfileFromTimetable(current_dataset, qc_trp, 'trp', 10);
[cdom_cumsum] = meanDiurnalProfileFromTimetable(current_dataset,qc_cdom, 'cdom', 10);
[temp_cumsum] = meanDiurnalProfileFromTimetable(current_dataset,qc_temp, 'temp', 10);
[wlvl_cumsum] = meanDiurnalProfileFromTimetable(current_USGS_data,qc_GH, 'water_level', 15);

% Normalize by z-scores
trp_cumsum = norm_smooth(trp_cumsum);
cdom_cumsum = norm_smooth(cdom_cumsum);
temp_cumsum = norm_smooth(temp_cumsum);
wlvl_cumsum = norm_smooth(wlvl_cumsum); 

%%
% Plot the z-scored cumulative sums
figure;
plot(cdom_cumsum.Hour,cdom_cumsum.MeanValue, "DisplayName","CDOM",color= 'magenta');
hold
plot(trp_cumsum.Hour, trp_cumsum.MeanValue, "DisplayName","Trp", color= 'cyan');
plot(temp_cumsum.Hour, temp_cumsum.MeanValue, "DisplayName","Temp");
plot(wlvl_cumsum.Hour,wlvl_cumsum.MeanValue,"DisplayName","Gauge Height",Color='blue');

% Figure settings
hAxes = findobj(gcf,"Type","axes");
hAxes.FontName = "Arial";
hAxes.FontSize = 18;
hAxes.LineWidth = 1;
hLine = findobj(gcf,"Type","line");
hLine(2).LineWidth = 1;
hLine(1).LineWidth = 1;
hLine(3).LineWidth = 1;
hLine(4).LineWidth = 1;
hAxes.TickDir='none';
legend(["CDOM", "Trp", "Temp", "Gauge Height"], "BackgroundAlpha", 0, "Color", [1.0000 1.0000 1.0000], "EdgeColor", "none", "Position", [0.1358 0.1649 0.2608, 0.2414]);
hLegend = findobj(gcf,"Type","legend");
hLegend.BackgroundAlpha = 0;
annotation("textbox", [0.02878 0.05116 0.06011 0.06047], "String", "a.", "FontName", "Arial", "FontSize", 18, "FontWeight", "bold", "EdgeColor", "none")
xlim([0.0 23.4])
ylim([-1.91 1.69])

title("Z-Scored Average Daily Value January 2025");
xlabel("Hour");
ylabel("Z-Score");
legend()
savefig('CumSumZScored');
%%
% Notes 
% _1.fig files are unfiltered
% _2.fig files are filtered 
%%
cd .. % go back one dir 
save("All_Filtered_Param_Stats", "temp_dat","trp_dat","cdom_dat","gh_dat");
save('CumSum.mat',"trp_cumsum","cdom_cumsum","temp_cumsum","wlvl_cumsum");
%%
clear
clc
cd ..

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":16.1}
%---
