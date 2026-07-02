function output = norm_smooth(input)
	% Smooth input data
	output = smoothdata(input,"gaussian","SmoothingFactor",0.25, ...
	    "DataVariables","MeanValue");
	% Normalize Data
	output = normalize(output,"DataVariables","MeanValue");
end