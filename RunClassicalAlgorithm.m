function [time_C,F_star_C,P_star_C] = RunClassicalAlgorithm(a,b,c,D,Pmin,Pmax)
% 本函数用于实现传统算法，输入机组耗量特性参数、出力上下限与系统总负荷，输出机组最优出力、目标函数最优值及算法求解时间
tic % 开始计时
%% 基本参数与变量生成
ng = length(Pmin);
Q = diag(a); % 根据燃料消耗系数的二次项生成对角矩阵
flag_C = 2*ones(ng,2);% 第一列用于存储机组i是否已固定在上界/下界。其中，1对应机组出力固定下界，2对应机组出力未固定，3对应机组出力固定在上界；...
                      % 第二列用于存储某轮迭代中，机组i是否越界。其中，1对应机组出力越下界，2对应机组出力不越界，3对应机组出力越上界。
P_star_C = zeros(ng,1); % 存储传统法计算的最优出力

%% 开始迭代
while sum(flag_C(:,2))% 将迭代终止条件设置为不存在越限机组
    flag_C(:,2) = zeros(ng,1);
    % 查找各个机组最优出力是否位于上下界
    gen_min = find(flag_C(:,1) == 1);
    gen_mid = find(flag_C(:,1) == 2);
    gen_max = find(flag_C(:,1) == 3);
    % 计算本轮迭代中的最优耗量微增率，对应式(15)
    lambda_C = (D - sum(Pmax(gen_max)) - sum(Pmin(gen_min)) + sum(b(gen_mid)./...
        (2*a(gen_mid))))/sum(1./(2*a(gen_mid)));
    % 确定机组出力，检查是否越限
    for i = 1:ng
        if flag_C(i,1) == 1 % 已经固定在下界的机组出力置于下界
            P_star_C(i) = Pmin(i);
        elseif flag_C(i,1) == 3 % 已经固定在上界的机组出力置于上界
            P_star_C(i) = Pmax(i);
        else % 其他机组出力根据本轮迭代的最优耗量微增率确定
            P_star_C(i) = (lambda_C-b(i))/(2*a(i));
        end
        if P_star_C(i) > Pmax(i) % 将本轮迭代中越上界的机组置于上界
            flag_C(i,:) = 3;
        elseif P_star_C(i) < Pmin(i) % 将本轮迭代中越下界的机组置于下界
            flag_C(i,:) = 1;
        end
    end
end

F_star_C = P_star_C'*Q*P_star_C +b'*P_star_C + c;% 计算最优出力下的目标函数值
time_C = toc; % 统计时间
end
