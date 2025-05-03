%% 新型机制下，最优分配。

% 已经给出了出清结果。给定signal
R_c_result = R_c_result_new;

%约束
Constraints = [];
Z = 0;

% 达到AGC需求
Constraints = [Constraints, 0.999999 * R_c_demand(hour) * signals((hour-1) * 1800 + 1 : hour * 1800) == (P_up - P_dn) * ones(7, 1)];
% 这里用0.5 - 1e-6，是为了避免乘子无效的情况

% 容量约束（逐小时）

% 量价段长度约束
Constraints = [Constraints, 0 <= P_up ...
    <= repmat(p_q_pair.quantity_up(hour, :), 1800, 1)];

Constraints = [Constraints, 0 <= P_dn ...
    <= repmat(p_q_pair.quantity_dn(hour, :), 1800, 1)];


% 中标容量约束
Constraints = [Constraints, repmat(R_c_result(hour, 1:3), 1800, 1) >= ...
    P_up(:, 1:3)];

Constraints = [Constraints, repmat(R_c_result(hour, 1:3), 1800, 1) >= ...
    P_dn(:, 1:3)];

Constraints = [Constraints, repmat(R_c_result(hour, 4), 1800, 1) >= ...
    P_up(:, 4:5) * ones(2, 1)];% 储能分段了，单独来算

Constraints = [Constraints, repmat(R_c_result(hour, 4), 1800, 1) >= ...
    P_dn(:, 4:5) * ones(2, 1)];% 储能分段了，单独来算

Constraints = [Constraints, repmat(R_c_result(hour, 5), 1800, 1) >= ...
    P_up(:, 6:7) * ones(2, 1)];% 策略性储能

Constraints = [Constraints, repmat(R_c_result(hour, 5), 1800, 1) >= ...
    P_dn(:, 6:7) * ones(2, 1)];% 策略性储能

% 目标函数
Z = sum(P_up * p_q_pair.price_up(hour, :)' + ...
    P_dn * p_q_pair.price_dn(hour, :)');



% solve
disp("hour: " + hour);
ops = sdpsettings('debug',1,'solver','cplex','savesolveroutput',1,'savesolverinput',1);
sol = optimize(Constraints,Z,ops);


% 记录
allocate.P_up = [allocate.P_up; value(P_up)];
allocate.P_dn = [allocate.P_dn; value(P_dn)];
allocate.lambda = [allocate.lambda; sol.solveroutput.lambda.eqlin];

