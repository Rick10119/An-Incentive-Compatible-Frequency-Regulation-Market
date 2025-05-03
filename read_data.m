%% Read market price data from Excel file
filename = 'marketData/05 2020.xlsx';
sheet = 'Dynamic';  % Sheet name
xlRange = 'B2:AF43202';  % Data range
% Read May signal data, 2-second resolution * 31 days
Signals = xlsread(filename, sheet, xlRange);

% Data cleaning: Remove values outside [-1, 1] range
Signals(find(Signals < -1)) = -1;
Signals(find(Signals > 1)) = 1;

%% Read market clearing data and resource bidding information
Cap_s = 40;  % Storage capacity
load("marketData/clear_energy_" + Cap_s + ".mat");

% Calculate maximum frequency regulation capacity for each resource
% Wind and PV: Maximum 30% of installed capacity
R_w_max = min(0.3 * max(P_w), 0.5 * P_w ) / 2;  % Wind power
R_p_max = min(0.3 * max(P_p), 0.5 * P_p ) / 2;  % Photovoltaic
R_ev_max = min(P_ev, 2 * max(P_ev) - P_ev);     % Electric vehicles

% Energy storage systems
ratio = 0;  % Split ratio between two storage systems
R_es_max = (1 - ratio) * min(Cap_s - P_es, Cap_s + P_es);   % First storage system
R_es_max2 = ratio * min(Cap_s - P_es, Cap_s + P_es);        % Second storage system

% Combine all resource capacities
R_max = [R_w_max, R_p_max, R_ev_max, R_es_max, R_es_max2];


