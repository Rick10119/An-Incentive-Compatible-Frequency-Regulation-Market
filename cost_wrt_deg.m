
close;

M = 1e3;% 大数
diff = 0.1;

Profit_comp = [];
Cost_comp = [];
Bid_P_comp = [];
Bid_R_comp = [];

NOFTCAP = 900;

cd ../data_prepare
data_prepare;
cd ../my_alloc_intervals

% 所提机制
for rate = [0.25, 2, 4, 2]%跳过1的
    param.Pr_deg = param.Pr_deg * rate;
    main;
    Profit_comp = [Profit_comp, actualProfit];
    Cost_comp = [Cost_comp, actualCost];
    Bid_P_comp = [Bid_P_comp, Bid_P_rev];
    Bid_R_comp = [Bid_R_comp, Bid_R_rev];
end

cd ../data_prepare
data_prepare;
cd ../my_alloc_intervals

% 利润
revenue = Profit_comp - Cost_comp;
total_revenue = sum(revenue);
total_profit = sum(Profit_comp);
total_cost = sum(Cost_comp);
total_table = [total_profit; total_cost; total_revenue]';

save("../results/result_deg.mat", "total_table");

