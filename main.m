clear all
%% ��������
[casegroup,CASE_NUM,F_error,Time,P_star,F_star] = InputCase();

%% �ֱ����ÿ������
for round = 1:CASE_NUM
    casedata = casegroup{round};
    [a,b,c,D,Pmin,Pmax,caseerror] = IEEECaseProcessing(casedata);% ��IEEE��׼�����ж�ȡ��������
    if caseerror == 0
        [Time(round,4),F_star(round,4),P_star{round,4}] = RunMosek(a,b,c,D,Pmin,Pmax);% ����MOSEK�����
        [Time(round,1),F_star(round,1),P_star{round,1}] = RunAnalyticalAlgorithm(a,b,c,D,Pmin,Pmax);% ���ý��������
        [Time(round,2),F_star(round,2),P_star{round,2}] = RunGraphicAlgorithm(a,b,c,D,Pmin,Pmax);% ����ͼ�ⷨ���
        [Time(round,3),F_star(round,3),P_star{round,3}] = RunClassicalAlgorithm(a,b,c,D,Pmin,Pmax);% ���ô�ͳ�㷨���
        % ���㡢�洢���������½�������ͼ�ⷨ����ͳ�㷨����⾫��
        F_error(round,:) = abs(F_star(round,1:3) - F_star(round,4))/F_star(round,4)*100;
    end
end

%% ������
Output(casegroup,P_star,F_star,F_error,Time)