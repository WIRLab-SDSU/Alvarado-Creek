% to use this script, enter each of the directories EX: (2024/TRP), then
% run it, ensure that the modelFiles exist in each 
% Ensure the modelFiles exist in the specified directories

if ~all(isfile(modelFiles))
    error('One or more model files do not exist in the specified directories.');
end

modelFiles = ["First Order.mat", "Second Order.mat", "Third Order.mat", "Fourth Order.mat", "Fifth Order.mat"];

numModels = length(modelFiles);

average_rsquared = zeros(numModels, 1);
standard_deviation = zeros(numModels, 1);
modelNames = strings(numModels, 1);

for j = 1:numModels

    % Load one model file
    data = load(modelFiles(j));

    % Extract stored fit structures
    param_error_structures = data.param_error_structures;

    rsquaredValues = zeros(1, length(param_error_structures));

    for i = 1:length(param_error_structures)

        % Extract struct from cell
        fitStats = param_error_structures{i};

        % Extract R^2
        rsquaredValues(i) = fitStats.rsquared;
    end

    % Store summary statistics
    average_rsquared(j) = mean(rsquaredValues);
    standard_deviation(j) = std(rsquaredValues);

    % Store model/file name
    modelNames(j) = modelFiles(j);
end

summaryTable = table(modelNames, average_rsquared, standard_deviation);
% Display the summary table
disp(summaryTable);
% Save the summary table into the folder
writetable(summaryTable, 'model_summary.csv');