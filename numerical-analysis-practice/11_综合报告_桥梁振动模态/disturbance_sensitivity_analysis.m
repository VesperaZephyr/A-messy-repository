%% 线性系统右端项扰动敏感性分析 (n=40, delta=1e-6)
clear; clc; close all;

% ==================== 1. 构建原始方程组 A*u = b ====================
L = 10; n = 40; h = L / n;
x_int = linspace(h, L-h, n-1)';          % 内部节点列向量
c_func = @(x) 1 + 0.5*sin(x);
f_func = @(x) sin(pi*x/L);

off_val = -1/h^2;
main_diag = 2/h^2 + c_func(x_int);
lower = [0; off_val*ones(n-2,1)];
upper = [off_val*ones(n-2,1); 0];
A = spdiags([lower, main_diag, upper], [-1,0,1], n-1, n-1);
b = f_func(x_int);

% 求解基准解 u
u = A \ b;

% ==================== 2. 添加随机相对扰动 ====================
delta = 1e-6;
rng(42);                                  % 固定种子保证结果可复现
epsilon = delta * randn(size(b));         % epsilon_i ~ N(0, delta^2)
b_tilde = b .* (1 + epsilon);             % 逐分量相对扰动

% 求解扰动后的解 u_tilde
u_tilde = A \ b_tilde;

% ==================== 3. 计算两个相对误差 ====================
% 分子：解的绝对误差范数
numerator_u = norm(u_tilde - u, 2);
% 分母：基准解的范数
denominator_u = norm(u, 2);
% 题目要求的第一个量：解的相对误差
rel_err_u = numerator_u / denominator_u;  

% 分子：右端项的绝对扰动范数
numerator_b = norm(b_tilde - b, 2);
% 分母：原始右端项的范数
denominator_b = norm(b, 2);
% 右端项的相对扰动
rel_err_b = numerator_b / denominator_b;  

% ==================== 4. 输出与条件数关系验证 ====================
cond_A = cond(full(A));
actual_amplification = rel_err_u / rel_err_b;

fprintf('====== 扰动敏感性分析结果 ======\n');
fprintf('矩阵条件数 cond(A)       = %.4e\n', cond_A);
fprintf('----------------------------------\n');
fprintf('||b_tilde - b||_2 / ||b||_2 = %.6e  (右端项相对扰动)\n', rel_err_b);
fprintf('||u_tilde - u||_2 / ||u||_2 = %.6e  (解的相对误差)\n', rel_err_u);
fprintf('----------------------------------\n');
fprintf('实际放大倍数              = %.4f\n', actual_amplification);
fprintf('理论最坏上界 cond(A)      = %.4f\n', cond_A);
fprintf('不等式验证: %.4f <= %.4f ? %s\n', ...
        actual_amplification, cond_A, ...
        string(actual_amplification <= cond_A));
