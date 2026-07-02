function plotCleanedParameter(t, cleaned_data, cleaning_dates, plotTitle, yLabelText)

%PLOTCLEANEDPARAMETER Plot cleaned parameter and cleaning-date boundaries.

    arguments
        t
        cleaned_data
        cleaning_dates
        plotTitle string = "Parameter After Segment-Wise Cleaning"
        yLabelText string = "Cleaned Parameter"
    end

    figure;
    plot(t, cleaned_data, "LineWidth", 1.2);
    xlabel("Time");
    ylabel(yLabelText);
    title(plotTitle);

    all_dates = cleaning_dates(:);

    for k = 1:numel(all_dates)
        xl = xline(all_dates(k), "--", ...
            "Color", [0.7 0 0.7], ...
            "LineWidth", 1.0);

        xl.HandleVisibility = "off";
        xl.PickableParts = "none";
        xl.HitTest = "off";
    end
end
