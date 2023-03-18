function [time_A,F_star_A,P_star_A] = RunAnalyticalAlgorithm(a,b,c,D,Pmin,Pmax)
% 本函数用于实现解析法，输入机组耗量特性参数、出力上下限与系统总负荷，输出机组最优出力、目标函数最优值及算法求解时间
%% 基本参数与变量生成
ng = length(Pmin);
Q = diag(a); % 根据燃料消耗系数的二次项生成对角矩阵
omega_lambda1 = ones(2*ng,1); % 机组微增率上下限构成的集合
for i = 1:ng
    omega_lambda1(2*i-1)=2*a(i)*Pmin(i)+b(i);
    omega_lambda1(2*i)=2*a(i)*Pmax(i)+b(i);
end
omega_lambda = sort(omega_lambda1); % 将机组微增率上下限从小至大排序

% 定义待求量
omega_D = zeros(2*ng,1); % 负荷总量的分段区间临界值，共分成2*ng-1段
F_para_A = zeros(3,2*ng-1); % 耗量最优值关于负荷总量的二次项系数、一次项系数与常数项
flag_A = zeros(ng,2*ng-1); % 用于存储机组i在每个负荷总量分段中，最优出力的情况。其中，1对应出力位于下界，2对应出力位于上下界间，3对应出力位于上界。
Alpha_A = zeros(2*ng-1,1); % 机组最优出力关于负荷总量的参数，对应论文式(26)中的alpha
Beta_A = zeros(2*ng-1,1); % 机组最优出力关于负荷总量的参数，对应论文式(26)中的beta
P_star_A = zeros(ng,1); % 解析法求得的最优出力

%% 离线计算部分
% 计算D的分段及机组的出力位置
for j = 1 : 2*ng
    if j == 1
        omega_D(j) = sum(Pmin);
    else
        for i = 1:ng
            if omega_lambda1(2*i-1) >= omega_lambda(j)% 若机组i出力下界对应的微增率仍大于分段内最优微增率可能的最大值，则i属于omega_L
                omega_D(j) = omega_D(j) + Pmin(i);% 对应式(23)
                flag_A(i,j-1) = 1;
            elseif omega_lambda1(2*i) <= omega_lambda(j-1) % 若机组i出力上界对应的微增率仍小于分段内最优微增率可能的最小值，则i属于omega_U
                omega_D(j) = omega_D(j) + Pmax(i);% 对应式(23)
                flag_A(i,j-1) = 3;
            else % 其他情况下，机组i属于omega_M
                omega_D(j) = omega_D(j) + (omega_lambda(j)-b(i))/(2*a(i));% 对应式(23)
                flag_A(i,j-1) = 2;
            end
        end

        gen_min = find(flag_A(:,j-1) == 1);
        gen_max = find(flag_A(:,j-1) == 3);
        gen_mid = find(flag_A(:,j-1) == 2);

        Alpha_A(j-1) = sum(1./( 2*a(gen_mid))); % 对应式(26)
        Beta_A(j-1) = sum(Pmax(gen_max))+sum(Pmin(gen_min))-sum(b(gen_mid)./(2*a(gen_mid))); % 对应式(26)

        % 目标函数，对应式(28)
        if isempty(gen_mid)
            F_para_A(1,j-1) = 0; % 二次项系数
            F_para_A(2,j-1) = 0; % 一次项系数
            F_para_A(3,j-1) = sum(a(gen_max).*Pmax(gen_max).^2+b(gen_max).*Pmax(gen_max))+...
                sum(a(gen_min).*Pmin(gen_min).^2+b(gen_min).*Pmin(gen_min))+c; % 常数项系数
        else
            F_para_A(1,j-1) = 1/sum(1./a(gen_mid)); % 二次项系数
            F_para_A(2,j-1) = (sum(b(gen_mid)./a(gen_mid))-...
                2*sum(Pmax(gen_max))-...
                2*sum(Pmin(gen_min)))/...
                sum(1./(a(gen_mid))); % 一次项系数
            F_para_A(3,j-1) = sum(a(gen_max).*Pmax(gen_max).^2+b(gen_max).*Pmax(gen_max))+...
                sum(a(gen_min).*Pmin(gen_min).^2+b(gen_min).*Pmin(gen_min))+...
                F_para_A(2,j-1)^2/(4*F_para_A(1,j-1))+...
                sum(0-b(gen_mid).^2./(4*a(gen_mid)))+c; % 常数项系数
        end
    end
end

%% 在线计算部分
% 计算最优出力
tic % 开始计时

% 查找目前负荷总量对应的分段
D_loc = find(omega_D > D);
D_ind = D_loc(1)-1; % 对应的分段编号

% 查找这一分段下各个机组最优出力是否位于上下界
gen_min = find(flag_A(:,D_ind) == 1);
gen_max = find(flag_A(:,D_ind) == 3);
gen_mid = find(flag_A(:,D_ind) == 2);

% 计算机组最优出力及目标函数取值
% 机组出力
P_star_A(gen_min) = Pmin(gen_min);
P_star_A(gen_max) = Pmax(gen_max);
P_star_A(gen_mid) = ((D - Beta_A(D_ind)) / Alpha_A(D_ind) - b(gen_mid))./(2.*a(gen_mid));
F_star_A = F_para_A(1,D_ind)*D^2 + F_para_A(2,D_ind)*D + F_para_A(3,D_ind);% 目标函数取值

time_A = toc; % 统计时间
end