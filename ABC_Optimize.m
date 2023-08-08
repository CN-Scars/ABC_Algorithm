function [best_pop, min_cost] = ABC_Optimize()
    % �ο����ף�A powerful and efficient algorithm for numerical function optimization: artificial bee colony (ABC) algorithm. Kluwer Academic Publishers, 2007, 39(3):459-471.
    % �������ӣ�https://link.springer.com/article/10.1007/s10898-007-9149-x
    
    clc; clear all; close all;  % �������
    gy_size=100;  %��Ӷ��Ⱥ�Ĵ�С
    gc_size=60;  %�۲��Ⱥ�Ĵ�С
    Dim=2;  %ά��
    limit=round(0.2*Dim*gy_size);  % ��Դʵ�����ƣ��ж�����׶�
    max_gen=100;  % ����������
    pop_max=100;   % ��Դ�߽磬��Դ=λ��
    pop_min=-100;
    
    %% ��ʼ����Ⱥ
    for i=1:gy_size
        pops(i,:)=(pop_max-pop_min).*rand(1,Dim)+pop_min;  % ��ʼ����Ⱥ����ʼΪ��Ӷ���ɫ
        cost(i,:)=error_function(pops(i,:));  % �����Ӧ�ĺ���ֵ
    end
    
    [min_cost,index]=min(cost); % ��С����ֵ��������
    best_pop=pops(index,:);    % ������Դ
    L=zeros(gy_size,1);      % ��Դλ�ø���ͣ�͵Ĵ���
    %% ��Ӷ��׶�
    for gen=1:max_gen
    
        for i=1:gy_size
            k=randi(gy_size,1); % ѡ��һ��������i������һ������
            while k==i
                k=randi(gy_size,1);
            end
            fai=rand*2-1;  % ����ϵ��,ȡֵ��Χ[-1,1]
            new_pop=pops(i,:)+fai.*(pops(i,:)-pops(k,:));      % ���¹�Ӷ���λ��
            % �߽紦��
            new_pop = min(pop_max,new_pop);
            new_pop = max(pop_min,new_pop);
    
            new_cost=error_function(new_pop);                % ������Ӧ�ĺ���ֵ
            if new_cost<cost(i)      % ̰����ʽ�洢�����Դ����û���£����¼
                pops(i,:)=new_pop;
                cost(i)=new_cost;
            else
                L(i)=L(i)+1;      % ��¼����Դ�ĸ���ͣ�ʹ���
            end
        end
        % ������Ӧ��
        m_cost=mean(cost);
        for i=1:gy_size
            F(i)=exp(-cost(i)/m_cost);
        end
    
        P=cumsum(F/sum(F));    % �����ۻ�ѡ�����
    
        %% �۲��׶�
        for i=1:gc_size
            r=rand;   % �������̶����ѡ��һ����Դ���Ը���Դ���и���
            j=find(r<=P,1,'first');
            k=randi(gy_size,1); % ѡ��һ��������j������һ������
            while k==j
                k=randi(gy_size,1);
            end
            fai=rand*2-1;  %����ϵ��,ȡֵ��Χ[-1,1]
            new_pop=pops(j,:)+fai.*(pops(j,:)-pops(k,:));      % ���¹۲���λ��
    
            % �߽紦��
            new_pop = min(pop_max,new_pop);
            new_pop = max(pop_min,new_pop);
    
            new_cost=error_function(new_pop);                % ������Ӧ�ĺ���ֵ
            if new_cost<cost(j)      % ̰����ʽ�洢�����Դ����û���£����¼
                pops(j,:)=new_pop;
                cost(j)=new_cost;
            else
                L(j)=L(j)+1;      % ��¼����Դ�ĸ���ͣ�ʹ���
            end
        end
    
        %% ����׶�
        for i=1:gy_size    % ������Ⱥ���Ƿ�����Դͣ�͸���
            if L(i)>=limit
                pops(i,:)=(pop_max-pop_min).*rand(1,Dim)+pop_min;
                cost(i)=error_function(pops(i,:));
                L(i)=0;
            end
        end
    
        %% ���һ���ĸ���
        for i=1:gy_size
            if cost(i)<min_cost
                best_pop=pops(i,:);
                min_cost=cost(i);
            end
        end
        % ��¼
        record(gen,:)=[gen,min_cost];
        disp(['Generation ' num2str(gen) '   Min cost= ' num2str(min_cost)]);
    end
    % ��ͼ
    plot(record(:,1),record(:,2));
    xlabel('��������');
    ylabel('Ŀ�꺯��ֵ');
end