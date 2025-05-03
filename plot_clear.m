%% Plot market clearing results

% Combine resource types for plotting
% Merge wind and PV into VRE
R_c_clear(:, 1) = R_c_clear(:, 1) + R_c_clear(:, 2);
R_c_clear = [R_c_clear(:, 1), R_c_clear(:, 3 : 4)];
% Add last point for smooth plotting
R_c_clear = [R_c_clear; R_c_clear(end, :)];
R_max_result = [R_max; R_max(end, :)];
% Combine wind and PV capacity
R_max_result = [R_max_result(:, 1:2) * ones(2, 1), R_max_result(:, 3:4)];
% Add last price point
Price_cap = [Price_cap; Price_cap(end)];

% Set line width for all plots
linewidth = 1;

hold on;

% Plot cleared capacities and maximum capacities
% Electric Vehicles
plot(0:24, R_c_clear(:, 2)', 'm', 'linewidth', linewidth);
plot(0:24, R_max_result(:, 2)', '--m', 'linewidth', linewidth);

% Energy Storage
plot(0:24, R_c_clear(:, 3)', 'r', 'linewidth', linewidth);
plot(0:24, R_max_result(:, 3)', '--r', 'linewidth', linewidth);

% Variable Renewable Energy (Wind + PV)
plot(0:24, R_c_clear(:, 1)', 'b', 'linewidth', linewidth);

% Plot regulation price
plot(Price_cap); hold off;

% Set legend properties
legend('EV-cleared','EV-max capacity','ES-cleared','ES-max capacity','VRE-cleared', 'Regulation Price (Capacity)', ...
'fontsize',13.5, ...
'Location','NorthEast', ...
'Orientation','horizontal', ...
'NumColumns', 2, ...
'FontName', 'Times New Roman'); 

% Enable grid
set(gca, "YGrid", "on");

% Set axis labels
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
y1 = ylabel('Cleared Regulation Capacity (MW)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');

% Set axis limits
set(gca, "xlim", [0, 24]);
% set(gca, "ylim", [0, 150]);

% Set figure size in centimeters
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2.35 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% Configure axis properties
ax = gca;
% ax.XLim = [0, 17];    
% ax.YLim = [-3, 3]; 
% ax.YLim = [30, 50];     

% Set font size
ax.FontSize = 13.5;

% Set tick marks
ax.XTick = [0: 4 : 24];
% ax.YTick = [-3:3];

% Set font
ax.FontName = 'Times New Roman';

% Set paper size for saving
set(gcf, 'PaperSize', [17.5, 12]);

% Save figure
saveas(gcf,'plot_clear.jpg'); 