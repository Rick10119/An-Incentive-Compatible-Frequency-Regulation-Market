%% 现有机制
if ~ exist('Signals')
    clc;clear;
    read_data;% 读取PJM历史调频信号RegD数据
end
if ~ exist('Distribution')
    handle_raw_data;% 处理数据，统计历史分布
end

% 构造调频投标
current_bid;

% 调频市场出清
current_clear;

% 画出中标结果
plot_clear;

