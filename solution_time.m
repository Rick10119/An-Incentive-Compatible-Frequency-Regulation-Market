%% 计算求解100次的时间

%% 所提机制
yalmip("clear");

ratio = 0;
read_data;
 r = 1; r2 = 1;rate = 1;rate2 = 1;
total_table = [];
for diff = [0.2, 0.1, 0.05, 0.025, 0.01]
    handle_raw_data;
    
    new_bid;
    
    R_c_result = [];
    Price_cap = zeros(24, 1);
    hour = 1;
    new_clear;
    
    tic;
    for i_idx = 1 : 100
        sol = optimize(Constraints, Z, ops);
    end
    total_table = [total_table, toc];
    
end