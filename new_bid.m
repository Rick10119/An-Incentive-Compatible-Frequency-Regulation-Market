%% Bidding and Cost Calculation

% Initialize parameters if they don't exist
if ~exist('r')
    r = 1;  % Default ratio for ES1
end

if ~exist('r2')
    r2 = 1;  % Default ratio for ES2
end

if ~exist('rate')
    rate = 1;  % Default rate
end

if ~exist('rate2')
    rate2 = 1;  % Default rate 2
end

%% Capacity Cost (per unit)
% Market price for renewable resources
Opp_price_vre = Price_wholesale;
p_c = struct;
% Wind and PV capacity costs
p_c.p_c_up_w = Opp_price_vre;
p_c.p_c_up_p = Opp_price_vre;
p_c.p_c_dn_w = 0* ones(24, 1);
p_c.p_c_dn_p = 0* ones(24, 1);

% EV and ES capacity costs (20 is the base cost, may need to add opportunity cost)
% ES has different costs for charging/discharging periods
p_c.p_c_up_ev = 23 * ones(24, 1);
p_c.p_c_dn_ev = p_c.p_c_up_ev;
p_c.p_c_up_es = 20 * ones(24, 1) + Opp_price_es(1:24);
p_c.p_c_dn_es = 20 * ones(24, 1) + Opp_price_es(25:48);

% Second ES with different ratio
p_c.p_c_up_es2 = r2 * 20 * ones(24, 1) + Opp_price_es(1:24);
p_c.p_c_dn_es2 = r2 * 20 * ones(24, 1) + Opp_price_es(25:48);

% Combine all capacity costs
p_c.p_c_up = [p_c.p_c_up_w, p_c.p_c_up_p, p_c.p_c_up_ev, p_c.p_c_up_es, p_c.p_c_up_es2];
p_c.p_c_dn = [p_c.p_c_dn_w, p_c.p_c_dn_p, p_c.p_c_dn_ev, p_c.p_c_dn_es, p_c.p_c_dn_es2];

%% Performance cost and quantity pairs
p_q_pair = struct;

% Wind and PV bidding
p_q_pair.price_up_w = - Opp_price_vre;
p_q_pair.quantity_up_w = R_w_max;
p_q_pair.price_up_p = - Opp_price_vre;
p_q_pair.quantity_up_p = R_p_max;
p_q_pair.price_dn_w = Opp_price_vre;
p_q_pair.quantity_dn_w = R_w_max;
p_q_pair.price_dn_p = Opp_price_vre;
p_q_pair.quantity_dn_p = R_p_max;

% EV bidding
p_q_pair.price_dn_ev = zeros(24, 1);
p_q_pair.quantity_dn_ev = R_ev_max;
p_q_pair.price_up_ev = zeros(24, 1);
p_q_pair.quantity_up_ev = R_ev_max;

% ES bidding (initialization)
p_q_pair.price_dn_es = zeros(24, 2);
p_q_pair.quantity_dn_es = zeros(24, 2);
p_q_pair.price_up_es = zeros(24, 2);
p_q_pair.quantity_up_es = zeros(24, 2);
p_q_pair.price_dn_es2 = zeros(24, 2);
p_q_pair.quantity_dn_es2 = zeros(24, 2);
p_q_pair.price_up_es2 = zeros(24, 2);
p_q_pair.quantity_up_es2 = zeros(24, 2);

% Calculate ES bidding prices and quantities considering opportunity costs
for t = 1:24
    if P_es(t) < 0 % Charging mode
        % ES1 charging
        p_q_pair.price_dn_es(t, 1) = 5 - Opp_price_es(t);
        p_q_pair.quantity_dn_es(t, 1) = R_es_max(t);
        
        p_q_pair.price_up_es(t, 1) = - 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es(t, 1) = abs(P_es(t));
        
        p_q_pair.price_up_es(t, 2) = 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));
        
        % ES2 charging (with different ratio)
        p_q_pair.price_dn_es2(t, 1) = r * 5 - Opp_price_es(t);
        p_q_pair.quantity_dn_es2(t, 1) = R_es_max(t);
        
        p_q_pair.price_up_es2(t, 1) = - r * 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es2(t, 1) = abs(P_es(t));
        
        p_q_pair.price_up_es2(t, 2) = r * 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es2(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));
    else % Discharging mode
        % ES1 discharging
        p_q_pair.price_dn_es(t, 1) = - 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es(t, 1) = abs(P_es(t));
        
        p_q_pair.price_dn_es(t, 2) = 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));

        p_q_pair.price_up_es(t, 1) = 5 - Opp_price_es(t + 24);
        p_q_pair.quantity_up_es(t, 1) = R_es_max(t);
        
        % ES2 discharging (with different ratio)
        p_q_pair.price_dn_es2(t, 1) = - r * 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es(t, 1) = abs(P_es(t));
        
        p_q_pair.price_dn_es2(t, 2) = r * 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es2(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));

        p_q_pair.price_up_es2(t, 1) = r * 5 - Opp_price_es(t + 24);
        p_q_pair.quantity_up_es2(t, 1) = R_es_max(t);
    end
end

% Combine all price and quantity pairs
p_q_pair.price_up = [p_q_pair.price_up_w,p_q_pair.price_up_p,...
    p_q_pair.price_up_ev,p_q_pair.price_up_es,p_q_pair.price_up_es2];

p_q_pair.price_dn = [p_q_pair.price_dn_w,p_q_pair.price_dn_p,...
    p_q_pair.price_dn_ev,p_q_pair.price_dn_es,p_q_pair.price_dn_es2];

p_q_pair.quantity_up = [p_q_pair.quantity_up_w,p_q_pair.quantity_up_p,...
    p_q_pair.quantity_up_ev,p_q_pair.quantity_up_es,p_q_pair.quantity_up_es2];

p_q_pair.quantity_dn = [p_q_pair.quantity_dn_w,p_q_pair.quantity_dn_p,...
    p_q_pair.quantity_dn_ev,p_q_pair.quantity_dn_es,p_q_pair.quantity_dn_es2];

% Historical frequency regulation coefficients
% m_h = [4, 4, 5, 5];
m_h = 5 * ones(1, 5);

% Performance indicators
% s_h = [3.5, 3.5, 6, 6] / 3.5;
s_h = ones(1, 5);

%% Calculate total price
% plot(p_c_dn)
p_c.p_c = (p_c.p_c_up + p_c.p_c_dn);


