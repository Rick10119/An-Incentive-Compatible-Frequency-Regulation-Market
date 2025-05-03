%% Capacity cost and bidding (per unit)
% Resource costs are based on opportunity costs and market prices
p_c = struct;  % Create new structure
% Wind and PV costs are half of wholesale market price (for intermediate settlement)
p_c.p_c_w = Price_wholesale;
p_c.p_c_p = Price_wholesale;

% EV and ES costs: 20 is base cost, may need to add opportunity cost
p_c.p_c_ev = 23 * ones(24, 1);  % EV cost
p_c.p_c_es = 20 * ones(24, 1) + Opp_price_es(1:24) + Opp_price_es(25:48);  % ES cost
p_c.p_c = [p_c.p_c_w, p_c.p_c_p, p_c.p_c_ev, p_c.p_c_es];

% Mileage cost
p_m = 1 * ones (1, 4);  % Mileage cost for each resource type

% Historical frequency regulation coefficients
% m_h = [4, 4, 5, 5];
m_h = 5 * ones(1, 4);  % Default coefficient for all resources

% Performance indicators
% s_h = [3.5, 3.5, 6, 6] / 3.5;
s_h = ones(1, 4);  % Default performance indicator for all resources




