function [casegroup,CASE_NUM,F_error,Time,P_star,F_star] = InputCase()
% ���������������û��������Ե���������������ȫ�ֱ���
casegroup = input("\n�ɹ�ѡ�������������'case9','case24_ieee_rts','case118','case_ACTIVSg200',\n'case2383wp','case2746wop','case_ACTIVSg10k','case_ACTIVSg25k','case_ACTIVSg70k'����" + ...
    "\n����������������������һ����������������ʽΪ��{'case9'}����{'case9','case24_ieee_rts','case118'}����");
CASE_NUM = length(casegroup);% �洢������Ե���������
F_error = zeros(CASE_NUM,3);% �洢����ֵ�������
Time = zeros(CASE_NUM,4);% �洢���ʱ��
P_star = cell(CASE_NUM,4);% �洢���ų���
F_star = zeros(CASE_NUM,4);% �洢Ŀ�꺯������ֵ
end