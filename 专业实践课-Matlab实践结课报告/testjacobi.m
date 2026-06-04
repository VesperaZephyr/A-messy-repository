function [x, k, res_hist] = testjacobi(A, b, x0, tol, maxit)
    % TESTJACOBI 雅克比迭代法求解线性方程组
    % 输入:
    %   A: 系数矩阵
    %   b: 右端向量
    %   x0: 迭代初值
    %   tol: 近似解的精度 (残量范数容差)
    %   maxit: 允许的最大迭代次数
    % 输出:
    %   x: 近似解
    %   k: 实际迭代次数
    %   res_hist: 每次迭代后的残量范数历史 (用于绘图)

    n = length(b);
    x = x0;
    k = 0;
    
    % 计算初始残量
    r = norm(b - A*x);
    res_hist = zeros(maxit+1, 1); % 预分配内存
    res_hist(1) = r; % 记录初始残量
    
    % 开始迭代
    while k < maxit && r > tol
        x_new = zeros(n, 1);
        
        % 对应文档中的 Algorithm 1
        for i = 1:n
            sigma = 0;
            for j = 1:n
                if j ~= i
                    sigma = sigma + A(i, j) * x(j);
                end
            end
            % Jacobi 更新公式: x_i = (b_i - sum(a_ij * x_j)) / a_ii
            x_new(i) = (b(i) - sigma) / A(i, i);
        end
        
        % 更新 x
        x = x_new;
        k = k + 1;
        
        % 计算新的残量范数
        r = norm(b - A*x);
        res_hist(k+1) = r;
    end
    
    % 截断未使用的预分配空间
    res_hist = res_hist(1:k+1);
    
    % 检查是否收敛
    if k == maxit && r > tol
        fprintf('警告: Jacobi 迭代在达到最大次数 %d 时仍未收敛 (残量: %e)\n', maxit, r);
    end
end