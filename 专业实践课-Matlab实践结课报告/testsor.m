function [x, k, res_hist] = testsor(A, b, x0, w, tol, maxit)
    % TESTSOR SOR迭代法求解线性方程组
    % 输入:
    %   A: 系数矩阵
    %   b: 右端向量
    %   x0: 迭代初值
    %   w: 松弛因子 (omega), 通常在 (0, 2) 之间
    %   tol: 精度要求
    %   maxit: 最大迭代次数
    % 输出:
    %   x: 近似解
    %   k: 迭代次数
    %   res_hist: 残量历史记录

    n = length(b);
    x = x0;
    k = 0;
    
    % 计算初始残量
    r = norm(b - A*x);
    res_hist = zeros(maxit+1, 1);
    res_hist(1) = r;
    
    while k < maxit && r > tol
        for i = 1:n
            sigma = 0;
            % 计算 Gauss-Seidel 部分的 sigma
            % 利用已更新的 x(j) (j<i) 和旧的 x(j) (j>i)
            for j = 1:n
                if j ~= i
                    sigma = sigma + A(i, j) * x(j);
                end
            end
            
            % Gauss-Seidel 的临时估计值
            x_gs = (b(i) - sigma) / A(i, i);
            
            % SOR 更新公式: 加权平均
            x(i) = (1 - w) * x(i) + w * x_gs;
        end
        
        k = k + 1;
        
        % 计算残量
        r = norm(b - A*x);
        res_hist(k+1) = r;
    end
    
    res_hist = res_hist(1:k+1); % 截断
    
    if k == maxit && r > tol
        fprintf('警告: SOR (w=%.2f) 在 %d 次迭代内未收敛。\n', w, maxit);
    end
end