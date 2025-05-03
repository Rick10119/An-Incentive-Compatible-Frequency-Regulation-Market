%% 从excel读取信号数据
filename = 'marketData/05 2020.xlsx';
sheet = 'Dynamic'; % 所在表单
xlRange = 'B2:AF43202'; % 范围
% 读取5月份所有信号数据，2s一个点 * 31d
Signals = xlsread(filename, sheet, xlRange);

% data clearing, 排除超出【-1， 1】的数据
Signals(find(Signals < -1)) = -1;
Signals(find(Signals > 1)) = 1;


%% 根据能量市场出清结果计算各资源申报的最大调频容量
Cap_s = 40;
load("marketData/clear_energy_" + Cap_s + ".mat");

% 各资源能提供的最大调频容量
% 光伏、风电为30%出力
R_w_max = min(0.3 * max(P_w), 0.5 * P_w ) / 2;
R_p_max = min(0.3 * max(P_p), 0.5 * P_p ) / 2;
R_ev_max = min(P_ev, 2 * max(P_ev) - P_ev);

ratio = 0;
R_es_max = (1 - ratio) * min(Cap_s - P_es, Cap_s + P_es);
R_es_max2 = ratio * min(Cap_s - P_es, Cap_s + P_es);

% 整合为矩阵
R_max = [R_w_max, R_p_max, R_ev_max, R_es_max, R_es_max2];


