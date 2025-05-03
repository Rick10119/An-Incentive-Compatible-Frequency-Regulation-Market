%% Frequency regulation market clearing model

%% Parameter Settings

% Time parameters: 24 hours with hourly resolution
TIME = 24; 
% Number of resource types (market participants)
NOFTYPES = 4;

% Frequency regulation demand, set to 5% of 1000MW (bidirectional)
R_c_demand = 1000 * 0.05 * ones(TIME, 1);
 
%% Decision Variables
% Resource capacity for each type at each time
R_c = sdpvar(TIME, NOFTYPES, 'full'); 

%% Constraints
Constraints = [];

% Frequency regulation demand balance constraint
% (Shadow price of this constraint will be the clearing price)
Constraints = [Constraints, R_c_demand == R_c * s_h'];
% Note: If frequency regulation cost is 0, mileage cost is not considered

% Resource capacity constraints
Constraints = [Constraints, R_c <= R_max(:, 1:4)];  % Upper bound
Constraints = [Constraints, 0 <= R_c];              % Lower bound (non-negativity)

%% Objective function: Minimize total cost (capacity + mileage)
% Capacity cost adjusted by performance indicators plus mileage cost
Z = sum(sum(R_c .* (p_c.p_c ./ s_h))) + sum(R_c * (p_m .* m_h)');

%% Solve optimization problem
ops = sdpsettings('debug', 1, 'solver', 'gurobi', 'savesolveroutput', 1, 'savesolverinput', 1);
sol = optimize(Constraints, Z, ops);

%% Record results
% Store cleared capacities
R_c_clear = value(R_c);
% Clearing price is the shadow price of the demand balance constraint
Price_cap = - sol.solveroutput.result.pi;

