function [time_M,F_star_M,P_star_M] = RunMosek(a,b,c,D,Pmin,Pmax)
% 本函数用于调用MOSEK求解器计算火电机组最优负荷分配精确解，输入机组耗量特性参数、出力上下限与系统总负荷，输出机组最优出力、目标函数最优值及算法求解时间
%% 基本参数与变量生成
ng = length(Pmin);
Q = diag(a); % 根据燃料消耗系数的二次项生成对角矩阵
%% 构造决策变量，即火电机组出力
P = sdpvar(ng,1);
e = ones(ng,1);
%% 构造约束
cons = [e'*P-D == 0]; % 功率平衡约束
cons = cons + [Pmin <= P <= Pmax]; % 机组出力上下界约束
%% 构造目标函数
obj = P'*Q*P + b'*P + c;
%% 调用求解器求解
ses = sdpsettings('solver','mosek','savesolveroutput',1,'verbose',3,'debug',1);
res = optimize(cons,obj,ses);
P_star_M = value(P); % 最优出力
F_star_M = P_star_M'*Q*P_star_M+b'*P_star_M+c; % 最优解下目标函数取值
time_M = res.solvertime; % 记录求解时间
end