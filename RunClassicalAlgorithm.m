function [time_C,F_star_C,P_star_C] = RunClassicalAlgorithm(a,b,c,D,Pmin,Pmax)
% ����������ʵ�ִ�ͳ�㷨���������������Բ�����������������ϵͳ�ܸ��ɣ�����������ų�����Ŀ�꺯������ֵ���㷨���ʱ��
tic % ��ʼ��ʱ
%% �����������������
ng = length(Pmin);
Q = diag(a); % ����ȼ������ϵ���Ķ��������ɶԽǾ���
flag_C = 2*ones(ng,2);% ��һ�����ڴ洢����i�Ƿ��ѹ̶����Ͻ�/�½硣���У�1��Ӧ��������̶��½磬2��Ӧ�������δ�̶���3��Ӧ��������̶����Ͻ磻...
                      % �ڶ������ڴ洢ĳ�ֵ����У�����i�Ƿ�Խ�硣���У�1��Ӧ�������Խ�½磬2��Ӧ���������Խ�磬3��Ӧ�������Խ�Ͻ硣
P_star_C = zeros(ng,1); % �洢��ͳ����������ų���

%% ��ʼ����
while sum(flag_C(:,2))% ��������ֹ��������Ϊ������Խ�޻���
    flag_C(:,2) = zeros(ng,1);
    % ���Ҹ����������ų����Ƿ�λ�����½�
    gen_min = find(flag_C(:,1) == 1);
    gen_mid = find(flag_C(:,1) == 2);
    gen_max = find(flag_C(:,1) == 3);
    % ���㱾�ֵ����е����ź���΢���ʣ���Ӧʽ(15)
    lambda_C = (D - sum(Pmax(gen_max)) - sum(Pmin(gen_min)) + sum(b(gen_mid)./...
        (2*a(gen_mid))))/sum(1./(2*a(gen_mid)));
    % ȷ���������������Ƿ�Խ��
    for i = 1:ng
        if flag_C(i,1) == 1 % �Ѿ��̶����½�Ļ�����������½�
            P_star_C(i) = Pmin(i);
        elseif flag_C(i,1) == 3 % �Ѿ��̶����Ͻ�Ļ�����������Ͻ�
            P_star_C(i) = Pmax(i);
        else % ��������������ݱ��ֵ��������ź���΢����ȷ��
            P_star_C(i) = (lambda_C-b(i))/(2*a(i));
        end
        if P_star_C(i) > Pmax(i) % �����ֵ�����Խ�Ͻ�Ļ��������Ͻ�
            flag_C(i,:) = 3;
        elseif P_star_C(i) < Pmin(i) % �����ֵ�����Խ�½�Ļ��������½�
            flag_C(i,:) = 1;
        end
    end
end

F_star_C = P_star_C'*Q*P_star_C +b'*P_star_C + c;% �������ų����µ�Ŀ�꺯��ֵ
time_C = toc; % ͳ��ʱ��
end
