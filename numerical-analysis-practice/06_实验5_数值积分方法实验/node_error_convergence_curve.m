clear; clc; close all;

% 被积函数与高精度参考值
f = @(x) exp(-5*x.^2);
a = 0;  b = 3;
I_exact = integral(f, a, b, 'RelTol',1e-12, 'AbsTol',1e-14);

% 试验的子区间数（逐次加倍）
n_sub = [10, 20, 40, 80, 160];

% 预分配误差数组
err_mid   = zeros(size(n_sub));
err_trap  = zeros(size(n_sub));
err_simp  = zeros(size(n_sub));
err_gauss2 = zeros(size(n_sub));

for i = 1:length(n_sub)
    n = n_sub(i);
    h = (b-a)/n;
    
    % ---- 复合中点矩形法 ----
    x_mid = linspace(a + h/2, b - h/2, n);
    I_mid = h * sum(f(x_mid));
    err_mid(i) = abs(I_mid - I_exact);
    
    % ---- 复合梯形法 ----
    x_trap = linspace(a, b, n+1);
    I_trap = h * ( (f(a)+f(b))/2 + sum(f(x_trap(2:end-1))) );
    err_trap(i) = abs(I_trap - I_exact);
    
    % ---- 复合 Simpson 1/3 法（要求 n 为偶数）----
    if mod(n,2) ~= 0
        n = n+1;
    end
    x_simp = linspace(a, b, n+1);
    fx_simp = f(x_simp);
    I_simp = h/3 * ( fx_simp(1) + fx_simp(end) ...
                     + 4*sum(fx_simp(2:2:end-1)) ...
                     + 2*sum(fx_simp(3:2:end-2)) );
    err_simp(i) = abs(I_simp - I_exact);
    
    % ---- 复合 2 点 Gauss-Legendre 法 ----
    t_g2 = [-1/sqrt(3), 1/sqrt(3)];
    w_g2 = [1, 1];
    x_edges = linspace(a, b, n+1);
    I_gl2 = 0;
    for j = 1:n
        xL = x_edges(j);
        xR = x_edges(j+1);
        mid = (xL + xR)/2;
        half = (xR - xL)/2;
        x_nodes = mid + half * t_g2;
        I_gl2 = I_gl2 + half * sum(w_g2 .* f(x_nodes));
    end
    err_gauss2(i) = abs(I_gl2 - I_exact);
end

% 各方法对应的实际函数求值次数（节点数）
N_mid   = n_sub;
N_trap  = n_sub + 1;
N_simp  = n_sub + 1;
N_gauss = 2 * n_sub;

% 绘制误差-节点数收敛曲线
figure('Color','white');
loglog(N_mid, err_mid, 'o-', 'LineWidth', 1.5, 'MarkerSize', 7);
hold on;
loglog(N_trap, err_trap, 's-', 'LineWidth', 1.5, 'MarkerSize', 7);
loglog(N_simp, err_simp, 'd-', 'LineWidth', 1.5, 'MarkerSize', 7);
loglog(N_gauss, err_gauss2, '^-', 'LineWidth', 1.5, 'MarkerSize', 7);

% 理论收敛阶参考线（斜率 -2 和 -4）
N_ref = [10, 200];
y0_2 = 1e-2 * (N_ref/10).^(-2);
y0_4 = 1e-4 * (N_ref/10).^(-4);
loglog(N_ref, y0_2, 'k--', 'LineWidth', 1);
loglog(N_ref, y0_4, 'k-.', 'LineWidth', 1);

% 图形标注（使用 tex 解释器，避免 LaTeX 问题）
xlabel('节点数 N', 'FontSize', 12);
ylabel('绝对误差', 'FontSize', 12);
title('复合求积方法误差--节点数收敛曲线', 'FontSize', 14);
legend('中点矩形法', '梯形法', 'Simpson 1/3', '复合 Gauss 2 点', ...
       'O(N^{-2}) 参考线', 'O(N^{-4}) 参考线', ...
       'Location','southwest');
grid on;
set(gca, 'FontSize', 11);
hold off;

% 输出数值
fprintf('节点数序列:\n');
fprintf('中点: %s\n', mat2str(N_mid));
fprintf('梯形: %s\n', mat2str(N_trap));
fprintf('Simpson: %s\n', mat2str(N_simp));
fprintf('Gauss: %s\n', mat2str(N_gauss));
fprintf('\n误差:\n');
disp('中点误差:'); disp(err_mid);
disp('梯形误差:'); disp(err_trap);
disp('Simpson误差:'); disp(err_simp);
disp('Gauss误差:'); disp(err_gauss2);
