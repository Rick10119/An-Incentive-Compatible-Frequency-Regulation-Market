
% 现有机制

% 合并风电和光伏
R_c_clear(:, 1) = R_c_clear(:, 1) + R_c_clear(:, 2);
R_c_clear = [R_c_clear(:, 1), R_c_clear(:, 3 : 4)];
R_c_clear = [R_c_clear; R_c_clear(end, :)];
R_max_result = [R_max; R_max(end, :)];
R_max_result = [R_max_result(:, 1:2) * ones(2, 1), R_max_result(:, 3:4)];
Price_cap = [Price_cap; Price_cap(end)];
%%

linewidth = 1;

hold on;

% 最大容量
% EV
plot(0:24, R_c_clear(:, 2)', 'm', 'linewidth', linewidth);
plot(0:24, R_max_result(:, 2)', '--m', 'linewidth', linewidth);

% ES
plot(0:24, R_c_clear(:, 3)', 'r', 'linewidth', linewidth);
plot(0:24, R_max_result(:, 3)', '--r', 'linewidth', linewidth);

plot(0:24, R_c_clear(:, 1)', 'b', 'linewidth', linewidth);

% 价格
plot(Price_cap); hold off;


legend('EV-cleared','EV-max capacity','ES-cleared','ES-max capacity','VRE-cleared', 'Regulation Price (Capacity)', ...
'fontsize',13.5, ...
'Location','NorthEast', ...
'Orientation','horizontal', ...
'NumColumns', 2, ...
'FontName', 'Times New Roman'); 

set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Cleared Regulation Capacity (MW)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');



set(gca, "xlim", [0, 24]);
% set(gca, "ylim", [0, 150]);

% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2.35 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);


% 轴属性
ax = gca;
% ax.XLim = [0, 17];    
% ax.YLim = [-3, 3]; 
% ax.YLim = [30, 50];     
% 字体与大小

ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [0: 4 : 24];
% ax.YTick = [-3:3];
% 
% % 调整标签
% ax.XTickLabel =  {'18','19','20','21','22','23','24','1','2','3','4','5','6','7','8','9'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [17.5, 12]);

saveas(gcf,'出清容量-1.jpg'); 