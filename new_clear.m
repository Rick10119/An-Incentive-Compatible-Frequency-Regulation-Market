%% 所提出清模型

%% 参数设定

% 时段数量，24小时，逐小时出清，不考虑时段耦合
TIME = 24;
NOFTYPES = 5;
NOFSCENARIO = length(Distribution);
d_scenario = [-1; (-1 + 0.5 * diff :diff: 1 - 0.5 * diff)'; 1];
% 调频容量需求，按照峰荷的 5% 设定。
R_c_demand = 1000 * 0.05 * ones(24, 1);
% 仅取21点
% R_c_demand = [zeros(20, 1); 0; 0; 0; 2000 * 0.05];


%% 变量
%中标容量，四种资源在每个时段
R_c = sdpvar(1, NOFTYPES,'full');
% 场景出力(储能有最后两段)
P_up = sdpvar(NOFSCENARIO, NOFTYPES + 2,'full');
P_dn = sdpvar(NOFSCENARIO, NOFTYPES + 2,'full');
% 辅助变量
Cost_perf = sdpvar(NOFSCENARIO, 1,'full');
Cost_cap = sdpvar(1, 1,'full');

%% 约束
Constraints = [];

% 功率响应-各场景平衡
Constraints = [Constraints, R_c_demand(hour) * d_scenario == ...
    P_up*ones(NOFTYPES + 2,1) - P_dn*ones(NOFTYPES + 2,1)];


% 单个资源的最大容量(分段)
Constraints = [Constraints,0<=P_up<= ...
    repmat(p_q_pair.quantity_up(hour,:), NOFSCENARIO, 1)];
Constraints = [Constraints,0<=P_dn<= ...
    repmat(p_q_pair.quantity_dn(hour,:), NOFSCENARIO, 1)];
% 单个资源最大容量（总）
Constraints = [Constraints,0<=R_c<= ...
    R_max(hour,:)];

% 容量定义（要求上下对称）
Constraints = [Constraints, repmat(R_c(1:3), NOFSCENARIO, 1) >= P_up(:, 1:3)];
Constraints = [Constraints, repmat(R_c(1:3), NOFSCENARIO, 1) >= P_dn(:, 1:3)];
Constraints = [Constraints, repmat(R_c(4), NOFSCENARIO, 1) >= P_up(:, 4:5) * ones(2, 1)];% 储能分段了，单独来算
Constraints = [Constraints, repmat(R_c(4), NOFSCENARIO, 1) >= P_dn(:, 4:5) * ones(2, 1)];
Constraints = [Constraints, repmat(R_c(5), NOFSCENARIO, 1) >= P_up(:, 6:7) * ones(2, 1)];% 策略性储能
Constraints = [Constraints, repmat(R_c(5), NOFSCENARIO, 1) >= P_dn(:, 6:7) * ones(2, 1)];


% 运行成本
Constraints = [Constraints,Cost_perf == ...
    P_up * p_q_pair.price_up(hour, :)' + ...
    P_dn * p_q_pair.price_dn(hour, :)'];

% 容量成本
Constraints = [Constraints,Cost_cap >= R_c * p_c.p_c(hour, :)'];


%% cost function, capacity + mileage
Z = Distribution' * Cost_perf + Cost_cap;
% Z = Cost_cap;


%% solve
ops = sdpsettings('debug',1,'solver','cplex','savesolveroutput',1,'savesolverinput',1);
sol = optimize(Constraints,Z,ops);

R_c_val = value(R_c);
%% 计算容量成本

% 取中标机组中，容量报价最大者为容量价格。


Price_cap = [Price_cap; max(p_c.p_c(hour, find(R_c_val > 1e-6)))];

if length(max(p_c.p_c(hour, find(R_c_val > 1e-6)))) < 1
    Price_cap = [Price_cap; 0];
end