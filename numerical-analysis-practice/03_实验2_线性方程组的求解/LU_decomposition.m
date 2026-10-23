% ========================================================
% LU分解（列主元）求解 Ax = b
% 题目：给定A, b_i = sum_j a_{ij} * j
% 验证残差 ||Ax - b||_2 < 1e-8，记录耗时
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
% 根据题意构造 b
j = (1:n)';               % j = [1;2;3;4;5;6;7]
b = A * j;                % 理论解 x_true = j

%% 2. 调用自定义LU分解求解，并计时
tic;
[L, U, p] = lu_colPivoted(A);  % PA = LU，p为置换向量
% 求解 Ly = Pb
y = forwardSubstitution(L, b(p));
% 求解 Ux = y
x = backwardSubstitution(U, y);
elapsedTime = toc;

%% 3. 结果输出与验证
residual = norm(A * x - b, 2);   % 残差 2-范数

fprintf('================ 求解结果 ================\n');
fprintf('解向量 x :\n');
disp(x);
fprintf('理论解应为 [1;2;3;4;5;6;7]\n');
fprintf('残差 ||Ax - b||_2 = %.4e\n', residual);
fprintf('计算耗时 = %.6f 秒\n', elapsedTime);
if residual < 1e-8
    fprintf('✓ 残差小于 1e-8，解正确。\n');
else
    fprintf('✗ 残差过大，请检查代码！\n');
end

%% ================= 自定义函数 =================

function [L, U, p] = lu_colPivoted(A)
% 列主元LU分解，将A分解为 PA = LU
% 输入：A - n×n 非奇异矩阵
% 输出：L - 单位下三角矩阵 (n×n)
%       U - 上三角矩阵 (n×n)
%       p - 行置换向量 (1×n)，满足 P*A = L*U，其中 P = eye(n)(p,:)

    n = size(A, 1);
    p = 1:n;               % 置换向量，记录行交换
    L = eye(n);            % 初始化为单位矩阵
    U = A;                 % U 初始为 A 的副本，之后逐步消元

    for k = 1:n-1
        % ---- 选列主元 ----
        [~, maxRow] = max(abs(U(k:n, k)));
        maxRow = maxRow + k - 1;   % 转换为在 U 中的绝对行号
        
        if maxRow ~= k
            % 交换 U 的第 k 行与第 maxRow 行
            U([k, maxRow], :) = U([maxRow, k], :);
            % 交换 L 的前 k-1 列（只有这些列有非零元素）
            if k > 1
                L([k, maxRow], 1:k-1) = L([maxRow, k], 1:k-1);
            end
            % 更新置换向量
            p([k, maxRow]) = p([maxRow, k]);
        end
        
        % ---- 高斯消元 ----
        for i = k+1:n
            L(i, k) = U(i, k) / U(k, k);           % 计算乘子，存入 L
            U(i, k:n) = U(i, k:n) - L(i, k) * U(k, k:n);  % 更新 U
        end
    end
    % 确保 U 严格上三角（对角线以下置零，消除浮点误差）
    U = triu(U);
end

function y = forwardSubstitution(L, b)
% 前代法求解下三角方程组 Ly = b (L 为单位下三角)
% 输入：L - n×n 单位下三角矩阵
%       b - n×1 右端向量
% 输出：y - n×1 解向量
    n = length(b);
    y = zeros(n, 1);
    for i = 1:n
        y(i) = b(i) - L(i, 1:i-1) * y(1:i-1);
    end
end

function x = backwardSubstitution(U, y)
% 回代法求解上三角方程组 Ux = y
% 输入：U - n×n 上三角矩阵
%       y - n×1 右端向量
% 输出：x - n×1 解向量
    n = length(y);
    x = zeros(n, 1);
    for i = n:-1:1
        x(i) = (y(i) - U(i, i+1:n) * x(i+1:n)) / U(i, i);
    end
end