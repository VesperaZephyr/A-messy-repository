% ========================================================
% 优化收敛曲线绘制：Jacobi、Gauss-Seidel、SOR(最优)
% ========================================================
clear; clc;

%% 1. 构造矩阵和右端项
A = [
    11   1   2   3   1   2   3;
     1  11   3   1   2   3   1;
     2   3  11   2   3   1   2;
     3   1   2  11   1   2   3;
     1   2   3   1  11   3   1;
     2   3   1   2   3  11   2;
     3   1   2   3   1   2  11
];
n = size(A,1);
x_star = (1:n)';
b = A * x_star;

%% 2. 参数设置
tol = 1e-8;
max_iter = 200;

%% 3. 运行三种迭代法并记录误差
[err_J, iter_J] = Jacobi_error(A, b, x_star, tol, max_iter);
[err_GS, iter_GS] = GS_error(A, b, x_star, tol, max_iter);
omega_opt = 1.0;
[err_SOR, iter_SOR] = SOR_error(A, b, x_star, omega_opt, tol, max_iter);

%% 4. 优化绘图
figure('Position', [100, 100, 600, 450]);
% 为清晰展示，每5个点显示一个标记
mark_every = 5;

semilogy(0:iter_J, err_J, 'ro-', 'LineWidth', 1.5, ...
         'MarkerSize', 6, 'MarkerFaceColor', 'r', ...
         'MarkerIndices', 1:mark_every:iter_J+1);
hold on;
semilogy(0:iter_GS, err_GS, 'bs-', 'LineWidth', 1.5, ...
         'MarkerSize', 6, 'MarkerFaceColor', 'b', ...
         'MarkerIndices', 1:mark_every:iter_GS+1);
semilogy(0:iter_SOR, err_SOR, 'g^-', 'LineWidth', 1.5, ...
         'MarkerSize', 6, 'MarkerFaceColor', 'g', ...
         'MarkerIndices', 1:mark_every:iter_SOR+1);
hold off;

% 限制横轴范围，聚焦收敛主要区间
xlim([0, 35]);  % Jacobi需33次，GS/SOR需18次，统一显示前35步
ylim([1e-10, 1e1]);
xlabel('迭代次数 k');
ylabel('误差 || x^{(k)} - x^* ||_2');
title('三种迭代法收敛曲线对比 (每5步标记)');
legend('Jacobi', 'Gauss-Seidel', ['SOR (\omega=', num2str(omega_opt), ')'], ...
       'Location', 'northeast');
grid on;

% 添加水平辅助线，标注容限
yline(tol, 'k--', 'LineWidth', 1);
text(1, tol*5, ['容限 10^{-8}'], 'FontSize', 9, 'Color', 'k');

%% ================= 子函数 =================
function [err_log, iter] = Jacobi_error(A, b, x_star, tol, max_iter)
    n = length(b);
    x = zeros(n,1);
    err_log = zeros(max_iter+1,1);
    err_log(1) = norm(x - x_star, 2);
    for iter = 1:max_iter
        x_new = zeros(n,1);
        for i = 1:n
            x_new(i) = (b(i) - A(i,[1:i-1,i+1:n])*x([1:i-1,i+1:n]))/A(i,i);
        end
        x = x_new;
        err = norm(x - x_star, 2);
        err_log(iter+1) = err;
        if err < tol
            err_log = err_log(1:iter+1);
            return;
        end
    end
end

function [err_log, iter] = GS_error(A, b, x_star, tol, max_iter)
    n = length(b);
    x = zeros(n,1);
    err_log = zeros(max_iter+1,1);
    err_log(1) = norm(x - x_star, 2);
    for iter = 1:max_iter
        for i = 1:n
            sigma = A(i,1:i-1)*x(1:i-1) + A(i,i+1:n)*x(i+1:n);
            x(i) = (b(i) - sigma)/A(i,i);
        end
        err = norm(x - x_star, 2);
        err_log(iter+1) = err;
        if err < tol
            err_log = err_log(1:iter+1);
            return;
        end
    end
end

function [err_log, iter] = SOR_error(A, b, x_star, omega, tol, max_iter)
    n = length(b);
    x = zeros(n,1);
    err_log = zeros(max_iter+1,1);
    err_log(1) = norm(x - x_star, 2);
    for iter = 1:max_iter
        x_old = x;
        for i = 1:n
            sigma = A(i,1:i-1)*x(1:i-1) + A(i,i+1:n)*x_old(i+1:n);
            x(i) = (1-omega)*x_old(i) + omega*(b(i)-sigma)/A(i,i);
        end
        err = norm(x - x_star, 2);
        err_log(iter+1) = err;
        if err < tol
            err_log = err_log(1:iter+1);
            return;
        end
    end
end