%% 画出比例分配的示意图

close;

%% 给定调频信号
signal = 0 : 0.1 : 1;
signal1 = [signal(1:5), 0.4 * ones(1, 6)] / 0.4;
signal2 = (signal - signal1 * 0.4)/0.6;
p1 = signal1 * 40;
p2 = signal2 * 60;
t = 0 : 10;

linewidth = 2;

plot(t, p1, '-b',  'linewidth', linewidth);hold on;
plot(t, p2, '-r',  'linewidth', linewidth);


x1 = xlabel('Time (s)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Adjusted Output (MW)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
ax = gca;
ax.YLim = [0, 100]; 
% ax.YTick = [-50 : 25 : 50];
% 画右轴
yyaxis right
% ax.YLim = [0, 90];     
ax = gca;
ax.YColor = 'black';
plot(t, signal1, '--b',  'linewidth', linewidth);hold on;
plot(t, signal2, '--r',  'linewidth', linewidth);

legend('R1-Adjusted Output','R2-Adjusted Output', ...
    'AGC Signal', ...
    'fontsize',13.5, ...
    'Location','NorthWest', ...
'FontName', 'Times New Roman'); 
% set(gca, "YGrid", "on");
% set(gca, "ylim", [-100, 100]);
% set(gca,'GridLineStyle',':');

%设置figure各个参数

y1 = ylabel('AGC Signal Value','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');


%% 图片大小
figureUnits = 'centimeters';
figureWidth = 10;
figureHeight = figureWidth;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

ax.XTick = [0: 1 : 9];
% ax.YTick = [-3:3];
% 
% % 调整标签
ax.XTickLabel =  {'0','10','20','30','40','50','60','70','80','90'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19.4, 10]);
