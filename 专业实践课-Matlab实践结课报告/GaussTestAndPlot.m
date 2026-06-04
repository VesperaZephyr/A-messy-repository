%% Gauss-Seidel 迭代测试脚本
clc; clear; close all;

% --- 1. 参数设置 (与 Jacobi 实验保持一致) ---
n = 100;
A = rand(n) + 100 * eye(n); % 严格对角占优矩阵
b = A(:, 1);                % 使得真解为 [1, 0, ..., 0]'
tol = 1e-12;
maxit = 1000;
x0 = rand(n, 1);

% --- 2. 运行 Gauss-Seidel 迭代 ---
fprintf('正在运行 Gauss-Seidel 迭代...\n');
tic;
[x_gs, k_gs, res_gs] = testgauss(A, b, x0, tol, maxit);
time_gs = toc;

% --- 3. 结果输出 ---
fprintf('\n--- Gauss-Seidel 结果 ---\n');
fprintf('迭代次数: %d\n', k_gs);
fprintf('最终残量: %e\n', res_gs(end));
fprintf('计算耗时: %.4f 秒\n', time_gs);

% --- 4. 绘制残量收敛曲线 ---
figure('Name', 'G-S Iteration Convergence', 'Color', 'w');
semilogy(0:k_gs, res_gs, 'r-s', 'LineWidth', 1.5, 'MarkerSize', 4);
title('Gauss-Seidel 迭代残量收敛曲线');
xlabel('迭代次数 (k)');
ylabel('残量范数 ||b - Ax^{(k)}|| (对数坐标)');
grid on;
legend('Gauss-Seidel Residual');