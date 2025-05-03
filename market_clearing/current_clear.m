%% 现有调频市场出清模型

%% 参数设定

% 时段数量，24小时，逐小时出清，不考虑时段耦合
TIME = 24; 
% 资源种类（市场主体）梳理
NOFTYPES = 4;

% 调频容量需求，按照峰荷的 5% 设定，双向
R_c_demand = 1000 * 0.05 * ones(TIME, 1);
 
%% 变量
%中标容量，四种资源在每个时段
R_c = sdpvar(TIME, NOFTYPES, 'full'); 

%% 约束
Constraints = [];

% 满足调频容量总需求(该约束的影子价格为容量出清价格)
Constraints = [Constraints,R_c_demand==R_c*s_h'];
% 注：本例中各资源的调频里程成本为0，故没有考虑里程成本。

% 单个资源的最大容量
Constraints = [Constraints,R_c<=R_max(:, 1:4)];
Constraints = [Constraints,0<=R_c];


%% cost function, capacity + mileage
Z = sum(sum(R_c.*(p_c.p_c ./ s_h))) + sum (R_c * (p_m .* m_h)' );


%% solve
ops = sdpsettings('debug',1,'solver','cplex','savesolveroutput',1,'savesolverinput',1);
sol = optimize(Constraints, Z, ops);

%% 
% 记录容量价格和成本
R_c_clear = value(R_c);
% 容量价格为等式约束影子价格
Price_cap = sol.solveroutput.lambda.eqlin;

