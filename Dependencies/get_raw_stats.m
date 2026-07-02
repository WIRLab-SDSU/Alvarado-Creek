% -- run peak detection calls ------------------------------------------
[stdTemp,  meanTemp]  = stat_rep(temp,  t_wql);   % °C
[stdCDOM,  meanCDOM]  = stat_rep(cdom,  t_wql);   % RFU
[stdTrp,   meanTrp]   = stat_rep(trp,   t_wql);   % RFU
[stdWlvl,  meanWlvl]  = stat_rep(w_lvl, t_usgs);  % ft

% -- build peak stats table ---------------------------------------
paramNames = {'Temperature'; 'CDOM'; 'Tryptophan'; 'Water Level'};

% Convert mean times (duration) to hh:mm text
meanHours= [meanTemp, meanCDOM, meanTrp, meanWlvl];
meanDur = hours(meanHours);
meanTxt = cellstr(datestr(meanDur, "HH:MM"));

PstatsTbl = table(paramNames, ...
                  meanTxt, ...
                  [stdTemp; stdCDOM; stdTrp; stdWlvl], ...
                  'VariableNames', {'Parameter','Peak_Mean','Std_Hours'});

disp(PstatsTbl)

% Also display std as duration format
stdVec  = [stdTemp; stdCDOM; stdTrp; stdWlvl];
stdDur  = hours(stdVec);
stdDur.Format = 'hh:mm';
disp(stdDur)

% -- run trough detection calls (invert signal) ------------------------
[stdTemp,  meanTemp]  = stat_rep(-temp,  t_wql);   % °C
[stdCDOM,  meanCDOM]  = stat_rep(-cdom,  t_wql);   % RFU
[stdTrp,   meanTrp]   = stat_rep(-trp,   t_wql);   % RFU
[stdWlvl,  meanWlvl]  = stat_rep(-w_lvl, t_usgs);  % ft

% -- build trough stats table -------------------------------------
meanHours= [meanTemp, meanCDOM, meanTrp, meanWlvl];
meanDur = hours(meanHours);
meanTxt = cellstr(datestr(meanDur, "HH:MM"));

TstatsTbl = table(paramNames, ...
                  meanTxt, ...
                  [stdTemp; stdCDOM; stdTrp; stdWlvl], ...
                  'VariableNames', {'Parameter','Trough_Mean','Std_Hours'});

disp(TstatsTbl)

stdVec  = [stdTemp; stdCDOM; stdTrp; stdWlvl];
stdDur  = hours(stdVec);
stdDur.Format = 'hh:mm';
disp(stdDur)
