function [cdom_corr, trp_corr] = TempCorrections(data_report)

    % Extract variables
    [trp, temp, cdom, ~] = prep_set(data_report);

    % Correction factors
    rho_cdom = -0.00807;
    rho_trp  = -0.00576;

    % Apply corrections
    cdom_corr = cdom ./ (1 + rho_cdom .* (temp - 20));
    trp_corr  = trp  ./ (1 + rho_trp  .* (temp - 20));

end