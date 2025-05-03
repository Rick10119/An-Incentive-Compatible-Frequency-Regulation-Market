
close;

if ~ exist('Signals')
    clc;clear;
    read_data;
end
if ~ exist('Distribution')
    handle_raw_data;
end
% 现有机制
% current_main;
% save("results/allocate_cur.mat", "allocate");
load("results/allocate_cur.mat");

total_cost = allocate.cost;

plot(allocate.abd_vre, '--b');hold on;
plot(allocate.cost_deg, '--r');

x = [];
x = [x; sum(allocate.abd_vre ./ Price_wholesale), sum(allocate.abd_vre), sum(allocate.cost_deg)];

% 所提机制
% new_main;
% save("results/allocate_new.mat", "allocate");
load("results/allocate_new.mat");

plot(allocate.abd_vre, '-b');hold on;% 弃电量
plot(allocate.cost_deg, '-r'); % + 5 * abs(P_es)


x = [x; sum(allocate.abd_vre ./ Price_wholesale), sum(allocate.abd_vre), sum(allocate.cost_deg)];

%%


legend('Value of Abandoned VRE (Current Mechanism)', ...
    'Degradation Cost of ES (Current Mechanism)', ...
    'Value of Abandoned VRE (Proposed Mechanism)', ...
    'Degradation Cost of ES (Proposed Mechanism)', ...
'fontsize',13.5, ...
'Location','NorthWest', ...
'FontName', 'Times New Roman'); 

set(gca, "YGrid", "on");

%设置figure各个参数
x1 = xlabel('Hour','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('$','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');



set(gca, "xlim", [0, 25]);
% set(gca, "ylim", [0, 150]);

%% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2.35 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);


%% 轴属性
ax = gca;

ax.FontSize = 13.5;

% 设置刻度
ax.XTick = [0: 4 : 24];
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [17.5, 12]);
