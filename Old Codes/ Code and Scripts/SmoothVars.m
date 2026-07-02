% Smooth input data
wql_params = smoothdata(wql_params,"gaussian",7,DataVariables="cdom");

% Smooth input data
wql_params = smoothdata(wql_params,"gaussian",7,DataVariables="trp");

% Smooth input data
wql_params = smoothdata(wql_params,"gaussian",7,DataVariables="temp");

% Smooth input data 
usgs_tab = smoothdata(usgs_tab,"gaussian",7,DataVariables="w_lvl");

% Extract updated data

cdom = wql_params.cdom;
trp = wql_params.trp;
temp = wql_params.temp;

% Extract smoothed water level data
w_lvl = usgs_tab.w_lvl;

