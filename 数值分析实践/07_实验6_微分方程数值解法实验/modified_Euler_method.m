% 对比显式欧拉法与预测-校正法（改进欧拉法）
clear; clc;

% 解析解和右端函数
exact = @(t) 2*t - 2 + 3*exp(-t);
f = @(t, y) -y + 2*t;% 预测-校正法（改进欧拉法）：求解 y' = -y + 2t, y(0)=1, t∈[0,5]
clear; clc;

% 解析解与右端函数
exact = @(t) 2*t - 2 + 3*exp(-t);
f = @(t, y) -y + 2*t;

% 参数
y0 = 1;
t_span = [0, 5];
h_list = [0.1, 0.05, 0.01];

fprintf('========== 预测-校正法 ==========\n');
fprintf(' h      N     y(5)数值    全局最大误差      耗时(s)\n');
fprintf('----------------------------------------------\n');

for h = h_list
    N = round((t_span(2) - t_span(1)) / h);
    t = linspace(t_span(1), t_span(2), N+1);
    
    % 预测-校正法计算
    y = zeros(1, N+1);
    y(1) = y0;
    tic;                % 开始计时
    for i = 1:N
        y_pred = y(i) + h * f(t(i), y(i));           % 预测步
        y(i+1) = y(i) + (h/2)*(f(t(i),y(i)) + f(t(i+1),y_pred));  % 校正步
    end
    elapsed = toc;      % 结束计时
    
    % 误差分析
    err = max(abs(y - exact(t)));
    
    fprintf('%.2f   %4d   %8.6f   %12.6e   %.6f\n', ...
            h, N, y(end), err, elapsed);
end


% 参数
y0 = 1;
t_span = [0, 5];
h_list = [0.1, 0.05, 0.01];

fprintf('方法            h        N      y(5)数值    y(5)精确    全局最大误差\n');
fprintf('-----------------------------------------------------------------\n');

for h = h_list
    N = (t_span(2) - t_span(1)) / h;
    t = linspace(t_span(1), t_span(2), N+1);
    
    % ---- 显式欧拉法 ----
    y_euler = zeros(1, N+1);
    y_euler(1) = y0;
    for i = 1:N
        y_euler(i+1) = y_euler(i) + h * f(t(i), y_euler(i));
    end
    err_euler = max(abs(y_euler - exact(t)));
    
    % ---- 预测-校正法（改进欧拉法） ----
    y_heun = zeros(1, N+1);
    y_heun(1) = y0;
    for i = 1:N
        % 预测步（欧拉步）
        y_pred = y_heun(i) + h * f(t(i), y_heun(i));
        % 校正步（梯形公式）
        y_heun(i+1) = y_heun(i) + (h/2) * ( f(t(i), y_heun(i)) + f(t(i+1), y_pred) );
    end
    err_heun = max(abs(y_heun - exact(t)));
    
    % 输出
    fprintf('欧拉法         %.2f   %4d   %8.6f   %8.6f   %12.6e\n', ...
            h, N, y_euler(end), exact(5), err_euler);
    fprintf('预测-校正法    %.2f   %4d   %8.6f   %8.6f   %12.6e\n', ...
            h, N, y_heun(end), exact(5), err_heun);
    fprintf('-----------------------------------------------------------------\n');
end
