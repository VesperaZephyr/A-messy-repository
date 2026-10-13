n = 20;
x_plot = linspace(-1, 1, 500);
f_true = 1 ./ (1 + 25 * x_plot.^2);

% 等距节点插值
P_equi = lagrange_interpolation(n, x_plot);  % 之前定义的等距节点函数

% 切比雪夫节点插值
P_cheb = lagrange_interpolation_chebyshev(n, x_plot);

figure;
plot(x_plot, f_true, 'k-', 'LineWidth', 2); hold on;
plot(x_plot, P_equi, 'b--', 'LineWidth', 1.2);
plot(x_plot, P_cheb, 'r-', 'LineWidth', 1.2);
x_nodes_equi = linspace(-1, 1, n+1);
x_nodes_cheb = cos((0:n)*pi/n);
plot(x_nodes_equi, 1./(1+25*x_nodes_equi.^2), 'bo');
plot(x_nodes_cheb, 1./(1+25*x_nodes_cheb.^2), 'rs');
legend('f(x)', '等距节点插值', '切比雪夫节点插值', '等距节点', '切比雪夫节点');
title('等距节点 vs 切比雪夫节点插值 (n=20)');
grid on;
ylim([-2, 3]);