%% 处理原始的信号数据
%% 按照0.1分辨度整理：1）这个月regd信号分布，2）5月20日regd信号分布

% 参数设置
diff = 0.1;% 分辨度

Distribution = zeros(2 / diff + 2, 1); % 初始化，离散化df，单独考虑-1和1
day = 20;% 5月20日
signal_length = 43202 -2;% (去除首尾，共24*1800)

Distributions = [];

for day_idx = day - 7 : day - 1 % 过去七天的数据
signals = Signals(1 : end - 1, day_idx);% 取出列
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

Distributions = [Distributions, Distribution];

% plot(Distribution);hold on;
% plot(test);
end

Distribution = Distributions * 1/7 * ones(7, 1);
%% 计算历史里程

Mileage = [];
for day_idx = 1:31
    
    % 取出列（一天）
    signals = Signals(1 : end - 1, day_idx);
    
    % 计算一天的里程
    mileage = sum(abs(signals(2 : end) - signals(1 : end - 1)));

    Mileage = [Mileage; mileage];
end

Mileage = Mileage/ 24 / 2;% 摊到小时、除以容量；