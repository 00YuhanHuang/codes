clear all
%% 输入算例
[casegroup,CASE_NUM,F_error,Time,P_star,F_star] = InputCase();

%% 分别测试每个算例
for round = 1:CASE_NUM
    casedata = casegroup{round};
    [a,b,c,D,Pmin,Pmax,caseerror] = IEEECaseProcessing(casedata);% 从IEEE标准算例中读取所需数据
    if caseerror == 0
        [Time(round,4),F_star(round,4),P_star{round,4}] = RunMosek(a,b,c,D,Pmin,Pmax);% 调用MOSEK求解器
        [Time(round,1),F_star(round,1),P_star{round,1}] = RunAnalyticalAlgorithm(a,b,c,D,Pmin,Pmax);% 调用解析法求解
        [Time(round,2),F_star(round,2),P_star{round,2}] = RunGraphicAlgorithm(a,b,c,D,Pmin,Pmax);% 调用图解法求解
        [Time(round,3),F_star(round,3),P_star{round,3}] = RunClassicalAlgorithm(a,b,c,D,Pmin,Pmax);% 调用传统算法求解
        % 计算、存储各个算例下解析法、图解法、传统算法的求解精度
        F_error(round,:) = abs(F_star(round,1:3) - F_star(round,4))/F_star(round,4)*100;
    end
end

%% 输出结果
Output(casegroup,P_star,F_star,F_error,Time)