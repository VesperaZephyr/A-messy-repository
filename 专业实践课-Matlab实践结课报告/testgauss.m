function [x, k, res_hist] = testgauss(A, b, x0, tol, maxit)
    % TESTGAUSS 高斯-赛德尔迭代法求解线性方程组
    % 输入:
    %   A: 系数矩阵
    %   b: 右端向量
    %   x0: 迭代初值
    %   tol: 近似解的精度 (残量范数容差)
    %   maxit: 允许的最大迭代次数
    % 输出:
    %   x: 近似解
    %   k: 实际迭代次数
    %   res_hist: 每次迭代后的残量范数历史

    n = length(b);
    x = x0;
    k = 0;
    
    % 计算初始残量
    r = norm(b - A*x);
    res_hist = zeros(maxit+1, 1);
    res_hist(1) = r;
    
    while k < maxit && r > tol
        % 注意：G-S 迭代的一个特点是可以直接在原向量 x 上进行更新，
        % 因为计算 x_i^{(k+1)} 时需要用到最新的 x_1...x_{i-1}
        
        for i = 1:n
            sigma = 0;
            
            % 第一部分求和：j < i (使用已经更新过的 x 值)
            for j = 1:i-1
                sigma = sigma + A(i, j) * x(j);
            end
            
            % 第二部分求和：j > i (使用旧的 x 值)
            for j = i+1:n
                sigma = sigma + A(i, j) * x(j);
            end
            
            % 更新 x(i)
            x(i) = (b(i) - sigma) / A(i, i);
        end
        
        k = k + 1;
        
        % 计算残量
        r = norm(b - A*x);
        res_hist(k+1) = r;
    end
    
    res_hist = res_hist(1:k+1); % 截断多余空间
    
    if k == maxit && r > tol
        fprintf('警告: G-S 迭代在达到最大次数 %d 时仍未收敛 (残量: %e)\n', maxit, r);
    end
end