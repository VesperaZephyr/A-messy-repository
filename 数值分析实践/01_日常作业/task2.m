% 求解 f(x) = x^3 - sin(x) - 12x + 1 = 0 的全部实根
% 方法：牛顿法、普通迭代法(φ1, φ2)、埃特金加速法
% 误差限 1e-6，比较收敛速度并绘图

clear; close all; clc;

% ================== 函数定义 ==================
f   = @(x) x.^3 - sin(x) - 12*x + 1;        % 原函数
df  = @(x) 3*x.^2 - cos(x) - 12;            % 导数（牛顿法用）

% 普通迭代格式
phi1 = @(x) nthroot(12*x + sin(x) - 1, 3);  % 使用 nthroot 保证实数立方根
phi2 = @(x) (x.^3 - sin(x) + 1) / 12;

% ================== 参数设置 ==================
eps_err = 1e-6;          % 误差限
max_iter = 200;          % 最大迭代次数

% ================== 寻找高精度参考根 ==================
% 通过 fzero 获得“精确”根，用于计算误差
opts = optimset('TolX', 1e-12, 'Display', 'off');
root1_true = fzero(f, -3.3, opts);
root2_true = fzero(f,  0.1, opts);
root3_true = fzero(f,  3.2, opts);
true_roots = [root1_true; root2_true; root3_true];
fprintf('高精度参考根:\n');
fprintf('  x1 = %.10f\n  x2 = %.10f\n  x3 = %.10f\n\n', true_roots);

% ================== 迭代方法实现 ==================

% 1. 牛顿法
function [x_hist, n] = newton_method(f, df, x0, eps_err, max_iter)
    x_hist = x0; 
    x = x0;
    for n = 1:max_iter
        x_new = x - f(x) / df(x);
        x_hist(end+1) = x_new;
        if abs(x_new - x) < eps_err
            break;
        end
        x = x_new;
    end
end

% 2. 普通迭代法
function [x_hist, n] = fixed_point_method(g, x0, eps_err, max_iter)
    x_hist = x0;
    x = x0;
    for n = 1:max_iter
        x_new = g(x);
        x_hist(end+1) = x_new;
        if abs(x_new - x) < eps_err
            break;
        end
        x = x_new;
    end
    % 若发散或出现复数则截断
    if ~isreal(x_hist) || any(isnan(x_hist)) || any(isinf(x_hist))
        n = inf;  % 标记发散
    end
end

% 3. 埃特金加速法
function [x_hist, n] = aitken_method(g, x0, eps_err, max_iter)
    x_hist = x0;
    x = x0;
    for n = 1:max_iter
        x1 = g(x);
        x2 = g(x1);
        denom = x2 - 2*x1 + x;
        if abs(denom) < 1e-15    % 防止除零
            x_new = x2;
        else
            x_new = x - (x1 - x)^2 / denom;
        end
        x_hist(end+1) = x_new;
        if abs(x_new - x) < eps_err
            break;
        end
        x = x_new;
    end
    if ~isreal(x_hist) || any(isnan(x_hist)) || any(isinf(x_hist))
        n = inf;
    end
end

% ================== 对不同根分别比较 ==================
% 选择与各根区间对应的相同初值（尽量保证多数方法收敛）
% 根1: [-3.5, -3]; 根2: [0, 1]; 根3: [3, 4]
init_guesses = [-3.25, 0.5, 3.25];
method_names = {'牛顿法', 'φ1迭代', 'φ2迭代', 'Aitken-φ1', 'Aitken-φ2'};
colors = lines(5);

figure('Position', [100, 100, 1200, 800]);

for i = 1:3
    x0 = init_guesses(i);
    true_root = true_roots(i);
    
    % 执行各方法并记录迭代历史
    [hist_N,    n_N]    = newton_method(f, df, x0, eps_err, max_iter);
    [hist_phi1, n_phi1] = fixed_point_method(phi1, x0, eps_err, max_iter);
    [hist_phi2, n_phi2] = fixed_point_method(phi2, x0, eps_err, max_iter);
    [hist_A1,   n_A1]   = aitken_method(phi1, x0, eps_err, max_iter);
    [hist_A2,   n_A2]   = aitken_method(phi2, x0, eps_err, max_iter);
    
    % 计算绝对误差
    err_N    = abs(hist_N    - true_root);
    err_phi1 = abs(hist_phi1 - true_root);
    err_phi2 = abs(hist_phi2 - true_root);
    err_A1   = abs(hist_A1   - true_root);
    err_A2   = abs(hist_A2   - true_root);
    
    % 输出迭代次数
    fprintf('根%d (x0 = %.2f):\n', i, x0);
    fprintf('  牛顿法        : 迭代 %2d 次, 结果 = %.10f\n', n_N, hist_N(end));
    if isfinite(n_phi1)
        fprintf('  φ1            : 迭代 %2d 次, 结果 = %.10f\n', n_phi1, hist_phi1(end));
    else
        fprintf('  φ1            : 发散\n');
    end
    if isfinite(n_phi2)
        fprintf('  φ2            : 迭代 %2d 次, 结果 = %.10f\n', n_phi2, hist_phi2(end));
    else
        fprintf('  φ2            : 发散\n');
    end
    if isfinite(n_A1)
        fprintf('  Aitken(φ1)    : 迭代 %2d 次, 结果 = %.10f\n', n_A1, hist_A1(end));
    else
        fprintf('  Aitken(φ1)    : 发散\n');
    end
    if isfinite(n_A2)
        fprintf('  Aitken(φ2)    : 迭代 %2d 次, 结果 = %.10f\n', n_A2, hist_A2(end));
    else
        fprintf('  Aitken(φ2)    : 发散\n');
    end
    fprintf('\n');
    
    % ---------- 绘制收敛速度图 ----------
    subplot(1, 3, i);
    % 牛顿法
    semilogy(0:length(err_N)-1, max(err_N, 1e-16), 'Color', colors(1,:), 'LineWidth', 1.5); hold on;
    % φ1
    if isfinite(n_phi1)
        semilogy(0:length(err_phi1)-1, max(err_phi1, 1e-16), '--', 'Color', colors(2,:), 'LineWidth', 1.5);
    end
    % φ2
    if isfinite(n_phi2)
        semilogy(0:length(err_phi2)-1, max(err_phi2, 1e-16), '--', 'Color', colors(3,:), 'LineWidth', 1.5);
    end
    % Aitken(φ1)
    if isfinite(n_A1)
        semilogy(0:length(err_A1)-1, max(err_A1, 1e-16), ':', 'Color', colors(4,:), 'LineWidth', 2);
    end
    % Aitken(φ2)
    if isfinite(n_A2)
        semilogy(0:length(err_A2)-1, max(err_A2, 1e-16), ':', 'Color', colors(5,:), 'LineWidth', 2);
    end
    hold off;
    
    xlabel('迭代步数 k'); ylabel('|x_k - x^*|');
    title(sprintf('根%d (x^* ≈ %.4f)', i, true_root));
    legend(method_names, 'Location', 'northeast');
    grid on; axis tight;
end

% ================== 绘制函数与根的位置 ==================
figure;
x_range = -5:0.01:5;
plot(x_range, f(x_range), 'b-', 'LineWidth', 1.5); hold on;
plot(true_roots, f(true_roots), 'ro', 'MarkerSize', 8, 'LineWidth', 2);
yline(0, 'k--');
xlabel('x'); ylabel('f(x)');
title('f(x) = x^3 - sin(x) - 12x + 1 的图像及根');
legend('f(x)', '实根', 'Location', 'best');
grid on;