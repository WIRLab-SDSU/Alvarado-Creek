% Make 4 panel plot 
figure;

subplot(4, 1, 1); % First panel
makepolarplots(temp,t_wql);
title("help")
hold off
subplot(4, 2, 2); % Second panel
makepolarplots(trp, t_wql); 
title("me")