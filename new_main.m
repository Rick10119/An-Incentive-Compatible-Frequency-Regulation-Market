%% Main script for resource allocation and market clearing
if ~ exist('Signals')
    % Initialize ratio and read data if Signals don't exist
    ratio = 0;
    read_data;
end
if ~ exist('Distribution')
    % Process raw data if Distribution doesn't exist
    handle_raw_data;
end

% Market information

% Bidding cost calculation
new_bid;

% Initialize result arrays
R_c_result = [];
Price_cap = zeros(24, 1);

% Main loop for each hour
for hour = 1 : 24
    
    % Market clearing
    disp("hour: " + hour);
    new_clear;
    
    if sol.problem ~= 0
        disp("Clearing failed, hour = " + hour);
        break;
    end
    
    R_c_result = [R_c_result; value(R_c)];
    
end

R_c_result_new = R_c_result;

% Resource allocation
% Convert time to hourly indices
hour_idx = ceil((1:signal_length)' * 2 / 3600);

% Initialize allocation structure
allocate = struct;
allocate.rd = zeros(signal_length, NOFTYPES);
allocate.P_up = [];
allocate.P_dn = [];
allocate.lambda = [];

% Total power allocation variables
P_up =  sdpvar(1800, NOFTYPES + 2, 'full');
P_dn =  sdpvar(1800, NOFTYPES + 2, 'full');

% Hourly allocation loop
for hour = 1 : TIME
    new_allocate;
end

% Calculate costs and statistics
calculate_cost;

% Plot clearing results
plot_clear;



