% compare_convergence.m
% 对比不动点迭代（格式二）与牛顿迭代的收敛速度
clear; clc; close all;

% 定义原函数及其导数（用于牛顿法）
f  = @(x) atan(5*x - 1.05) + 0.5*x + 0.895;
df = @(x) 5./(1 + (5*x - 1.05).^2) + 0.5;

% 初始值
x0 = 0.01;
tol = 1e-12;
maxIter = 100;

%% ========== 1. 不动点迭代（格式二）==========
% g2(x) = 0.21 - 0.2*tan(0.5*x + 0.895)
x_fp = x0;
err_fp = [];      % 存储 |x_k - x_{k-1}|

for k = 1:maxIter
    arg = 0.5*x_fp + 0.895;
    % 防发散检测（实际不触发）
    if min(abs(arg - pi/2 - (-2:2)*pi)) < 1e-6 || ~isfinite(tan(arg))
        break;
    end
    x_new = 0.21 - 0.2*tan(arg);
    err = abs(x_new - x_fp);
    err_fp(end+1) = err;
    x_fp = x_new;
    if err < tol
        break;
    end
end

%% ========== 2. 牛顿迭代 ==========
x_newton = x0;
err_newton = [];

for k = 1:maxIter
    fx = f(x_newton);
    dfx = df(x_newton);
    if abs(dfx) < 1e-14
        break;
    end
    x_new = x_newton - fx/dfx;
    err = abs(x_new - x_newton);
    err_newton(end+1) = err;
    x_newton = x_new;
    if err < tol
        break;
    end
end

%% ========== 3. 绘图对比 ==========
figure('Color','w');
semilogy(1:length(err_fp), err_fp, 'ro-', ...
         'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerFaceColor', 'r');
hold on;
semilogy(1:length(err_newton), err_newton, 'bs-', ...
         'LineWidth', 1.5, 'MarkerSize', 6, 'MarkerFaceColor', 'b');

% 标注理论斜率（线性收敛参考线）
% 不动点迭代的收敛因子 C ≈ 0.246，理论斜率 log10(C) ≈ -0.609
% 绘制斜率为 C 的直线作为参考
k_ref = 1:length(err_fp);
C = abs(0.1/cos(0.5*(-0.0315511)+0.895)^2);  % |g2'(x*)| ≈ 0.246
err_theory = err_fp(1) * C.^(k_ref-1);        % 理想的线性收敛曲线
semilogy(k_ref, err_theory, 'k--', 'LineWidth', 1);
text(k_ref(round(end/2)), err_theory(round(end/2)), ...
     ['理论线性收敛(C=' num2str(C,'%.3f') ')'], ...
     'VerticalAlignment','bottom', 'Color','k');

grid on; box on;
xlabel('迭代次数 k', 'FontSize', 12);
ylabel('|x_k - x_{k-1}|（对数尺度）', 'FontSize', 12);
title('不动点迭代 vs 牛顿法 收敛速度对比', 'FontSize', 14);
legend('不动点迭代(格式二)', '牛顿迭代', '线性收敛参考线', ...
       'Location', 'northeast');

hold off;

% 输出最终结果
fprintf('不动点迭代步数: %d, 最终误差: %e\n', length(err_fp), err_fp(end));
fprintf('牛顿迭代步数: %d, 最终误差: %e\n', length(err_newton), err_newton(end));
