%% 线性方程组 Ax = b
% A 为 7x7 矩阵, b_i = sum_{j=1}^7 a_{ij} * j

clear; clc;

% 构造矩阵 A
A = [11, 1, 2, 3, 1, 2, 3;
      1,11, 3, 1, 2, 3, 1;
      2, 3,11, 2, 3, 1, 2;
      3, 1, 2,11, 1, 2, 3;
      1, 2, 3, 1,11, 3, 1;
      2, 3, 1, 2, 3,11, 2;
      3, 1, 2, 3, 1, 2,11];

% 构造右端项 b
n = size(A, 1);
b = zeros(n, 1);
for i = 1:n
    for j = 1:n
        b(i) = b(i) + A(i, j) * j;
    end
end

% 精确解(用于验证)
x_exact = (1:n)';

% 参数设置
tol = 1e-8;                % 误差容限
maxIter = 1000;            % 最大迭代次数

%% Jacobi 迭代法
fprintf('Jacobi 迭代法:\n');
x0 = zeros(n, 1);          % 初始向量

D = diag(diag(A));         % 对角部分
L = tril(A, -1);           % 严格下三角
U = triu(A, 1);            % 严格上三角

x = x0;
tic;  % 开始计时
for k = 1:maxIter
    x_old = x;
    % Jacobi 迭代公式: x_new = D^{-1} * (b - (L+U)*x_old)
    x = D \ (b - (L + U) * x_old);
    
    % 计算相邻两次迭代的 2-范数误差
    err = norm(x - x_old, 2);
    if err < tol
        elapsed = toc;  % 停止计时
        fprintf('  收敛于第 %d 步, 误差 = %.2e, 耗时 = %.4f 秒\n', k, err, elapsed);
        break;
    end
    if k == maxIter
        elapsed = toc;
        fprintf('  达到最大迭代次数 %d, 未收敛, 耗时 = %.4f 秒\n', maxIter, elapsed);
    end
end
fprintf('  数值解: \n'); disp(x');
fprintf('  与精确解的差的 2-范数: %.2e\n\n', norm(x - x_exact, 2));

%% Gauss-Seidel 迭代法
fprintf('Gauss-Seidel 迭代法:\n');
x = x0;
tic;  % 开始计时
for k = 1:maxIter
    x_old = x;
    % Gauss-Seidel 迭代：逐分量更新
    for i = 1:n
        sigma = 0;
        for j = 1:i-1
            sigma = sigma + A(i, j) * x(j);   % 已更新的部分
        end
        for j = i+1:n
            sigma = sigma + A(i, j) * x_old(j); % 未更新的部分
        end
        x(i) = (b(i) - sigma) / A(i, i);
    end
    
    err = norm(x - x_old, 2);
    if err < tol
        elapsed = toc;  % 停止计时
        fprintf('  收敛于第 %d 步, 误差 = %.2e, 耗时 = %.4f 秒\n', k, err, elapsed);
        break;
    end
    if k == maxIter
        elapsed = toc;
        fprintf('  达到最大迭代次数 %d, 未收敛, 耗时 = %.4f 秒\n', maxIter, elapsed);
    end
end
fprintf('  数值解: \n'); disp(x');
fprintf('  与精确解的差的 2-范数: %.2e\n', norm(x - x_exact, 2));