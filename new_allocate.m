%% Resource allocation optimization under market clearing results

% Use the market clearing results from the previous step
R_c_result = R_c_result_new;

% Initialize optimization constraints and objective
Constraints = [];
Z = 0;

% AGC demand constraint
% Ensure the sum of up/down regulation meets the AGC signal requirements
% Using 0.999999 instead of 1 to avoid numerical issues
Constraints = [Constraints, 0.999999 * R_c_demand(hour) * signals((hour-1) * 1800 + 1 : hour * 1800) == (P_up - P_dn) * ones(7, 1)];

% Quantity constraints for each hour
% Upper and lower bounds for power regulation quantities
Constraints = [Constraints, 0 <= P_up ...
    <= repmat(p_q_pair.quantity_up(hour, :), 1800, 1)];

Constraints = [Constraints, 0 <= P_dn ...
    <= repmat(p_q_pair.quantity_dn(hour, :), 1800, 1)];

% Resource capacity constraints
% Ensure allocated power doesn't exceed resource capacities
% For first three resource types (individual constraints)
Constraints = [Constraints, repmat(R_c_result(hour, 1:3), 1800, 1) >= ...
    P_up(:, 1:3)];

Constraints = [Constraints, repmat(R_c_result(hour, 1:3), 1800, 1) >= ...
    P_dn(:, 1:3)];

% For fourth resource type (aggregated constraint)
Constraints = [Constraints, repmat(R_c_result(hour, 4), 1800, 1) >= ...
    P_up(:, 4:5) * ones(2, 1)]; % Cannot be split, aggregated constraint

Constraints = [Constraints, repmat(R_c_result(hour, 4), 1800, 1) >= ...
    P_dn(:, 4:5) * ones(2, 1)]; % Cannot be split, aggregated constraint

% For fifth resource type (aggregated constraint)
Constraints = [Constraints, repmat(R_c_result(hour, 5), 1800, 1) >= ...
    P_up(:, 6:7) * ones(2, 1)]; % Renewable resources

Constraints = [Constraints, repmat(R_c_result(hour, 5), 1800, 1) >= ...
    P_dn(:, 6:7) * ones(2, 1)]; % Renewable resources

% Objective function: Minimize total cost
% Sum of up-regulation and down-regulation costs
Z = sum(P_up * p_q_pair.price_up(hour, :)' + ...
    P_dn * p_q_pair.price_dn(hour, :)');

% Solve the optimization problem
disp("hour: " + hour);
ops = sdpsettings('debug',1,'solver','gurobi','savesolveroutput',1,'savesolverinput',1);
sol = optimize(Constraints,Z,ops);

% Record results
allocate.P_up = [allocate.P_up; value(P_up)];
allocate.P_dn = [allocate.P_dn; value(P_dn)];
pi = - sol.solveroutput.result.pi; % Negative for Gurobi

% Get dual variables from Gurobi
% Gurobi stores dual variables in the 'pi' field of the solution
if sol.problem == 0
    allocate.lambda = [allocate.lambda; pi];
else
    allocate.lambda = [allocate.lambda; zeros(size(pi))];
    warning('Optimization failed, using zero dual variables');
end

