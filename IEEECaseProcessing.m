function [a,b,c,D,Pmin,Pmax,caseerror] = IEEECaseProcessing(casedata)
% 本函数用于从IEEE标准算例中读取所需数据，输入算例名，输出机组耗量特性参数、出力上下限与系统总负荷，以及判断算例是否有解。
% 设置索引标签
define_constants;
% 读取算例
mpc = loadcase(casedata);
mpc = ext2int(mpc);
% 判断算例是否有误
% 寻找可支配的发电机
[~, BUS, GEN, ~, GENCOST] = loadcase(mpc);
on = find(GEN(:,GEN_STATUS)>0);
% 如果负荷不在所有机组最小/最大出力之和的范围内，则说明算例无解
if sum(GEN(on,PMAX)) - sum(BUS(:,PD)) < 0 || sum(GEN(on,PMIN)) - sum(BUS(:,PD)) > 0
    res = sprintf('case error');
    caseerror = 1;% 算例无解
    fprintf(res)
    return
else
    caseerror = 0;
end
% 获得场景的机组燃料消耗系数
if GENCOST(1,4) == 3
    a = GENCOST(on,5);
    b = GENCOST(on,6);
    c = GENCOST(on,7);
else
    a = zeros(length(on),1);
    b = GENCOST(on,5);
    c = GENCOST(on,6);
end
% 受限于问题假设，机组燃料消耗系数的二次项不为0，不符合以上条件的算例将原为0的系数更改为算例中最小的非零机组燃料消耗系数，若机组燃料消耗系均为零，则更改为10-3
if ~isempty(find(a == 0, 1))
    a1 = a;
    a1(a == 0) = [];
    if isempty(a1)
        a(a == 0) = 1e-3;
        fprintf(sprintf([casedata,'已修改，a(a == 0) = 1e-3. \n按任意键继续...']))
        pause
    else
        a(a == 0) = min(a1);
        fprintf(sprintf([casedata,'已修改，a(a == 0) = ',num2str(min(a1)),'. \n按任意键继续...']))
        pause
    end
end
c = sum(c); % 燃料消耗系数的常数项之和
Pmin = GEN(on,PMIN); % 各个机组出力下限
Pmax = GEN(on,PMAX); % 各个机组出力上限
D = sum(BUS(:,PD)); % 系统总负荷
end