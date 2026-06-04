%% MATLAB Project: Lagrange Interpolation with Chebyshev Nodes
% Target: f(x) = cos(x) and f(x) = ln(1+x^2) on [-1, 1]
% Method: Lagrange Interpolation using Roots of T_{n+1}(x)
% Order: n = 3 (Requires 4 nodes)

clc; clear; close all;

%% 1. 定义参数
syms x;
funcs_h   = {@(x) cos(x), @(x) log(1+x.^2)};
titles    = {'f(x) = cos(x)', 'f(x) = ln(1+x^2)'};
max_n = 3; % n=3, 对应4个切比雪夫节点

% 绘图网格
x_grid = linspace(-1, 1, 1000);

%% 2. 循环计算
for f_idx = 1:2
    f_fun = funcs_h{f_idx};
    name = titles{f_idx};
    
    fprintf('========================================\n');
    fprintf('正在处理函数: %s\n', name);
    
    %% --- 计算切比雪夫节点 ---
    % 节点公式: x_k = cos((2k-1)*pi / (2*(n+1)))
    N_nodes = max_n + 1; 
    k_idx = 1:N_nodes;
    nodes = cos((2*k_idx - 1) * pi / (2 * N_nodes));
    
    % 计算节点处的函数值
    y_nodes = f_fun(nodes);
    
    fprintf('  切比雪夫节点 (n=3, N=4):\n');
    fprintf('    x = [%.5f, %.5f, %.5f, %.5f]\n', nodes);
    fprintf('    y = [%.5f, %.5f, %.5f, %.5f]\n', y_nodes);
    
    %% --- 构造拉格朗日插值多项式 ---
    % 使用 polyfit 进行多项式拟合
    p_L = polyfit(nodes, y_nodes, max_n);
    
    % 转换为符号表达式方便显示
    L_sym = vpa(poly2sym(p_L, x), 5);
    fprintf('  >> L_3(x) = %s\n', char(L_sym));
    
    % 计算插值结果
    y_L = polyval(p_L, x_grid);
    y_true = f_fun(x_grid);
    
    %% --- 误差分析 ---
    err_L = y_true - y_L;
    max_err = max(abs(err_L));
    fprintf('  >> Max Error ||f - L_3||_inf = %.5e\n', max_err);
    
    %% --- 绘图 ---
    figure('Name', ['Lagrange (Chebyshev): ' name], 'Color', 'w');
    
    % 上图: 拟合效果
    subplot(2, 1, 1);
    plot(x_grid, y_true, 'k-', 'LineWidth', 2); hold on;
    plot(x_grid, y_L, 'r--', 'LineWidth', 1.5);
    plot(nodes, y_nodes, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 6);
    title([name ' : Lagrange Interpolation (Chebyshev Nodes)']);
    legend('True f(x)', 'Interpolation L_3(x)', 'Nodes');
    grid on; xlabel('x'); ylabel('y');
    
    % 下图: 误差曲线
    subplot(2, 1, 2);
    plot(x_grid, err_L, 'b-', 'LineWidth', 1.5);
    yline(0, 'k-');
    title(['Error Curve (Max Error: ' sprintf('%.2e', max_err) ')']);
    grid on; xlabel('x'); ylabel('Error');
    xlim([-1, 1]);
end