function [time_A,F_star_A,P_star_A] = RunAnalyticalAlgorithm(a,b,c,D,Pmin,Pmax)
% ����������ʵ�ֽ��������������������Բ�����������������ϵͳ�ܸ��ɣ�����������ų�����Ŀ�꺯������ֵ���㷨���ʱ��
%% �����������������
ng = length(Pmin);
Q = diag(a); % ����ȼ������ϵ���Ķ��������ɶԽǾ���
omega_lambda1 = ones(2*ng,1); % ����΢���������޹��ɵļ���
for i = 1:ng
    omega_lambda1(2*i-1)=2*a(i)*Pmin(i)+b(i);
    omega_lambda1(2*i)=2*a(i)*Pmax(i)+b(i);
end
omega_lambda = sort(omega_lambda1); % ������΢���������޴�С��������

% ���������
omega_D = zeros(2*ng,1); % ���������ķֶ������ٽ�ֵ�����ֳ�2*ng-1��
F_para_A = zeros(3,2*ng-1); % ��������ֵ���ڸ��������Ķ�����ϵ����һ����ϵ���볣����
flag_A = zeros(ng,2*ng-1); % ���ڴ洢����i��ÿ�����������ֶ��У����ų�������������У�1��Ӧ����λ���½磬2��Ӧ����λ�����½�䣬3��Ӧ����λ���Ͻ硣
Alpha_A = zeros(2*ng-1,1); % �������ų������ڸ��������Ĳ�������Ӧ����ʽ(26)�е�alpha
Beta_A = zeros(2*ng-1,1); % �������ų������ڸ��������Ĳ�������Ӧ����ʽ(26)�е�beta
P_star_A = zeros(ng,1); % ��������õ����ų���

%% ���߼��㲿��
% ����D�ķֶμ�����ĳ���λ��
for j = 1 : 2*ng
    if j == 1
        omega_D(j) = sum(Pmin);
    else
        for i = 1:ng
            if omega_lambda1(2*i-1) >= omega_lambda(j)% ������i�����½��Ӧ��΢�����Դ��ڷֶ�������΢���ʿ��ܵ����ֵ����i����omega_L
                omega_D(j) = omega_D(j) + Pmin(i);% ��Ӧʽ(23)
                flag_A(i,j-1) = 1;
            elseif omega_lambda1(2*i) <= omega_lambda(j-1) % ������i�����Ͻ��Ӧ��΢������С�ڷֶ�������΢���ʿ��ܵ���Сֵ����i����omega_U
                omega_D(j) = omega_D(j) + Pmax(i);% ��Ӧʽ(23)
                flag_A(i,j-1) = 3;
            else % ��������£�����i����omega_M
                omega_D(j) = omega_D(j) + (omega_lambda(j)-b(i))/(2*a(i));% ��Ӧʽ(23)
                flag_A(i,j-1) = 2;
            end
        end

        gen_min = find(flag_A(:,j-1) == 1);
        gen_max = find(flag_A(:,j-1) == 3);
        gen_mid = find(flag_A(:,j-1) == 2);

        Alpha_A(j-1) = sum(1./( 2*a(gen_mid))); % ��Ӧʽ(26)
        Beta_A(j-1) = sum(Pmax(gen_max))+sum(Pmin(gen_min))-sum(b(gen_mid)./(2*a(gen_mid))); % ��Ӧʽ(26)

        % Ŀ�꺯������Ӧʽ(28)
        if isempty(gen_mid)
            F_para_A(1,j-1) = 0; % ������ϵ��
            F_para_A(2,j-1) = 0; % һ����ϵ��
            F_para_A(3,j-1) = sum(a(gen_max).*Pmax(gen_max).^2+b(gen_max).*Pmax(gen_max))+...
                sum(a(gen_min).*Pmin(gen_min).^2+b(gen_min).*Pmin(gen_min))+c; % ������ϵ��
        else
            F_para_A(1,j-1) = 1/sum(1./a(gen_mid)); % ������ϵ��
            F_para_A(2,j-1) = (sum(b(gen_mid)./a(gen_mid))-...
                2*sum(Pmax(gen_max))-...
                2*sum(Pmin(gen_min)))/...
                sum(1./(a(gen_mid))); % һ����ϵ��
            F_para_A(3,j-1) = sum(a(gen_max).*Pmax(gen_max).^2+b(gen_max).*Pmax(gen_max))+...
                sum(a(gen_min).*Pmin(gen_min).^2+b(gen_min).*Pmin(gen_min))+...
                F_para_A(2,j-1)^2/(4*F_para_A(1,j-1))+...
                sum(0-b(gen_mid).^2./(4*a(gen_mid)))+c; % ������ϵ��
        end
    end
end

%% ���߼��㲿��
% �������ų���
tic % ��ʼ��ʱ

% ����Ŀǰ����������Ӧ�ķֶ�
D_loc = find(omega_D > D);
D_ind = D_loc(1)-1; % ��Ӧ�ķֶα��

% ������һ�ֶ��¸����������ų����Ƿ�λ�����½�
gen_min = find(flag_A(:,D_ind) == 1);
gen_max = find(flag_A(:,D_ind) == 3);
gen_mid = find(flag_A(:,D_ind) == 2);

% ����������ų�����Ŀ�꺯��ȡֵ
% �������
P_star_A(gen_min) = Pmin(gen_min);
P_star_A(gen_max) = Pmax(gen_max);
P_star_A(gen_mid) = ((D - Beta_A(D_ind)) / Alpha_A(D_ind) - b(gen_mid))./(2.*a(gen_mid));
F_star_A = F_para_A(1,D_ind)*D^2 + F_para_A(2,D_ind)*D + F_para_A(3,D_ind);% Ŀ�꺯��ȡֵ

time_A = toc; % ͳ��ʱ��
end