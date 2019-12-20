for k=90:115
    nDays=90;
    dt=1/365.0;   % ����Ϊʱ�䵥λ
    T=nDays*dt;
    S0=k; % ��ʼ�ɼ�
    K=120;  % �ö���
    r=0.031;  % �����ʣ��޷������ʣ�
    sigma=0.3;  % ������
    expTerm=r*dt;
    stddev=sigma*sqrt(dt);
    nTrials=100000;
    value=0;
    for j=1:nTrials
        n=randn(1,nDays);
        S=S0;
        for i =1:nDays
            dS=S*(expTerm+stddev*n(i));
            S=S+dS;
        end
        Sk(j)=S; % ����ÿ������Ľ��
        value=value+max(S-K,0);
    end
    value=value/nTrials;    % ����ֵ
    Price=exp(-r*T)*value;   % ����
    %V(k)=Price;
    disp(Price);
    %hist(Sk,40:0.5:300);
end

%plot(V, 'Color',[1 0 0.8],'LineWidth',1.2);
%plot(V, 'Color',[0 0.9 0.9],'LineWidth',1.2);
%plot(V, 'Color',[1 0.5 0],'LineWidth',1.2);
%plot(V, 'Color',[0 0.5 1],'LineWidth',1.2);
%plot(V, 'Color',[0.4 0.4 0.4],'LineWidth',1.2);
%xlim([0 170]);
%hold on

%grid;
%legend('sigma=0.2','sigma=0.25','sigma=0.3','sigma=0.35','sigma=0.4','location','northwest');
%legend('r=0.01','r=0.05','r=0.1','r=0.2','r=0.3','location','northwest');
