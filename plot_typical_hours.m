close;
% new_main;
hour = 21;

% 新机制
new_allocate;
% 边际价格
allocate.lambda = sol.solveroutput.lambda.eqlin;
allocate.lambda_up = sol.solveroutput.lambda.eqlin;
allocate.lambda_dn = sol.solveroutput.lambda.eqlin;


% 统计现有机制的数据
% 出力情况 新能源、EV、ES
allocate.P_ver = (allocate.P_up((hour-1) * 1800 + 1 : hour * 1800, 1:2) - ...
    allocate.P_dn((hour-1) * 1800 + 1 : hour * 1800, 1:2)) * ones(2, 1);

allocate.P_ev = (allocate.P_up((hour-1) * 1800 + 1 : hour * 1800, 3) - ...
    allocate.P_dn((hour-1) * 1800 + 1 : hour * 1800, 3));

allocate.P_es = (allocate.P_up((hour-1) * 1800 + 1 : hour * 1800, 4:5) - ...
    allocate.P_dn((hour-1) * 1800 + 1 : hour * 1800, 4:5)) * ones(2, 1);

allocate.P_es2 = (allocate.P_up((hour-1) * 1800 + 1 : hour * 1800, 5:6) - ...
    allocate.P_dn((hour-1) * 1800 + 1 : hour * 1800, 5:6)) * ones(2, 1);

allocate.ttp = [allocate.P_ver, allocate.P_ev, allocate.P_es, allocate.P_es2] * ones(4, 1);

% x = (allocate.P_dn((hour-1) * 1800 + 1 : hour * 1800, 4:5)) * ones(2, 1);
% plot(x);
%%

plot(allocate.P_ver, '-b');hold on;
plot(allocate.P_ev, '-m');
plot(allocate.P_es, '-r');
plot(allocate.ttp, '--');
x1 = xlabel('Time','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');          %轴标题可以用tex解释
y1 = ylabel('Adjusted Output (MW)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');
ax = gca;
ax.YTick = [-50 : 25 : 50];
% 画右轴
yyaxis right
% ax.YLim = [0, 90];     
ax = gca;
ax.YColor = 'black';
plot(allocate.lambda, '-g');

% legend('风电+光伏','EV','ES','总调整量','边际价格(向上)','边际价格(向下)','fontsize',12); %,'主网购电'


legend('VRE-Adjusted Output','EV-Adjusted Output','ES-Adjusted Output', ...
    'Total-Adjusted Output', ...
    'Marginal Price for Output Adjustment', ...
    'fontsize',13.5, ...
    'Location','NorthOutside', ...
'Orientation','horizontal', ...
'NumColumns', 2, ...
'FontName', 'Times New Roman'); 
set(gca, "YGrid", "on");
% set(gca, "ylim", [-100, 100]);
% set(gca,'GridLineStyle',':');

%设置figure各个参数

y1 = ylabel('Marginal Price ($/MWh)','FontSize',13.5,'FontName', 'Times New Roman','FontWeight','bold');



m=linspace(datenum(hour - 1 + ":00",'HH:MM'),datenum(hour  + ":00",'HH:MM'),10);
% set(gca,'xtick',2:0.2:3);
for n=1:length(m)
    tm{n}=datestr(m(n),'HH:MM');
end
set(gca,'xticklabel',tm);

%% 图片大小
figureUnits = 'centimeters';
figureWidth = 20;
figureHeight = figureWidth * 2 / 4;
set(gcf, 'Units', figureUnits, 'Position', [10 10 figureWidth figureHeight]);

% 调整标签
% ax.XTickLabel =  {'18','19','20','21','22','23','24','1','2','3','4','5','6','7','8','9'};
ax.FontName = 'Times New Roman';
set(gcf, 'PaperSize', [19.4, 10]);
