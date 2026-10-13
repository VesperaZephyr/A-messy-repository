clear; clc;
f = @(x) exp(-5*x);
a = 0; b = 3;
I_exact = integral(f, a, b, 'RelTol',1e-12, 'AbsTol',1e-14);
fprintf('高精度参考值 = %.12f\n\n', I_exact);

% 选择等分数
ns = [10, 20, 50, 100];
fprintf('节点数  梯形法误差        Simpson误差       梯形法时间(s)   Simpson时间(s)  收敛阶估计\n');
fprintf('----------------------------------------------------------------------------------------\n');

err_trap_prev = 0;
err_simp_prev = 0;
n_prev = 0; 

for i = 1:length(ns)
    n = ns(i);
    if mod(n,2)~=0, n=n+1; end  % 确保 Simpson 可用
    h = (b-a)/n;
    x = linspace(a, b, n+1);
    fx = f(x);
    
    % 梯形法（计时）
    tic;
    I_trap = h * ( (fx(1)+fx(end))/2 + sum(fx(2:end-1)) );
    t_trap = toc;
    err_trap = abs(I_trap - I_exact);
    
    % Simpson 1/3 复合公式（计时）
    tic;
    I_simp = h/3 * ( fx(1) + fx(end) ...
                   + 4*sum(fx(2:2:end-1)) + 2*sum(fx(3:2:end-2)) );
    t_simp = toc;
    err_simp = abs(I_simp - I_exact);
    
    % 收敛阶估计(对 Simpson)
    if i > 1
        p_simp = log(err_simp_prev / err_simp) / log(n / n_prev);
        fprintf(' %3d   %12.6e   %12.6e   %12.6f   %12.6f   %.2f\n', ...
            n+1, err_trap, err_simp, t_trap, t_simp, p_simp);
    else
        fprintf(' %3d   %12.6e   %12.6e   %12.6f   %12.6f\n', ...
            n+1, err_trap, err_simp, t_trap, t_simp);
    end
    
    % 更新 previous 变量
    err_trap_prev = err_trap;
    err_simp_prev = err_simp;
    n_prev = n; % 保存当前的 n 用于下一次计算
end