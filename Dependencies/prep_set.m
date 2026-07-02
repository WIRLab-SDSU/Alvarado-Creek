function [trp, temp, cdom, t_wql] = prep_set(x)
current_ds = x;

% Perform any necessary preprocessing on the dataset
trp = current_ds.trp;
temp = current_ds.temp;
cdom = current_ds.cdom;
t_wql = current_ds.dateTime;