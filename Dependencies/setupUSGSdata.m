function USGS = setupUSGSdata(x, USGSmonthSets)
usgs_tt = USGSmonthSets{x};
[~, idx] = unique(usgs_tt.Time);
USGSmonthSets{x} = usgs_tt(sort(idx), :);

USGS = USGSmonthSets{x};

%[appendix]{"version":"1.0"}
%---
