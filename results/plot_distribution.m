% 参数设置
diff = 0.1;% 分辨度
Distribution = zeros(2 / diff + 2, 1); % 初始化，离散化df，单独考虑-1和1
day = 20;% 5月20日
signal_length = 43202 -2;% (去除首尾，共24*1800)

Distributions = [];
d_scenario = [-1; (-1 + 0.5 * diff :diff: 1 - 0.5 * diff)'; 1];
for day = 1:31
signals = Signals(1 : end - 1, day);% 取出列
% 扫描，得到pdf
for t_cap = 1 : signal_length
    if signals(t_cap) >= 0 % 向上调频
        s_idx = ceil(signals(t_cap) / diff) + 1 / diff + 1; % 场景编号
        if signals(t_cap) > 0.9999 % 当作1计算
            s_idx = length(Distribution);
        end
    else
        s_idx = floor(signals(t_cap) / diff) + 1 / diff + 2; % 场景编号
        if signals(t_cap) < - 0.9999 % 当作1计算
            s_idx = 1;
        end
    end
    Distribution(s_idx) = Distribution(s_idx) + 1;
end

% 计算频率
Distribution = Distribution / sum(Distribution);

    Distributions = [Distributions; Distribution];
plot(d_scenario, Distribution);hold on;

end

set(gca, "YGrid", "on");
set(gca, "XGrid", "on");
% set(gca,'GridLineStyle',':');
% set(gca, "xlim", [0, 24]);
set(gca, "ylim", [0, 0.2]);

%设置figure各个参数
x1 = xlabel('AGC场景(归一化调整量)','FontSize',15);          %轴标题可以用tex解释
y1 = ylabel('出现概率','FontSize',15);

x1.FontName = '宋体'; 
y1.FontName = '宋体'; 

% m=linspace(datenum("-1",'HH'),datenum("24",'HH'),6);
% % set(gca,'xtick',2:0.2:3);
% for n=1:length(m)
%   tm{n}=datestr(m(n),'HH:MM');
% end
% set(gca,'xticklabel',tm);

saveas(gcf,'AGC分布.jpg'); 


