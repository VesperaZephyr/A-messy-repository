%% Jacobi 迭代测试脚本
clc; clear; close all;

% 1. 定义测试参数 (根据文档要求)
n = 100;
% 构造严格对角占优矩阵，保证 Jacobi 方法收敛
A = rand(n) + 100 * eye(n); 
% 构造右端向量 b，使得精确解为 A 的第一列对应的解 (即 x=[1,0...0])
% 或者简单理解为 b 是由 A 和某个真解构造出来的
b = A(:, 1); 

tol = 1e-12;        % 精度
maxit = 1000;       % 最大迭代次数
x0 = rand(n, 1);    % 随机初值

% 2. 调用 Jacobi 函数
fprintf('正在运行 Jacobi 迭代...\n');
[x, k, res_hist] = testjacobi(A, b, x0, tol, maxit);

% 3. 输出结果
fprintf('--------------------------------\n');
fprintf('迭代结束。\n');
fprintf('迭代次数 k = %d\n', k);
fprintf('最终残量范数 = %e\n', res_hist(end));
fprintf('--------------------------------\n');

% 4. 绘制残量范数随着迭代次数变化的曲线
figure('Name', 'Jacobi Iteration Convergence', 'Color', 'w');

% 使用 semilogy (半对数坐标) 绘图，因为残量通常呈指数下降，
% 在对数坐标下能更清晰地看到收敛趋势（近似直线）。
semilogy(0:k, res_hist, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);

title('Jacobi 迭代残量收敛曲线');
xlabel('迭代次数 (k)');
ylabel('残量范数 ||b - Ax^{(k)}|| (对数坐标)');
grid on;
legend('Jacobi Residual');

% 可以在图中标记出最终点
text(k, res_hist(end), sprintf('  Iter: %d\n  Res: %.2e', k, res_hist(end)), ...
     'VerticalAlignment', 'bottom');