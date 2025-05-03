%% Main execution script
if ~ exist('Signals')
    clc;clear;
    read_data;  % Read PJM historical frequency signal RegD data
end
if ~ exist('Distribution')
    handle_raw_data;  % Process data and calculate historical distribution
end

% Frequency regulation bidding
current_bid;

% Frequency market clearing
current_clear;

% Plot clearing results
plot_clear;


