function y_tab = fil_ol2(y_tab)
    y_tab = y_tab(:);  % ensure column vector
	% Fill outliers
	y_tab = filloutliers(y_tab,"linear","movmedian",100); % was 100
	% Fill missing data
	y_tab = fillmissing(y_tab,"next"); %was next
end