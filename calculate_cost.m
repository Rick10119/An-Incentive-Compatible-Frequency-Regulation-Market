%% 测算成本


% 逐小时计算
allocate.cost = zeros(TIME, 1);
allocate.cost_deg = zeros(TIME, 1);
allocate.cost_deg2 = zeros(TIME, 1);
allocate.cost_rp  = zeros(TIME, NOFTYPES + 2);

% 用真实成本计算
r = r/rate;
r2 = r2/rate2;
new_bid;


for t_cap = 1 : signal_length
    % 时段积累成本(每2s一个信号)
    % 统计各资源、各时段的成本。
    allocate.cost_rp(hour_idx(t_cap), :) = allocate.cost_rp(hour_idx(t_cap), :) + ...
        allocate.P_up(t_cap, :) .* p_q_pair.price_up(hour_idx(t_cap), :) * 2/3600 + ...
        allocate.P_dn(t_cap, :) .* p_q_pair.price_dn(hour_idx(t_cap), :) * 2/3600;
    
    % 储能老化成本
    allocate.cost_deg(hour_idx(t_cap), :) = allocate.cost_deg(hour_idx(t_cap), :) + ...
        5 * abs(  (allocate.P_up(t_cap, 4:5) - allocate.P_dn(t_cap, 4:5)) * ones(2, 1) + ...
        (1 - ratio) * P_es(hour_idx(t_cap)) ) * 2/3600;
    % 储能2
    allocate.cost_deg2(hour_idx(t_cap), :) = allocate.cost_deg2(hour_idx(t_cap), :) + ...
        5 * abs(  (allocate.P_up(t_cap, 6:7) - allocate.P_dn(t_cap, 6:7)) * ones(2, 1) + ...
        ratio * P_es(hour_idx(t_cap)) ) * 2/3600;

end

% 合并新能源成本、储能两段成本
allocate.cost_rp(:, 1) = allocate.cost_rp(:, 1) + allocate.cost_rp(:, 2);
allocate.cost_rp(:, 4) = allocate.cost_rp(:, 4) + allocate.cost_rp(:, 5);
allocate.cost_rp(:, 6) = allocate.cost_rp(:, 6) + allocate.cost_rp(:, 7);
allocate.cost_rp = [allocate.cost_rp(:, 1), allocate.cost_rp(:, 3:4), allocate.cost_rp(:, 6)]; 

% 总运行成本-小时
allocate.cost = allocate.cost_rp * ones(4, 1);


% 加上容量成本
allocate.cost = allocate.cost + (p_c.p_c .* R_c_result) * ones(5, 1);
% 弃电成本(容量 + 运行)
allocate.cost_vre = allocate.cost_rp(:, 1) + (p_c.p_c .* R_c_result) * [1, 1, 0, 0, 0]';

% 弃电量
% allocate.abd_vre = allocate.cost_vre ./ Price_wholesale;
% 弃电量价值
allocate.abd_vre = allocate.cost_vre;
% 弃电量比例
sum(allocate.cost_vre ./ Price_wholesale) / sum(R_c_result * [1, 1, 0, 0, 0]');
%% 服务费用

% 容量费用
allocate.cap_cost =  p_c.p_c .* R_c_result;

allocate.cost_wp = sum(allocate.cost_rp(:, 1) + allocate.cap_cost(:, 1:2) * ones(2, 1));
allocate.cost_ev = sum(allocate.cost_rp(:, 2) + allocate.cap_cost(:, 3));
allocate.cost_es = sum(allocate.cost_rp(:, 3) + allocate.cap_cost(:, 4));
allocate.cost_es2 = sum(allocate.cost_rp(:, 4) + allocate.cap_cost(:, 5));
% 检查
% x = [x, [allocate.cost_wp; allocate.cost_ev; allocate.cost_es; allocate.cost_es2]];

% sum(x) - sum(allocate.cost);



%