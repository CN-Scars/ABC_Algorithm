function [best_pop, min_cost] = ABC_Optimize()
    % 参考文献：A powerful and efficient algorithm for numerical function optimization: artificial bee colony (ABC) algorithm. Kluwer Academic Publishers, 2007, 39(3):459-471.
    % 文献链接：https://link.springer.com/article/10.1007/s10898-007-9149-x
    
    clc; clear all; close all;  % 清除缓存
    gy_size=100;  %雇佣蜂群的大小
    gc_size=60;  %观察蜂群的大小
    Dim=2;  %维度
    limit=round(0.2*Dim*gy_size);  % 蜜源实验限制，判断侦查蜂阶段
    max_gen=100;  % 最大迭代次数
    pop_max=100;   % 蜜源边界，蜜源=位置
    pop_min=-100;
    
    %% 初始化种群
    for i=1:gy_size
        pops(i,:)=(pop_max-pop_min).*rand(1,Dim)+pop_min;  % 初始化种群，初始为雇佣蜂角色
        cost(i,:)=error_function(pops(i,:));  % 计算对应的函数值
    end
    
    [min_cost,index]=min(cost); % 最小函数值及其索引
    best_pop=pops(index,:);    % 最优蜜源
    L=zeros(gy_size,1);      % 蜜源位置更新停滞的次数
    %% 雇佣蜂阶段
    for gen=1:max_gen
    
        for i=1:gy_size
            k=randi(gy_size,1); % 选择一个除个体i的其它一个个体
            while k==i
                k=randi(gy_size,1);
            end
            fai=rand*2-1;  % 加速系数,取值范围[-1,1]
            new_pop=pops(i,:)+fai.*(pops(i,:)-pops(k,:));      % 更新雇佣蜂的位置
            % 边界处理
            new_pop = min(pop_max,new_pop);
            new_pop = max(pop_min,new_pop);
    
            new_cost=error_function(new_pop);                % 更新相应的函数值
            if new_cost<cost(i)      % 贪婪方式存储最佳蜜源，若没更新，则记录
                pops(i,:)=new_pop;
                cost(i)=new_cost;
            else
                L(i)=L(i)+1;      % 记录此蜜源的更新停滞次数
            end
        end
        % 计算适应性
        m_cost=mean(cost);
        for i=1:gy_size
            F(i)=exp(-cost(i)/m_cost);
        end
    
        P=cumsum(F/sum(F));    % 更新累积选择概率
    
        %% 观察蜂阶段
        for i=1:gc_size
            r=rand;   % 采用轮盘赌随机选择一个蜜源，对该蜜源进行更新
            j=find(r<=P,1,'first');
            k=randi(gy_size,1); % 选择一个除个体j的其它一个个体
            while k==j
                k=randi(gy_size,1);
            end
            fai=rand*2-1;  %加速系数,取值范围[-1,1]
            new_pop=pops(j,:)+fai.*(pops(j,:)-pops(k,:));      % 更新观察蜂的位置
    
            % 边界处理
            new_pop = min(pop_max,new_pop);
            new_pop = max(pop_min,new_pop);
    
            new_cost=error_function(new_pop);                % 更新相应的函数值
            if new_cost<cost(j)      % 贪婪方式存储最佳蜜源，若没更新，则记录
                pops(j,:)=new_pop;
                cost(j)=new_cost;
            else
                L(j)=L(j)+1;      % 记录此蜜源的更新停滞次数
            end
        end
    
        %% 侦查蜂阶段
        for i=1:gy_size    % 遍历种群看是否有蜜源停滞更新
            if L(i)>=limit
                pops(i,:)=(pop_max-pop_min).*rand(1,Dim)+pop_min;
                cost(i)=error_function(pops(i,:));
                L(i)=0;
            end
        end
    
        %% 完成一代的更新
        for i=1:gy_size
            if cost(i)<min_cost
                best_pop=pops(i,:);
                min_cost=cost(i);
            end
        end
        % 记录
        record(gen,:)=[gen,min_cost];
        disp(['Generation ' num2str(gen) '   Min cost= ' num2str(min_cost)]);
    end
    % 绘图
    plot(record(:,1),record(:,2));
    xlabel('迭代次数');
    ylabel('目标函数值');
end