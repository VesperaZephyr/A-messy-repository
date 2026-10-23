%% MATLAB Project: Best Square Approximation (Chebyshev Weight)
% Targets: 
%   1. f(x) = ln(1+x^2)
%   2. f(x) = cos(x)
% Domain: [-1, 1]
% Weight: rho(x) = 1/sqrt(1-x^2)
% Method: Chebyshev Series Expansion (Lecture Notes p.74)
% Order: n = 3

clc; clear; close all;

%% 1. 定义通用参数
max_n = 3;
x_grid = linspace(-1, 1, 1000); % 绘图网格

% 定义符号变量和切比雪夫多项式
syms x;
T = cell(max_n + 1, 1);
T{1} = sym(1);       % T_0
T{2} = x;            % T_1
for k = 2:max_n
    T{k+1} = 2*x*T{k} - T{k-1}; 
end

%% 2. 定义目标函数集
funcs_sym = {log(1+x^2), cos(x)};
funcs_h   = {@(x) log(1+x.^2), @(x) cos(x)};
titles    = {'f(x) = ln(1+x^2)', 'f(x) = cos(x)'};

%% 3. 循环处理每个函数
for f_idx = 1:2
    f_sym = funcs_sym{f_idx};
    f_fun = funcs_h{f_idx};
    name = titles{f_idx};
    
    fprintf('========================================\n');
    fprintf('正在处理函数: %s\n', name);
    
    % --- 计算切比雪夫系数 c_k ---
    % 公式: c_k = (2/pi) * int_0^pi f(cos(theta)) * cos(k*theta) d_theta
    c = zeros(max_n + 1, 1);
    
    for k = 0:max_n
        % 使用代换 x = cos(t) 进行积分
        integrand = subs(f_sym, x, cos(sym('t'))) * cos(k*sym('t'));
        val = double(int(integrand, sym('t'), 0, pi));
        
        c(k+1) = (2 / pi) * val;
        fprintf('  c_%d = %.6f\n', k, c(k+1));
    end
    
    % --- 构造最佳平方逼近多项式 S_n^*(x) ---
    % 公式: S_n^*(x) = c_0/2 * T_0(x) + sum_{k=1}^n c_k * T_k(x)
    S_star = (c(1) / 2) * T{1};
    for k = 1:max_n
        S_star = S_star + c(k+1) * T{k+1};
    end
    
    % 简化并显示多项式
    % 使用 vpa 保留有效数字，expand 展开成标准多项式形式
    S_poly = vpa(expand(S_star), 5);
    fprintf('  >> S_3^*(x) = %s\n', char(S_poly));
    
    % --- 绘图与误差分析 ---
    S_fun = matlabFunction(S_star);
    
    % 计算逼近值 (容错处理)
    try
        y_approx = S_fun(x_grid);
    catch
        y_approx = ones(size(x_grid)) * double(S_star);
    end
    y_true = f_fun(x_grid);
    
    err = y_true - y_approx;
    max_err = max(abs(err));
    fprintf('  >> Max Error ||f - S_3^*||_inf = %.5e\n', max_err);
    
    % 绘图
    figure('Name', ['Best Square Approx: ' name], 'Color', 'w');
    
    subplot(2, 1, 1);
    plot(x_grid, y_true, 'k-', 'LineWidth', 2); hold on;
    plot(x_grid, y_approx, 'r--', 'LineWidth', 1.5);
    title([name ' 及其最佳平方逼近 S_3^*(x)']);
    legend('True f(x)', 'Approx S_3^*(x)', 'Location', 'best');
    grid on; xlabel('x'); ylabel('y');
    
    subplot(2, 1, 2);
    plot(x_grid, err, 'b-', 'LineWidth', 1.5);
    yline(0, 'k-');
    title(['误差曲线 (Max Error: ' sprintf('%.2e', max_err) ')']);
    grid on; xlabel('x'); ylabel('Error');
    xlim([-1, 1]);
end