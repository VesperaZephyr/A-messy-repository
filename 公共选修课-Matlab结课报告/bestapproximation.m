%% 文件名称：bestapproximation.m
% 目标: 计算 sqrt(1+x^2) 和 e^x - 1 在 [0,1] 上的最佳一次逼近多项式
% 方法: 利用凸函数的切比雪夫定理推论 (解析法 + 数值求根)

clc; clear; close all;

%% 1. 定义实验参数
% 定义区间
a = 0; b = 1;
x_grid = linspace(a, b, 10000); % 高密度网格用于绘图

% 函数1: sqrt(1+x^2)
f1 = @(x) sqrt(1+x.^2);
df1 = @(x) x ./ sqrt(1+x.^2); 

% 函数2: e^x - 1
f2 = @(x) exp(x) - 1;
df2 = @(x) exp(x);

% 放入元胞数组方便循环
funcs = {f1, f2};
dfuncs = {df1, df2};
titles = {'f(x) = sqrt(1+x^2)', 'f(x) = e^x - 1'};

%% 2. 循环计算与绘图
for k = 1:2
    % 获取当前函数句柄
    f = funcs{k};
    df = dfuncs{k};
    name = titles{k};
    
    fprintf('--------------------------------------------------\n');
    fprintf('正在计算函数: %s\n', name);
    
    % [步骤1] 计算最佳逼近直线的斜率 a1
    % 理论: 对于凸函数，最佳斜率 a1 = (f(b) - f(a)) / (b - a)
    fa = f(a);
    fb = f(b);
    a1 = (fb - fa) / (b - a);
    
    % [步骤2] 计算最大误差发生的内点 x_star
    % 理论: 满足 f'(x_star) = a1
    % 定义方程 eqn(x) = f'(x) - a1 = 0
    eqn = @(x) df(x) - a1;
    
    % 使用 fzero 求解 (在区间 [a, b] 内寻找零点)
    try
        x_star = fzero(eqn, [a, b]); 
    catch
        % 如果端点即为极值点(极少情况)，做容错处理
        x_star = fminbnd(@(x) abs(eqn(x)), a, b);
    end
    
    % [步骤3] 计算截距 a0
    % 理论: 利用交错性质 E(a) = -E(x_star)
    % (a0 + a1*a) - f(a) = - [ (a0 + a1*x_star) - f(x_star) ]
    % => 2*a0 = f(a) + f(x_star) - a1*(a + x_star)
    fx_star = f(x_star);
    a0 = 0.5 * (fa + fx_star - a1*(a + x_star));
    
    %% --- 结果验证与输出 ---
    
    % 构造逼近多项式 P(x) = a1*x + a0
    p = [a1, a0]; 
    y_true = f(x_grid);
    y_approx = polyval(p, x_grid);
    
    % 计算误差曲线 E(x) = P(x) - f(x)
    error_curve = y_approx - y_true;
    max_err = max(abs(error_curve));
    
    % 输出结果到控制台
    fprintf('  最佳斜率 a1 = %.8f\n', a1);
    fprintf('  极值点 x*   = %.8f\n', x_star);
    fprintf('  最佳截距 a0 = %.8f\n', a0);
    fprintf('  >> 最佳一次逼近多项式: P(x) = %.6f x + %.6f\n', a1, a0);
    fprintf('  >> 最大误差 E = %.6e\n', max_err);
    
    %% --- 绘图 ---
    figure('Name', ['Best Linear Approx: ' name], 'Color', 'w', 'Position', [100+400*(k-1), 200, 700, 500]);
    
    % 上图：函数拟合对比
    subplot(2, 1, 1);
    plot(x_grid, y_true, 'k-', 'LineWidth', 2); hold on;
    plot(x_grid, y_approx, 'r--', 'LineWidth', 1.5);
    % 标记关键点 (端点和极值点)
    plot([a, x_star, b], f([a, x_star, b]), 'bo', 'MarkerFaceColor', 'b');
    legend('原函数 f(x)', '最佳一次逼近 P_1(x)', '关键点 (a, x^*, b)', 'Location', 'best');
    title([name ' 及其最佳一次一致逼近']);
    grid on;
    xlabel('x'); ylabel('y');
    
    % 下图：误差曲线
    subplot(2, 1, 2);
    plot(x_grid, error_curve, 'b-', 'LineWidth', 1.5); hold on;
    yline(0, 'k-');
    % 标记误差极值点
    plot(a, error_curve(1), 'r.', 'MarkerSize', 15);
    % 找到网格中对应的 x_star 位置进行标记
    [~, idx_star] = min(abs(x_grid - x_star));
    plot(x_grid(idx_star), error_curve(idx_star), 'r.', 'MarkerSize', 15);
    plot(b, error_curve(end), 'r.', 'MarkerSize', 15);
    
    title(['误差曲线 E(x) = P_1(x) - f(x) (Max Error: ' sprintf('%.1e', max_err) ')']);
    xlabel('x'); ylabel('Error');
    grid on;
    % 设置Y轴范围以展示正负对称性
    ylim([-max_err*1.2, max_err*1.2]);
end