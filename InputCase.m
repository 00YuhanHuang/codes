function [casegroup,CASE_NUM,F_error,Time,P_star,F_star] = InputCase()
% 本函数用于输入用户期望测试的算例名、并定义全局变量
casegroup = input("\n可供选择的算例包括：'case9','case24_ieee_rts','case118','case_ACTIVSg200',\n'case2383wp','case2746wop','case_ACTIVSg10k','case_ACTIVSg25k','case_ACTIVSg70k'）。" + ...
    "\n请输入算例名（允许输入一个或多个算例名，格式为：{'case9'}，或{'case9','case24_ieee_rts','case118'}）：");
CASE_NUM = length(casegroup);% 存储所需测试的算例总数
F_error = zeros(CASE_NUM,3);% 存储最优值精度误差
Time = zeros(CASE_NUM,4);% 存储求解时间
P_star = cell(CASE_NUM,4);% 存储最优出力
F_star = zeros(CASE_NUM,4);% 存储目标函数最优值
end