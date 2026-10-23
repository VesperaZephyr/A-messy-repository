% 绘制误差-步长收敛曲线（显式欧拉法、预测-校正法、RK4）
clear; clc; close all;

% 精确解和右端函数
exact = @(t) 2*t - 2 + 3*exp(-t);
f = @(t, y) -y + 2*t;

% 初值和区间
y0 = 1;
t_span = [0, 5];

% 步长列表（需要覆盖足够范围以观察收敛阶）
h_list = [0.1, 0.05, 0.02, 0.01, 0.005];  % 可自行增减

% 存储误差
err_euler = zeros(size(h_list));
err_heun  = zeros(size(h_list));
err_rk4   = zeros(size(h_list));

for idx = 1:length(h_list)
    h = h_list(idx);
    N = round((t_span(2) - t_span(1)) / h);
    t = linspace(t_span(1), t_span(2), N+1);
    
    % ---- 欧拉法 ----
    y_euler = zeros(1, N+1); y_euler(1) = y0;
    for i = 1:N
        y_euler(i+1) = y_euler(i) + h * f(t(i), y_euler(i));
    end
    err_euler(idx) = max(abs(y_euler - exact(t)));
    
    % ---- 预测-校正法 ----
    y_heun = zeros(1, N+1); y_heun(1) = y0;
    for i = 1:N
        y_pred = y_heun(i) + h * f(t(i), y_heun(i));
        y_heun(i+1) = y_heun(i) + (h/2)*(f(t(i),y_heun(i)) + f(t(i+1),y_pred));
    end
    err_heun(idx) = max(abs(y_heun - exact(t)));
    
    % ---- RK4 ----
    y_rk4 = zeros(1, N+1); y_rk4(1) = y0;
    for i = 1:N
        ti = t(i); yi = y_rk4(i);
        k1 = f(ti, yi);
        k2 = f(ti + h/2, yi + h/2*k1);
        k3 = f(ti + h/2, yi + h/2*k2);
        k4 = f(ti + h, yi + h*k3);
        y_rk4(i+1) = yi + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
    end
    err_rk4(idx) = max(abs(y_rk4 - exact(t)));
end

% 输出误差数据表
fprintf('步长 h     欧拉法误差    预测-校正法误差    RK4误差\n');
fprintf('------------------------------------------------------\n');
for idx = 1:length(h_list)
    fprintf('%.3f     %12.6e   %12.6e   %12.6e\n', ...
            h_list(idx), err_euler(idx), err_heun(idx), err_rk4(idx));
end

% ---- 绘制 loglog 收敛曲线 ----
figure;
loglog(h_list, err_euler, 'o-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Euler');
hold on;
loglog(h_list, err_heun, 's-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Heun (predictor-corrector)');
loglog(h_list, err_rk4, '^-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'RK4');

% 添加理论斜率参考线 (选一个参考点)
% 取 h=0.1 的误差作为基准，绘制 O(h^1), O(h^2), O(h^4) 参考线
h_ref = 0.1;
idx_ref = find(abs(h_list - h_ref) < 1e-6, 1);  % 找到 h=0.1 的索引
if isempty(idx_ref)
    idx_ref = 1;  % 如果 h_list 中没有恰好 0.1，则用第一个点
end

% 使用欧拉法在 h_ref 处的误差作为 O(h) 的起点
euler_ref = err_euler(idx_ref);
% 绘制 O(h) 线: 与欧拉法同起点，斜率为1
h_line = linspace(min(h_list), max(h_list), 100);
line_O1 = euler_ref * (h_line / h_ref).^1;
loglog(h_line, line_O1, 'k--', 'LineWidth', 1, 'DisplayName', 'O(h)');

% 预测-校正法在 h_ref 处的误差作为 O(h^2) 起点
heun_ref = err_heun(idx_ref);
line_O2 = heun_ref * (h_line / h_ref).^2;
loglog(h_line, line_O2, 'k:', 'LineWidth', 1, 'DisplayName', 'O(h^2)');

% RK4 在 h_ref 处的误差作为 O(h^4) 起点
rk4_ref = err_rk4(idx_ref);
line_O4 = rk4_ref * (h_line / h_ref).^4;
loglog(h_line, line_O4, 'k-.', 'LineWidth', 1, 'DisplayName', 'O(h^4)');

% 图例与标签
xlabel('步长 h');
ylabel('全局最大误差');
title('误差-步长收敛曲线');
legend('Location', 'northwest');
grid on;
set(gca, 'FontSize', 12);
hold off;
