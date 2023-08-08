function error = error_function(EmuD)
    % 解构EmuD
    EmuD1 = EmuD(1);
    EmuD2 = EmuD(2);

    % 初始参数
    A = [2, 1, 1; 
         1, 1, 0;
         0, 1, 2];
    B = [1, 2;
         3, 1;
         1, 1];
    C = [1, 0, 0;
         0, 0, 1];
    x = zeros(3, 1);
    r = [1; 1];
    T = 0.01;
    num_steps = 1000;

    % 计算反馈增益K 和 参考增益F
    [K, F] = Axui_FeedbackGain(EmuD1, EmuD2);

    % 用于存储每个时间步的输出
    y = zeros(2, num_steps);

    % 模拟
    for k = 1:num_steps
        % 使用控制器计算输入
        u = -K*x + F*r;
        % 更新系统状态
        x = T * (A * x + B * u) + x;
        % 计算并存储输出
        y(:, k) = C * x;
    end

    % 计算总误差
    error = T * (sum(abs(y(1, :) - 1)) + sum(abs(y(2, :) - 1)));
end