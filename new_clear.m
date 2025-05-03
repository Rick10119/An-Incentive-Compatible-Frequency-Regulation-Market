%% Market Clearing Model

%% Parameter Settings

% Time parameters: 24 hours, with hourly resolution
TIME = 24;
NOFTYPES = 5;  % Number of resource types
NOFSCENARIO = length(Distribution);
% Scenario discretization for AGC signal
d_scenario = [-1; (-1 + 0.5 * diff :diff: 1 - 0.5 * diff)'; 1];
% AGC demand set to 5% of 1000MW for frequency regulation
R_c_demand = 1000 * 0.05 * ones(24, 1);
% Alternative test case with 21st hour demand
% R_c_demand = [zeros(20, 1); 0; 0; 0; 2000 * 0.05];

%% Decision Variables
% Resource capacity for each type at each time
R_c = sdpvar(1, NOFTYPES,'full');
% Power regulation variables (up/down regulation)
P_up = sdpvar(NOFSCENARIO, NOFTYPES + 2,'full');
P_dn = sdpvar(NOFSCENARIO, NOFTYPES + 2,'full');
% Cost variables
Cost_perf = sdpvar(NOFSCENARIO, 1,'full');  % Performance cost
Cost_cap = sdpvar(1, 1,'full');            % Capacity cost

%% Constraints
Constraints = [];

% Power balance constraint: Up/down regulation must match AGC signal
Constraints = [Constraints, R_c_demand(hour) * d_scenario == ...
    P_up*ones(NOFTYPES + 2,1) - P_dn*ones(NOFTYPES + 2,1)];

% Resource quantity constraints (hourly)
Constraints = [Constraints,0<=P_up<= ...
    repmat(p_q_pair.quantity_up(hour,:), NOFSCENARIO, 1)];
Constraints = [Constraints,0<=P_dn<= ...
    repmat(p_q_pair.quantity_dn(hour,:), NOFSCENARIO, 1)];
% Resource capacity constraints
Constraints = [Constraints,0<=R_c<= ...
    R_max(hour,:)];

% Resource allocation constraints (must be symmetric)
% For first three resource types (individual constraints)
Constraints = [Constraints, repmat(R_c(1:3), NOFSCENARIO, 1) >= P_up(:, 1:3)];
Constraints = [Constraints, repmat(R_c(1:3), NOFSCENARIO, 1) >= P_dn(:, 1:3)];
% For fourth resource type (aggregated constraint)
Constraints = [Constraints, repmat(R_c(4), NOFSCENARIO, 1) >= P_up(:, 4:5) * ones(2, 1)]; % Cannot be split, aggregated constraint
Constraints = [Constraints, repmat(R_c(4), NOFSCENARIO, 1) >= P_dn(:, 4:5) * ones(2, 1)];
% For fifth resource type (aggregated constraint)
Constraints = [Constraints, repmat(R_c(5), NOFSCENARIO, 1) >= P_up(:, 6:7) * ones(2, 1)]; % Renewable resources
Constraints = [Constraints, repmat(R_c(5), NOFSCENARIO, 1) >= P_dn(:, 6:7) * ones(2, 1)];

% Performance cost calculation
Constraints = [Constraints,Cost_perf == ...
    P_up * p_q_pair.price_up(hour, :)' + ...
    P_dn * p_q_pair.price_dn(hour, :)'];

% Capacity cost calculation
Constraints = [Constraints,Cost_cap >= R_c * p_c.p_c(hour, :)'];

%% Objective function: Minimize total cost (capacity + performance)
Z = Distribution' * Cost_perf + Cost_cap;
% Alternative objective: Minimize only capacity cost
% Z = Cost_cap;

%% Solve optimization problem
ops = sdpsettings('debug',1,'solver','gurobi');
sol = optimize(Constraints,Z,ops);

R_c_val = value(R_c);

%% Calculate clearing price
% Take the maximum price among resources with non-zero capacity as the clearing price
Price_cap = [Price_cap; max(p_c.p_c(hour, find(R_c_val > 1e-6)))];

% Handle case where no resources are selected
if length(max(p_c.p_c(hour, find(R_c_val > 1e-6)))) < 1
    Price_cap = [Price_cap; 0];
end