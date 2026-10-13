clear; clc; close all;

% ---------- 参数计算 ----------
S = 14;
t = (1.5 * S) / 100;                % t = 0.21

% ---------- 定义函数 ----------
f = @(x) atan(5*x - 5*t) + 0.5*(x - t) + 1;

% ---------- 绘图区间 ----------
x_min = t - 3;
x_max = t + 3;
x_plot = linspace(x_min, x_max, 1000);
y_plot = f(x_plot);

% ---------- 绘图 ----------
figure('Name', 'Plot of f(x)', 'Color', 'w');
plot(x_plot, y_plot, 'b-', 'LineWidth', 2);
hold on;
yline(0, 'k--', 'LineWidth', 1);            % y = 0 参考线
xline(t, 'r:', 'LineWidth', 1);             % x = t 参考线
grid on;
xlabel('x', 'FontSize', 12);
ylabel('f(x)', 'FontSize', 12);
title(['Plot of f(x) with t = ', num2str(t)], 'FontSize', 14);
legend('f(x)', 'y = 0', ['x = t (' num2str(t) ')'], 'Location', 'best');
xlim([x_min, x_max]);

% ---------- 标注零点 ----------
x_root = [];                              % 防止使用工作区中残留的同名变量
try
    x_root = fzero(f, [-0.5, 0]);         % 区间包含负根
catch
    warning('fzero 未能找到根，请检查函数或区间。');
end

if ~isempty(x_root) && isfinite(x_root)
    % 绘制红色圆点
    plot(x_root, 0, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    % 标签放在点的右下方：左对齐+顶对齐，使文本从点位置向右、向下延伸
    text(x_root, 0, ['Root \approx ' num2str(x_root, '%.4f')], ...
         'HorizontalAlignment', 'left', ...
         'VerticalAlignment', 'top', ...
         'FontSize', 10);
end

hold off;
