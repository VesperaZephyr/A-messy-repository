% 四阶龙格-库塔法（RK4）求解 y' = -y + 2t, y(0)=1, t∈[0,5]
clear; clc;

% 解析解与右端函数
exact = @(t) 2*t - 2 + 3*exp(-t);
f = @(t, y) -y + 2*t;

% 初值与求解区间
y0 = 1;
t_span = [0, 5];

% 步长
h = 0.1;

% 迭代步数
N = round((t_span(2) - t_span(1)) / h);
t = linspace(t_span(1), t_span(2), N+1);
y = zeros(1, N+1);
y(1) = y0;

% RK4 主循环（计时开始）
tic;
for i = 1:N
    ti = t(i);
    yi = y(i);
    
    k1 = f(ti, yi);
    k2 = f(ti + h/2, yi + h/2 * k1);
    k3 = f(ti + h/2, yi + h/2 * k2);
    k4 = f(ti + h, yi + h * k3);
    
    y(i+1) = yi + (h/6) * (k1 + 2*k2 + 2*k3 + k4);
end
elapsed_time = toc;  % 计时结束

% 计算精确解与误差
y_exact = exact(t);
error = abs(y - y_exact);
max_error = max(error);

% 输出结果
fprintf('RK4 求解结果（h = %.2f, 步数 = %d）\n', h, N);
fprintf('t_end = %.1f, 解析解 = %.6f, 数值解 = %.6f\n', t_span(2), exact(t_span(2)), y(end));
fprintf('全局最大误差 = %12.6e\n', max_error);
fprintf('核心循环耗时 = %.6f 秒\n', elapsed_time);
