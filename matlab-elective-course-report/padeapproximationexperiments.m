% 计算 e^x, ln(1+x), tan(x), sin(x), cos(x) 在不同阶数下的 Pade 逼近
clc; clear; close all;

%% 1. 定义实验配置
% 函数定义 (使用符号变量以便计算泰勒级数)
syms x;
funcs = {exp(x), log(1+x), tan(x), sin(x), cos(x)};
func_names = {'e^x', 'ln(1+x)', 'tan(x)', 'sin(x)', 'cos(x)'};

% 定义要计算的阶数 [L, M]
orders = [0,1; 1,0; 1,1; 1,2; 2,1; 2,2];
colors = {'r--', 'g--', 'b--', 'm-.', 'c-.', 'k:'}; % 绘图颜色

% 绘图区间设置
x_ranges = [-2, 2; -0.9, 2; -1.5, 1.5; -3, 3; -3, 3]; 
% 注意：ln(1+x)在x<=-1无定义，tan(x)在pi/2有奇点

%% 2. 主循环：遍历每个函数
for f_idx = 1:length(funcs)
    f_sym = funcs{f_idx};
    name = func_names{f_idx};
    x_lim = x_ranges(f_idx, :);
    x_plot = linspace(x_lim(1), x_lim(2), 500);
    
    % 计算真实值
    y_true = double(subs(f_sym, x, x_plot));
    
    % 创建图形窗口
    figure('Name', ['Pade Approx: ' name], 'Color', 'w', 'Position', [100, 100, 800, 600]);
    plot(x_plot, y_true, 'k-', 'LineWidth', 2, 'DisplayName', 'True Function'); 
    hold on;
    ylim_manual = [min(y_true)-1, max(y_true)+1]; % 限制y轴防止极点处数值过大
    
    fprintf('--- Function: %s ---\n', name);
    
    %% 3. 子循环：遍历每个阶数
    for o_idx = 1:size(orders, 1)
        L = orders(o_idx, 1);
        M = orders(o_idx, 2);
        
        % 调用自定义 Pade 计算函数
        [num, den, pade_sym] = calc_pade(f_sym, x, L, M);
        
        % 打印结果公式
        fprintf('[%d/%d] Pade: %s\n', L, M, string(pade_sym));
        
        % 计算逼近值 (处理分母为0的奇点)
        y_pade = double(subs(pade_sym, x, x_plot));
        % 简单的滤波，去除极点处的连线
        y_pade(abs(y_pade) > 20) = NaN; 
        
        % 绘图
        plot(x_plot, y_pade, colors{o_idx}, 'LineWidth', 1.5, ...
             'DisplayName', sprintf('[%d/%d] Pade', L, M));
    end
    
    % 图形美化
    title(['Padé Approximation of ' name]);
    xlabel('x'); ylabel('y');
    legend('Location', 'best');
    grid on;
    ylim(max(min(ylim_manual, 10), -10)); % 动态限制Y轴范围
end

%% --- 辅助函数：计算 Pade 系数 ---
function [num_poly, den_poly, r_sym] = calc_pade(f, x_var, L, M)
    % 1. 计算泰勒级数系数 c_0 到 c_{L+M}
    N = L + M;
    taylor_expansion = taylor(f, x_var, 'Order', N+1);
    c = zeros(N+1, 1);
    for k = 0:N
        term = diff(taylor_expansion, x_var, k);
        c(k+1) = double(subs(term, x_var, 0)) / factorial(k);
    end
    
    % 2. 建立方程组求解分母系数 b (b_0 = 1)
    % 方程: H * b_vec = -y_vec
    % b_vec = [b_M, ..., b_1]'
    if M > 0
        H = zeros(M, M);
        y_vec = zeros(M, 1);
        for i = 1:M % 行
            for j = 1:M % 列 (对应 b_{M-j+1})
                idx_c = L - M + i + (M-j+1); % c 的下标
                if idx_c >= 0 && idx_c <= N
                    H(i, j) = c(idx_c + 1);
                end
            end
            idx_rhs = L + i;
            if idx_rhs <= N
                y_vec(i) = -c(idx_rhs + 1);
            end
        end
        
        % 求解 b
        if rcond(H) < 1e-12 % 检查奇异性
            b_coeffs = zeros(M, 1); % 无法求解时退化
        else
            b_inv = H \ y_vec; % [b_M, ..., b_1]
            b_coeffs = flipud(b_inv); % [b_1, ..., b_M]
        end
    else
        b_coeffs = [];
    end
    b = [1; b_coeffs];
    
    % 3. 直接计算分子系数 a
    a = zeros(L+1, 1);
    for k = 0:L
        sum_val = 0;
        for j = 0:min(k, M)
            sum_val = sum_val + c(k-j+1) * b(j+1);
        end
        a(k+1) = sum_val;
    end
    
    % 4. 构造符号表达式
    num_poly = sum(a .* (x_var .^ (0:L).'));
    den_poly = sum(b .* (x_var .^ (0:M).'));
    r_sym = num_poly / den_poly;
end