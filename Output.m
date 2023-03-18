function Output(casegroup,P_star,F_star,F_error,Time)
% 本函数用于输出结果
fprintf('计算结束！求解结果、求解时间与求解精度已生成。\n');
fprintf('计算结果见下列文件：\n算法求解结果.txt\n算法求解时间.txt\n算法求解精度.txt\n');
CASE_NUM = length(casegroup);
fid=fopen('算法求解结果.txt','w');
fprintf(fid,'1、最优出力（单位：MW）');
for i = 1 : CASE_NUM
    fprintf(fid,['\n',casegroup{i}]);
    fprintf(fid,'\n解析法：\t\t');
    fprintf(fid,'%.2E\t',P_star{i,1});
    fprintf(fid,'\n图解法：\t\t');
    fprintf(fid,'%.2E\t',P_star{i,2});
    fprintf(fid,'\n传统算法：\t');
    fprintf(fid,'%.2E\t',P_star{i,3});
    fprintf(fid,'\nMOSEK：\t\t');
    fprintf(fid,'%.2E\t',P_star{i,4});
    fprintf(fid,'\n');
end
fprintf(fid,'\n2、最优耗量（单位：$）\n');
fprintf(fid,'节点数\t机组数\t解析法\t图解法\t传统法\tMOSEK\n');
for i = 1 : CASE_NUM
    str = casegroup{i};
    num = str2num(str(isstrprop(str,'digit')));
    if strcmp(str(end),'k')
        num = num * 1000;
    end
    fprintf(fid,'%d\t%d\t%.2E\t%.2E\t%.2E\t%.2E\n',num,length(P_star{i,1}),F_star(i,1),F_star(i,2),F_star(i,3),F_star(i,4));
end

fid=fopen('算法求解精度.txt','w');
fprintf(fid,'节点数\t机组数\t解析法\t\t图解法\t\t传统法\n');
for i = 1 : CASE_NUM
    str = casegroup{i};
    num = str2num(str(isstrprop(str,'digit')));
    if strcmp(str(end),'k')
        num = num * 1000;
    end
    fprintf(fid,'%d\t%d\t%.4E\t%.4E\t%.4E\n',num,length(P_star{i,1}),F_error(i,1),F_error(i,2),F_error(i,3));
end

fid=fopen('算法求解时间.txt','w');
fprintf(fid,'节点数\t机组数\t解析法\t图解法\t传统法\tMOSEK\n');
for i = 1 : CASE_NUM
    str = casegroup{i};
    num = str2num(str(isstrprop(str,'digit')));
    if strcmp(str(end),'k')
        num = num * 1000;
    end
    fprintf(fid,'%d\t%d\t%.4f\t%.4f\t%.4f\t%.4f\n',num,length(P_star{i,1}),Time(i,1),Time(i,2),Time(i,3),Time(i,4));
end
end