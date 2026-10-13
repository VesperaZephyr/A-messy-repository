% 绘图脚本: n=20时 Lagrange插值多项式与真实函数的曲线对比

n = 20;

% 生成绘图用点(避免与节点重合过多, 使用较密集的网格)
x_plot = linspace(-1, 1, 500);

% 计算插值多项式和真实函数值
P_plot = zeros(size(x_plot));
f_plot = zeros(size(x_plot));

for k = 1:length(x_plot)
    P_plot(k) = lagrange_interpolation(n, x_plot(k));
    f_plot(k) = 1 / (1 + 25 * x_plot(k)^2);
end

% 绘制曲线
figure;
plot(x_plot, f_plot, 'b-', 'LineWidth', 2, 'DisplayName', '真实函数 f(x)=1/(1+25x^2)');
hold on;
plot(x_plot, P_plot, 'r--', 'LineWidth', 1.5, 'DisplayName', ['插值多项式 P_{', num2str(n), '}(x)']);

% 标记数据节点
x_nodes = linspace(-1, 1, n+1);
y_nodes = 1 ./ (1 + 25 * x_nodes.^2);
plot(x_nodes, y_nodes, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k', 'DisplayName', '插值节点');

grid on;
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title(['等距节点 Lagrange 插值 (n=', num2str(n), ') 与真实函数对比'], 'FontSize', 14);
legend('Location', 'best');
hold off;

% 由于端点振荡可能很大, 也可单独放大查看中间区域
figure;
plot(x_plot, f_plot, 'b-', 'LineWidth', 2);
hold on;
plot(x_plot, P_plot, 'r--', 'LineWidth', 1.5);
ylim([-1, 2]); % 限制纵轴范围以便观察中部吻合程度
plot(x_nodes, y_nodes, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
grid on;
xlabel('x', 'FontSize', 12);
ylabel('y', 'FontSize', 12);
title(['中部区域放大 (n=', num2str(n), ')'], 'FontSize', 14);
legend('真实函数', '插值多项式', '插值节点');
hold off;