function [time_M,F_star_M,P_star_M] = RunMosek(a,b,c,D,Pmin,Pmax)
% ���������ڵ���MOSEK�����������������Ÿ��ɷ��侫ȷ�⣬�������������Բ�����������������ϵͳ�ܸ��ɣ�����������ų�����Ŀ�꺯������ֵ���㷨���ʱ��
%% �����������������
ng = length(Pmin);
Q = diag(a); % ����ȼ������ϵ���Ķ��������ɶԽǾ���
%% ������߱����������������
P = sdpvar(ng,1);
e = ones(ng,1);
%% ����Լ��
cons = [e'*P-D == 0]; % ����ƽ��Լ��
cons = cons + [Pmin <= P <= Pmax]; % ����������½�Լ��
%% ����Ŀ�꺯��
obj = P'*Q*P + b'*P + c;
%% ������������
ses = sdpsettings('solver','mosek','savesolveroutput',1,'verbose',3,'debug',1);
res = optimize(cons,obj,ses);
P_star_M = value(P); % ���ų���
F_star_M = P_star_M'*Q*P_star_M+b'*P_star_M+c; % ���Ž���Ŀ�꺯��ȡֵ
time_M = res.solvertime; % ��¼���ʱ��
end