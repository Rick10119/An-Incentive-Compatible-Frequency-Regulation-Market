
if ~exist('r')
    r = 1;
end

if ~exist('r2')
    r2 = 1;
end

if ~exist('rate')
    rate = 1;
end

if ~exist('rate2')
    rate2 = 1;
end

%% (单位)容量成本
% 新能源就是能量市场价格，
Opp_price_vre = Price_wholesale;
p_c = struct;
p_c.p_c_up_w = Opp_price_vre;
p_c.p_c_up_p = Opp_price_vre;
p_c.p_c_dn_w = 0* ones(24, 1);
p_c.p_c_dn_p = 0* ones(24, 1);
% 储能和EV是20，储能还要加上机会成本。es是两段，相同
p_c.p_c_up_ev = 23 * ones(24, 1);
p_c.p_c_dn_ev = p_c.p_c_up_ev;
p_c.p_c_up_es = 20 * ones(24, 1) + Opp_price_es(1:24);
p_c.p_c_dn_es = 20 * ones(24, 1) + Opp_price_es(25:48);
p_c.p_c_up_es = 20 * ones(24, 1) + Opp_price_es(1:24);
p_c.p_c_dn_es = 20 * ones(24, 1) + Opp_price_es(25:48);


p_c.p_c_up_es2 = r2 * 20 * ones(24, 1) + Opp_price_es(1:24);
p_c.p_c_dn_es2 = r2 * 20 * ones(24, 1) + Opp_price_es(25:48);
p_c.p_c_up_es2 = r2 * 20 * ones(24, 1) + Opp_price_es(1:24);
p_c.p_c_dn_es2 = r2 * 20 * ones(24, 1) + Opp_price_es(25:48);

p_c.p_c_up = [p_c.p_c_up_w, p_c.p_c_up_p, p_c.p_c_up_ev, p_c.p_c_up_es, p_c.p_c_up_es2];
p_c.p_c_dn = [p_c.p_c_dn_w, p_c.p_c_dn_p, p_c.p_c_dn_ev, p_c.p_c_dn_es, p_c.p_c_dn_es2];

%% 调整成本，量价对。
p_q_pair = struct;
% ver
p_q_pair.price_up_w = - Opp_price_vre;
p_q_pair.quantity_up_w = R_w_max;
p_q_pair.price_up_p = - Opp_price_vre;
p_q_pair.quantity_up_p = R_p_max;
p_q_pair.price_dn_w = Opp_price_vre;
p_q_pair.quantity_dn_w = R_w_max;
p_q_pair.price_dn_p = Opp_price_vre;
p_q_pair.quantity_dn_p = R_p_max;

% ev
p_q_pair.price_dn_ev = zeros(24, 1);
p_q_pair.quantity_dn_ev = R_ev_max;
p_q_pair.price_up_ev = zeros(24, 1);
p_q_pair.quantity_up_ev = R_ev_max;

% es, 报两段
p_q_pair.price_dn_es = zeros(24, 2);
p_q_pair.quantity_dn_es = zeros(24, 2);
p_q_pair.price_up_es = zeros(24, 2);
p_q_pair.quantity_up_es = zeros(24, 2);
p_q_pair.price_dn_es2 = zeros(24, 2);
p_q_pair.quantity_dn_es2 = zeros(24, 2);
p_q_pair.price_up_es2 = zeros(24, 2);
p_q_pair.quantity_up_es2 = zeros(24, 2);

% 考虑储能运行的边际成本
for t = 1:24
    if P_es(t) < 0 % 充电C
        p_q_pair.price_dn_es(t, 1) = 5 - Opp_price_es(t);
        p_q_pair.quantity_dn_es(t, 1) = R_es_max(t);
        
        p_q_pair.price_up_es(t, 1) = - 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es(t, 1) = abs(P_es(t));
        
        p_q_pair.price_up_es(t, 2) = 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));
        
        %
        p_q_pair.price_dn_es2(t, 1) = r * 5 - Opp_price_es(t);
        p_q_pair.quantity_dn_es2(t, 1) = R_es_max(t);
        
        p_q_pair.price_up_es2(t, 1) = - r * 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es2(t, 1) = abs(P_es(t));
        
        p_q_pair.price_up_es2(t, 2) = r * 5 + Opp_price_es(t);
        p_q_pair.quantity_up_es2(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));
    else % 放电 D
        p_q_pair.price_dn_es(t, 1) = - 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es(t, 1) = abs(P_es(t));
        
        p_q_pair.price_dn_es(t, 2) = 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));

        p_q_pair.price_up_es(t, 1) = 5 - Opp_price_es(t + 24);
        p_q_pair.quantity_up_es(t, 1) = R_es_max(t);
        
        %
        p_q_pair.price_dn_es2(t, 1) = - r * 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es(t, 1) = abs(P_es(t));
        
        p_q_pair.price_dn_es2(t, 2) = r * 5 + Opp_price_es(t + 24);
        p_q_pair.quantity_dn_es2(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));

        p_q_pair.price_up_es2(t, 1) = r * 5 - Opp_price_es(t + 24);
        p_q_pair.quantity_up_es2(t, 1) = R_es_max(t);

    end
%      if P_es(t) < 0 % 充电C
%         p_q_pair.price_dn_es(t, 1) = 5;
%         p_q_pair.quantity_dn_es(t, 1) = R_es_max(t);
%         
%         p_q_pair.price_up_es(t, 1) = - 5;
%         p_q_pair.quantity_up_es(t, 1) = abs(P_es(t));
%         
%         p_q_pair.price_up_es(t, 2) = 5;
%         p_q_pair.quantity_up_es(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));
%     else % 放电 D
%         p_q_pair.price_dn_es(t, 1) = - 5;
%         p_q_pair.quantity_dn_es(t, 1) = abs(P_es(t));
%         
%         p_q_pair.price_dn_es(t, 2) = 5;
%         p_q_pair.quantity_dn_es(t, 2) = max(0, R_es_max(t) - abs(P_es(t)));
% 
%         p_q_pair.price_up_es(t, 1) = 5;
%         p_q_pair.quantity_up_es(t, 1) = R_es_max(t);
% 
%     end
end
% 整合
p_q_pair.price_up = [p_q_pair.price_up_w,p_q_pair.price_up_p,...
    p_q_pair.price_up_ev,p_q_pair.price_up_es,p_q_pair.price_up_es2];

p_q_pair.price_dn = [p_q_pair.price_dn_w,p_q_pair.price_dn_p,...
    p_q_pair.price_dn_ev,p_q_pair.price_dn_es,p_q_pair.price_dn_es2];

p_q_pair.quantity_up = [p_q_pair.quantity_up_w,p_q_pair.quantity_up_p,...
    p_q_pair.quantity_up_ev,p_q_pair.quantity_up_es,p_q_pair.quantity_up_es2];

p_q_pair.quantity_dn = [p_q_pair.quantity_dn_w,p_q_pair.quantity_dn_p,...
    p_q_pair.quantity_dn_ev,p_q_pair.quantity_dn_es,p_q_pair.quantity_dn_es2];

% 历史调频里程调用系数
% m_h = [4, 4, 5, 5];
m_h = 5 * ones(1, 5);

% 性能指标
% s_h = [3.5, 3.5, 6, 6] / 3.5;
s_h = ones(1, 5);

%% 调整后价格
% plot(p_c_dn)
p_c.p_c = (p_c.p_c_up + p_c.p_c_dn);


