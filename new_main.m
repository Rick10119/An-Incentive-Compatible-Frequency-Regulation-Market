
%% 所提机制
if ~ exist('Signals')
    % 策略性报价储能比例
    ratio = 0;
    read_data;
end
if ~ exist('Distribution')
    handle_raw_data;
end

% 投标信息

% 申报成本比例

new_bid;

R_c_result = [];
Price_cap = zeros(24, 1);


for hour = 1 : 24
    
    % 出清
    disp("hour: " + hour);
    new_clear;
    
    if sol.solveroutput.exitflag == 0
        disp("求解失败，hour = " + hour);
        break;
    end
    
    R_c_result = [R_c_result; value(R_c)];
    
end

R_c_result_new = R_c_result;


% 分配
% 小时序号
hour_idx = ceil((1:signal_length)' * 2 / 3600);

% 分配功率
allocate = struct;
allocate.rd = zeros(signal_length, NOFTYPES);
allocate.P_up = [];
allocate.P_dn = [];
allocate.lambda = [];

% 总功率调整变量
P_up =  sdpvar(1800, NOFTYPES + 2, 'full');
P_dn =  sdpvar(1800, NOFTYPES + 2, 'full');

% 逐小时计算
for hour = 1 : TIME
    
    new_allocate;
    
end

% 统计成本，出力情况
calculate_cost;

% 边际价格



