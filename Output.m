function Output(casegroup,P_star,F_star,F_error,Time)
% ����������������
fprintf('�������������������ʱ������⾫�������ɡ�\n');
fprintf('�������������ļ���\n�㷨�����.txt\n�㷨���ʱ��.txt\n�㷨��⾫��.txt\n');
CASE_NUM = length(casegroup);
fid=fopen('�㷨�����.txt','w');
fprintf(fid,'1�����ų�������λ��MW��');
for i = 1 : CASE_NUM
    fprintf(fid,['\n',casegroup{i}]);
    fprintf(fid,'\n��������\t\t');
    fprintf(fid,'%.2E\t',P_star{i,1});
    fprintf(fid,'\nͼ�ⷨ��\t\t');
    fprintf(fid,'%.2E\t',P_star{i,2});
    fprintf(fid,'\n��ͳ�㷨��\t');
    fprintf(fid,'%.2E\t',P_star{i,3});
    fprintf(fid,'\nMOSEK��\t\t');
    fprintf(fid,'%.2E\t',P_star{i,4});
    fprintf(fid,'\n');
end
fprintf(fid,'\n2�����ź�������λ��$��\n');
fprintf(fid,'�ڵ���\t������\t������\tͼ�ⷨ\t��ͳ��\tMOSEK\n');
for i = 1 : CASE_NUM
    str = casegroup{i};
    num = str2num(str(isstrprop(str,'digit')));
    if strcmp(str(end),'k')
        num = num * 1000;
    end
    fprintf(fid,'%d\t%d\t%.2E\t%.2E\t%.2E\t%.2E\n',num,length(P_star{i,1}),F_star(i,1),F_star(i,2),F_star(i,3),F_star(i,4));
end

fid=fopen('�㷨��⾫��.txt','w');
fprintf(fid,'�ڵ���\t������\t������\t\tͼ�ⷨ\t\t��ͳ��\n');
for i = 1 : CASE_NUM
    str = casegroup{i};
    num = str2num(str(isstrprop(str,'digit')));
    if strcmp(str(end),'k')
        num = num * 1000;
    end
    fprintf(fid,'%d\t%d\t%.4E\t%.4E\t%.4E\n',num,length(P_star{i,1}),F_error(i,1),F_error(i,2),F_error(i,3));
end

fid=fopen('�㷨���ʱ��.txt','w');
fprintf(fid,'�ڵ���\t������\t������\tͼ�ⷨ\t��ͳ��\tMOSEK\n');
for i = 1 : CASE_NUM
    str = casegroup{i};
    num = str2num(str(isstrprop(str,'digit')));
    if strcmp(str(end),'k')
        num = num * 1000;
    end
    fprintf(fid,'%d\t%d\t%.4f\t%.4f\t%.4f\t%.4f\n',num,length(P_star{i,1}),Time(i,1),Time(i,2),Time(i,3),Time(i,4));
end
end