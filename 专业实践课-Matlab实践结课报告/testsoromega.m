%% SOR 迭代测试与分析脚本
clc; clear; close all;

% --- 1. 初始化参数 ---
n = 100;
A = rand(n) + 100 * eye(n); % 严格对角占优矩阵
b = A(:, 1);                % 真解对应第一列
tol = 1e-12;
maxit = 1000;
x0 = rand(n, 1);

% --- 2. 单次测试 (例如 w = 1.2) ---
w_test = 1.2;
fprintf('正在运行 SOR 迭代 (w=%.2f)...\n', w_test);
[x_sor, k_sor, res_sor] = testsor(A, b, x0, w_test, tol, maxit);

fprintf('SOR (w=%.2f) 迭代次数: %d\n', w_test, k_sor);
fprintf('最终残量: %e\n', res_sor(end));

% 绘制单次运行的收敛曲线
figure('Name', 'SOR Convergence', 'Color', 'w');
semilogy(0:k_sor, res_sor, 'm-^', 'LineWidth', 1.5, 'MarkerSize', 4);
title(['SOR 迭代收敛曲线 (\omega = ', num2str(w_test), ')']);
xlabel('迭代次数 (k)');
ylabel('残量范数 (对数坐标)');
grid on;

% --- 3. 测试不同的 w 对收敛次数 k 的影响 ---
fprintf('\n正在分析不同 w 对收敛速度的影响...\n');
w_values = 0.1:0.05:1.9; % 测试范围 (0, 2)
k_values = zeros(size(w_values));

for i = 1:length(w_values)
    w = w_values(i);
    [~, k, ~] = testsor(A, b, x0, w, tol, maxit);
    k_values(i) = k;
end

% 绘制 w 与 k 的关系图
figure('Name', 'Optimal Omega Analysis', 'Color', 'w');
plot(w_values, k_values, 'b-o', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
title('松弛因子 \omega 对 SOR 迭代次数的影响');
xlabel('松弛因子 \omega');
ylabel('达到收敛所需的迭代次数 k');
grid on;

% 找到最佳 w
[min_k, min_idx] = min(k_values);
best_w = w_values(min_idx);
text(best_w, min_k, sprintf('  最佳 \\omega \\approx %.2f\n  k = %d', best_w, min_k), ...
     'VerticalAlignment', 'bottom', 'FontWeight', 'bold');