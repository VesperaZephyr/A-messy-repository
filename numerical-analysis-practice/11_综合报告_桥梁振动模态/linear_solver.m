% 桥梁静态变形问题 - 直接法(追赶法) vs Gauss-Seidel 迭代法
clear; close all; clc;

L = 10;
c = @(x) 1 + 0.5*sin(x);
f = @(x) sin(pi*x/L);

n_list = [20, 40, 80];
tol = 1e-8;           % 迭代收敛容差
maxit = 10000;        % 最大迭代次数

for idx = 1:length(n_list)
    n = n_list(idx);
    h = L / n;
    x = linspace(0, L, n+1)';    % 全部节点
    xi = x(2:end-1);              % 内部节点
    N = n - 1;                    % 未知数个数
    
    % 构建三对角矩阵 A 和右端 b
    off_value = -1/h^2;
    main_diag = 2/h^2 + c(xi);          % N×1
    lower_diag = [0; off_value * ones(N-1, 1)];
    upper_diag = [off_value * ones(N-1, 1); 0];
    A = spdiags([lower_diag, main_diag, upper_diag], [-1,0,1], N, N);
    b = f(xi);
    
    % 验证对称正定性
    lambda_min = min(eig(full(A)));
    fprintf('n = %d, 最小特征值 = %f  (正定: %d)\n', n, lambda_min, lambda_min > 0);
    
    % ---------- 直接法：追赶法 ----------
    tic;
    a = off_value * ones(N-1, 1);
    d = main_diag;
    c_vec = off_value * ones(N-1, 1);
    u_direct_int = thomas_solver(a, d, c_vec, b);
    t_direct = toc;
    u_direct = [0; u_direct_int; 0];
    
    % ---------- 迭代法：Gauss-Seidel ----------
    % 初始化迭代向量
    u_gs = zeros(N, 1);          % 初始猜测为零向量
    residual_norm = zeros(1,1);  % 用于记录残差（可选）
    
    tic;
    for iter = 1:maxit
        u_old = u_gs;
        
        % Gauss-Seidel 迭代（利用三对角结构）
        % 第一行：x1 = (b1 - a1*u0) / d1  但 u0=0，所以 x1 = b1/d1
        u_gs(1) = (b(1) - off_value * u_gs(2)) / main_diag(1);
        for i = 2:N-1
            % 使用已经更新的 u_gs(i-1) 和旧值 u_gs(i+1)
            u_gs(i) = (b(i) - off_value * u_gs(i-1) - off_value * u_gs(i+1)) / main_diag(i);
        end
        % 最后一行：xN = (bN - aN*u_{N-1}) / dN
        u_gs(N) = (b(N) - off_value * u_gs(N-1)) / main_diag(N);
        
        % 检查收敛性：||u_new - u_old||_inf < tol
        diff = max(abs(u_gs - u_old));
        if diff < tol
            break;
        end
    end
    t_iter = toc;
    
    % 输出迭代信息
    if iter >= maxit
        fprintf('警告: n=%d, Gauss-Seidel 达到最大迭代次数 %d, 未完全收敛\n', n, maxit);
    end
    
    u_iter = [0; u_gs; 0];
    diff_norm = max(abs(u_direct_int - u_gs));
    
    fprintf('n = %2d | 直接法时间: %.6f s | GS时间: %.6f s | GS迭代次数: %4d | 解差异: %.2e\n',...
            n, t_direct, t_iter, iter, diff_norm);
    
    % 绘制两种方法的数值解
    figure;
    plot(x, u_direct, 'b-o', 'LineWidth', 1.5, 'DisplayName', '直接法 (追赶法)');
    hold on;
    plot(x, u_iter, 'r--x', 'LineWidth', 1.2, 'DisplayName', 'Gauss-Seidel迭代');
    xlabel('x');
    ylabel('u(x)');
    title(sprintf('数值解对比, n = %d', n));
    legend('Location', 'best');
    grid on;
    hold off;
end

% ===================== 追赶法（不选主元的三对角LU分解） =====================
function x = thomas_solver(a, d, c, b)
% 求解三对角线性系统，系数矩阵为:
%   diag(a, -1) + diag(d, 0) + diag(c, 1)
% 输入:
%   a : 下对角线 (长度 N-1)
%   d : 主对角线  (长度 N)
%   c : 上对角线 (长度 N-1)
%   b : 右端向量  (长度 N)
% 输出:
%   x : 解向量    (长度 N)

N = length(d);
x = zeros(N, 1);
% 前向消去
for i = 2:N
    w = a(i-1) / d(i-1);
    d(i) = d(i) - w * c(i-1);
    b(i) = b(i) - w * b(i-1);
end
% 回代
x(N) = b(N) / d(N);
for i = N-1:-1:1
    x(i) = (b(i) - c(i) * x(i+1)) / d(i);
end
end
