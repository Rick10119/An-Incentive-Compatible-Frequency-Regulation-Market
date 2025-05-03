%% Calculate costs

% Initialize cost arrays for hourly analysis
allocate.cost = zeros(TIME, 1);          % Total cost
allocate.cost_deg = zeros(TIME, 1);      % Degradation cost
allocate.cost_deg2 = zeros(TIME, 1);     % Secondary degradation cost
allocate.cost_rp = zeros(TIME, NOFTYPES + 1);  % Resource-specific costs

% Adjust ratios and update bidding
r = r/rate;
r2 = r2/rate2;
new_bid;

% Calculate costs for each time step (2-second resolution)
for t_cap = 1 : signal_length
    % Calculate time-step costs (2-second signal)
    % Sum up costs for each resource in each time period
    allocate.cost_rp(hour_idx(t_cap), :) = allocate.cost_rp(hour_idx(t_cap), :) + ...
        allocate.P_up(t_cap, :) .* p_q_pair.price_up(hour_idx(t_cap), 1:5) * 2/3600 + ...
        allocate.P_dn(t_cap, :) .* p_q_pair.price_dn(hour_idx(t_cap), 1:5) * 2/3600;
    
    % Calculate degradation cost for storage systems
    allocate.cost_deg(hour_idx(t_cap), :) = allocate.cost_deg(hour_idx(t_cap), :) + ...
        5 * abs((allocate.P_up(t_cap, 4:5) - allocate.P_dn(t_cap, 4:5)) * ones(2, 1) + ...
        (1 - ratio) * P_es(hour_idx(t_cap))) * 2/3600;
end

% Combine resource costs and adjust for resource types
allocate.cost_rp(:, 1) = allocate.cost_rp(:, 1) + allocate.cost_rp(:, 2);  % Combine wind and PV
allocate.cost_rp(:, 4) = allocate.cost_rp(:, 4) + allocate.cost_rp(:, 5);  % Combine storage systems
allocate.cost_rp = [allocate.cost_rp(:, 1), allocate.cost_rp(:, 3:4)];     % Final resource grouping

% Calculate total market cost (hourly)
allocate.cost = allocate.cost_rp * ones(3, 1);

% Add capacity costs
allocate.cost = allocate.cost + (p_c.p_c(:, 1:4) .* R_c_result) * ones(4, 1);

% Calculate renewable energy cost (wind + PV)
allocate.cost_vre = allocate.cost_rp(:, 1) + (p_c.p_c(:, 1:4) .* R_c_result) * [1, 1, 0, 0]';

% Calculate average cost per unit
% allocate.abd_vre = allocate.cost_vre ./ Price_wholesale;
% Store absolute cost
allocate.abd_vre = allocate.cost_vre;
% Calculate average cost ratio
sum(allocate.cost_vre ./ Price_wholesale) / sum(R_c_result * [1, 1, 0, 0]');

%% Cost Analysis

% Calculate capacity costs
allocate.cap_cost = p_c.p_c(:, 1:4) .* R_c_result;

% Calculate total costs by resource type
allocate.cost_wp = sum(allocate.cost_rp(:, 1) + allocate.cap_cost(:, 1:2) * ones(2, 1));  % Wind and PV
allocate.cost_ev = sum(allocate.cost_rp(:, 2) + allocate.cap_cost(:, 3));                 % Electric vehicles
allocate.cost_es = sum(allocate.cost_rp(:, 3) + allocate.cap_cost(:, 4));                 % Energy storage

% Optional cost verification
% x = [x, [allocate.cost_wp; allocate.cost_ev; allocate.cost_es; allocate.cost_es2]];
% sum(x) - sum(allocate.cost);



%