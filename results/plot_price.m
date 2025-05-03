
close;

%% 所提机制
x = [];
rate2  = 1.1;
for rate = 0.9: 0.1 : 1.1
    r = rate * 4.5 / 5; % 边际成本比例
%     rate2 = rate;
    r2 = rate2 * 1;
    
    
    new_main;
    
    % 容量补偿费用
    cap = [R_c_result(:, 1:2) * ones(2, 1), R_c_result(:, 3:5)];
    allocate.income_cap = ones(1, 24) * (cap .* Price_cap(25:48));
    
    % 运行补偿
    allocate.income_perf = 2/3600 * [allocate.lambda' * (allocate.P_up - allocate.P_dn) * [1, 1, 0, 0, 0, 0, 0]' , ...
        allocate.lambda' * (allocate.P_up - allocate.P_dn) * [0, 0, 1, 0, 0, 0, 0]', ...
        allocate.lambda' * (allocate.P_up - allocate.P_dn) * [0, 0, 0, 1, 1, 0, 0]', ...
        allocate.lambda' * (allocate.P_up - allocate.P_dn) * [0, 0, 0, 0, 0, 1, 1]'];
    
    x = [x, allocate.income_cap' + allocate.income_perf'];
    % x = [x, x * ones(2, 1)];
end
 
y = reshape(x(4, :), 2, 3);
y = [y; [-1, 1] * y];
