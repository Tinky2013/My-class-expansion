function get_queue(arriving_time,leaving_time)
    N=size(arriving_time,2);    % �൱�ڹ˿���
    queue=zeros(2,N*2); % ��ʼ�����У�һ�м�¼ʱ��㣬һ�м�¼��ʱ����Ӧ������
    i=1;    % ����ʱ��ű�
    j=1;    % �뿪ʱ��ű�
    k=1;    
    % �˿Ϳ�ʼ����
    queue(1,1)=arriving_time(1);    % ��һ���˵���
    queue(2,1)=1;                   % ��һ���˵������г���Ϊ1
    k=k+1;
    i=i+1;
    while i~=N      
        if arriving_time(i)<leaving_time(j) % ��һ��������ʱ����һ���˻����Ŷ�
            queue(1,k)=arriving_time(i);    % ����ʱ���k
            queue(2,k)=queue(2,k-1)+1;      % ����һ���ˣ�ʱ���k��Ӧ�Ķ��鳤��+1
            k=k+1;
            i=i+1;
        else
            queue(1,k)=leaving_time(j);     % �뿪ʱ���k
            queue(2,k)=queue(2,k-1)-1;      % �뿪һ���ˣ�ʱ���k��Ӧ�Ķ��鳤��-1
            k=k+1;
            j=j+1;
        end
    end
    % ���й˿��Ѿ����ʣ��˿��뿪
    while j~=N
        queue(1,k)=leaving_time(j);     % �뿪ʱ��
        queue(2,k)=queue(2,k-1)-1;      % ÿ�뿪һ���ˣ����鳤�ȼ�һ
        k=k+1;
        j=j+1;
    end
    queue=queue(2,1:k-1);    % ����ʱ���鳤��Ϊ��
    disp(queue);             % ������
    plot(queue);             % ��ͼչʾ
        