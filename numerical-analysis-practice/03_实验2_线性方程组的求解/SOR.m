% ========================================================
% SOR迭代法求解 Ax = b, 寻找最优松弛因子
% ========================================================
clear; clc;

%% 1. 构造矩阵 A 和右端项 b
A = [
    11   1   2   3   1   2   3;
     1  11   3   1   2   3   1;
     2   3  11   2   3   1   2;
     3   1   2  11   1   2   3;
     1   2   3   1  11   3   1;
     2   3   1   2   3  11   2;
     3   1   2   3   1   2  11
];
n = size(A, 1);
j = (1:n)';                  % 列向量 [1;2;3;4;5;6;7]
b = A * j;                   % 理论解 x_true = j

%% 2. 参数设置
tol = 1e-8;
max_iter = 1000;

%% 3. 粗搜索 —— 较大步长试算
omega_coarse = [0.8, 1.0, 1.2, 1.4, 1.6, 1.8];
fprintf('===== 粗搜索：SOR迭代法收敛测试 =====\n');
fprintf('omega\t迭代次数\t耗时(秒)\t\t最终残差\n');
iter_coarse = zeros(size(omega_coarse));
time_coarse = zeros(size(omega_coarse));
res_coarse  = zeros(size(omega_coarse));

for k = 1:length(omega_coarse)
    omega = omega_coarse(k);
    [x, iter, res, t] = sor_timed(A, b, omega, tol, max_iter);
    iter_coarse(k) = iter;
    time_coarse(k) = t;
    res_coarse(k) = res;
    fprintf('%.1f\t%d\t\t%.6f\t%.2e\n', omega, iter, t, res);
end

% 找出粗搜索最优松弛因子（迭代次数最少；若平局，选 omega 更接近 1 的）
[min_iter, idx_opt] = min(iter_coarse);
omega_opt0 = omega_coarse(idx_opt);
fprintf('\n粗搜索最优松弛因子 ω_opt0 = %.1f，迭代次数 = %d\n\n', omega_opt0, min_iter);

%% 4. 精细搜索 —— 在 ω_opt0 附近减小步长
step_fine = 0.05;
margin = 0.12;  % 搜索宽度
omega_fine = omega_opt0 - margin : step_fine : omega_opt0 + margin;
% 排除已经测试过的 ω 值（避免重复）
omega_fine = setdiff(omega_fine, omega_coarse);

if isempty(omega_fine)
    fprintf('附近无新测试点，最优松弛因子即粗搜结果。\n');
    omega_opt = omega_opt0;
    iter_opt = min_iter;
else
    fprintf('===== 精细搜索：ω_opt0 附近测试 =====\n');
    fprintf('omega\t迭代次数\t耗时(秒)\t\t最终残差\n');
    iter_fine = zeros(size(omega_fine));
    time_fine = zeros(size(omega_fine));
    res_fine  = zeros(size(omega_fine));

    for k = 1:length(omega_fine)
        omega = omega_fine(k);
        [x, iter, res, t] = sor_timed(A, b, omega, tol, max_iter);
        iter_fine(k) = iter;
        time_fine(k) = t;
        res_fine(k) = res;
        fprintf('%.2f\t%d\t\t%.6f\t%.2e\n', omega, iter, t, res);
    end

    % 综合所有结果（粗搜+精细）找出最终最优
    all_omega = [omega_coarse, omega_fine];
    all_iter  = [iter_coarse, iter_fine];
    [final_iter, idx_final] = min(all_iter);
    omega_opt = all_omega(idx_final);
    fprintf('\n精细搜索后全局最优松弛因子 ω_opt = %.2f，迭代次数 = %d\n', omega_opt, final_iter);
end

%% =================== SOR 迭代函数 ===================
function [x, iter, res, elapsed] = sor_timed(A, b, omega, tol, max_iter)
% 带计时的逐次超松弛迭代法 (SOR)
% 输出：x - 近似解, iter - 实际迭代次数, res - 最终残差, elapsed - 耗时(秒)
    n = length(b);
    x = zeros(n, 1);
    tic;   % 开始计时
    for iter = 1:max_iter
        x_old = x;
        for i = 1:n
            sigma = A(i, 1:i-1) * x(1:i-1) + A(i, i+1:n) * x_old(i+1:n);
            x(i) = (1 - omega) * x_old(i) + omega * (b(i) - sigma) / A(i, i);
        end
        r = A * x - b;
        if norm(r, 2) < tol
            res = norm(r, 2);
            elapsed = toc;   % 停止计时
            return;
        end
    end
    res = norm(A * x - b, 2);
    elapsed = toc;
end