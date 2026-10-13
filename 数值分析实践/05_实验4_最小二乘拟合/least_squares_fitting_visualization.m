figure('Position', [100, 100, 1000, 400]);

% 子图1: 散点图与拟合直线
subplot(1,2,1);
plot(t, h, 'bo', 'MarkerSize', 8, 'DisplayName', '实测数据'); hold on;
t_line = linspace(0, 60, 100);
h_line = a + b * t_line;
plot(t_line, h_line, 'r-', 'LineWidth', 1.5, 'DisplayName', '拟合直线');
yline(8.0, 'g--', 'LineWidth', 1.5, 'DisplayName', '报废标准 h=8.0mm');
plot(t_predict, 8.0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'none', ...
    'LineWidth', 1.5, 'DisplayName', sprintf('预测寿命 (%.1f天)', t_predict));
xlabel('时间 t (天)');
ylabel('磨损量 h (mm)');
title('磨损数据与线性拟合');
legend('Location', 'best');
grid on;

% 子图2: 残差分布
subplot(1,2,2);
stem(t, residuals, 'filled', 'Color', [0.5 0 0.5], 'LineWidth', 1.5);
hold on;
yline(0, 'k--');
xlabel('时间 t (天)');
ylabel('残差 e_i (mm)');
title('残差分布图');
grid on;

sgtitle('衬板磨损寿命回归分析');

% 在命令行输出残差的具体值
fprintf('残差值:\n');
for i = 1:m
    fprintf('  t = %2d 天: e = %.4f mm\n', t(i), residuals(i));
end