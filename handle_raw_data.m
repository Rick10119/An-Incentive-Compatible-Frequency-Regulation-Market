%% Process raw signal data
%% Calculate distribution for RegD signals with 0.1 resolution
%% 1: Normal RegD signal distribution, 2: 5-day and 20-day RegD signal distribution

% Initialize parameters
diff = 0.1;  % Resolution for discretization

% Initialize distribution array for values between -1 and 1
Distribution = zeros(2 / diff + 2, 1);
day = 20;  % 5-day and 20-day analysis
signal_length = 43202 - 2;  % Remove header and footer (24*1800)

Distributions = [];  % Store distributions for multiple days

% Process data for previous 7 days
for day_idx = day - 7 : day - 1
    signals = Signals(1 : end - 1, day_idx);  % Get signals
    
    % Calculate PDF by scanning through signals
    for t_cap = 1 : signal_length
        if signals(t_cap) >= 0  % Up frequency
            s_idx = ceil(signals(t_cap) / diff) + 1 / diff + 1;  % Calculate index
            if signals(t_cap) > 0.9999  % Handle values greater than 1
                s_idx = length(Distribution);
            end
        else  % Down frequency
            s_idx = floor(signals(t_cap) / diff) + 1 / diff + 2;  % Calculate index
            if signals(t_cap) < - 0.9999  % Handle values less than -1
                s_idx = 1;
            end
        end
        Distribution(s_idx) = Distribution(s_idx) + 1;
    end

    % Normalize to get frequency
    Distribution = Distribution / sum(Distribution);

    Distributions = [Distributions, Distribution];

    % Optional plotting
    % plot(Distribution);hold on;
    % plot(test);
end

% Calculate average distribution over 7 days
Distribution = Distributions * 1/7 * ones(7, 1);

%% Calculate historical mileage

Mileage = [];
for day_idx = 1:31
    % Get signals for one day
    signals = Signals(1 : end - 1, day_idx);
    
    % Calculate total mileage (sum of absolute differences)
    mileage = sum(abs(signals(2 : end) - signals(1 : end - 1)));

    Mileage = [Mileage; mileage];
end

% Normalize mileage to hourly average and two directions
Mileage = Mileage/ 24 / 2;