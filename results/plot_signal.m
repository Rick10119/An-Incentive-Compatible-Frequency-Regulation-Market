% 参数设置
diff = 0.1;% 分辨度
Distribution = zeros(2 / diff + 2, 1); % 初始化，离散化df，单独考虑-1和1
day = 20;% 5月20日
signal_length = 43202 -2;% (去除首尾，共24*1800)

Distributions = [];
d_scenario = [-1; (-1 + 0.5 * diff :diff: 1 - 0.5 * diff)'; 1];

signals = Signals(1 : end - 1, day);% 取出列

plot(signals);

set(gca, "YGrid", "on");
set(gca, "XGrid", "on");
% set(gca,'GridLineStyle',':');
% set(gca, "xlim", [0, 24]);
% set(gca, "ylim", [0, 0.2]);

%设置figure各个参数
x1 = xlabel('hour','FontSize',15);          %轴标题可以用tex解释
y1 = ylabel('AGC归一化调整量','FontSize',15);


x1.FontName = '宋体'; 
y1.FontName = '宋体'; 

m=linspace(datenum(0 + ":00",'HH:MM'),datenum(24  + ":00",'HH:MM'),10);
% set(gca,'xtick',2:0.2:3);
for n=1:length(m)
    tm{n}=datestr(m(n),'HH:MM');
end
set(gca,'xticklabel',tm);

saveas(gcf,'AGC信号.jpg'); 


