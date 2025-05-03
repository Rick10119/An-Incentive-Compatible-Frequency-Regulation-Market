
%% (单位)容量成本的投标
% 新能源就是机会成本，能量市场价格的一半（在中间运行）
p_c = struct;% 新建结构体
p_c.p_c_w = Price_wholesale;
p_c.p_c_p = Price_wholesale;
% 储能和EV是20，储能还要加上机会成本
p_c.p_c_ev = 23 * ones(24, 1);
p_c.p_c_es = 20 * ones(24, 1) + Opp_price_es(1:24) + Opp_price_es(25:48);
p_c.p_c = [p_c.p_c_w, p_c.p_c_p, p_c.p_c_ev, p_c.p_c_es];

% 里程成本
p_m = 1 * ones (1, 4);

% 历史调频里程调用系数
% m_h = [4, 4, 5, 5];
m_h = 5 * ones(1, 4);

% 性能指标
% s_h = [3.5, 3.5, 6, 6] / 3.5;
s_h = ones(1, 4);




