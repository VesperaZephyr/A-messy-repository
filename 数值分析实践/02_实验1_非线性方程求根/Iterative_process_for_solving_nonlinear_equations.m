% final_fixed_iteration.m
% 清理工作区
clear; clc;

% 给定初始值、收敛容差、最大迭代步数
x0 = 0.01;
tol = 1e-8;
maxIter = 100;

% 原方程 f(x) = arctan(5x - 1.05) + 0.5x + 0.895 = 0
f = @(x) atan(5*x - 1.05) + 0.5*x + 0.895;

fprintf('初始值 x0 = %.8f\n\n', x0);

% ================= 格式一：x = -2*arctan(5x - 1.05) - 1.79 =================
x = x0;
x1_hist = x;            % 保存迭代历史
iter1 = 0;
err1 = inf;
fprintf('格式一迭代过程:\n');
fprintf(' iter        x               |x-x_prev|       f(x)\n');
while err1 > tol && iter1 < maxIter
    x_new = -2 * atan(5 * x - 1.05) - 1.79;
    % 检查是否出现无穷或非数
    if ~isfinite(x_new)
        fprintf('格式一在第 %d 步出现非有限值，迭代终止。\n', iter1+1);
        break;
    end
    err1 = abs(x_new - x);
    iter1 = iter1 + 1;
    x = x_new;
    x1_hist(end+1) = x;
    fprintf(' %3d   %15.10f   %15.10e   %15.10e\n', iter1, x, err1, f(x));
end
if iter1 < maxIter && err1 <= tol
    fprintf('格式一最终近似根: %.10f，迭代步数: %d\n\n', x, iter1);
elseif iter1 == maxIter
    fprintf('格式一达到最大迭代步数 %d，可能未收敛。\n\n', maxIter);
end

% ================= 格式二：x = 0.21 - 0.2*tan(0.5x + 0.895) =================
x = x0;
x2_hist = x;
iter2 = 0;
err2 = inf;
fprintf('格式二迭代过程:\n');
fprintf(' iter        x               |x-x_prev|       f(x)\n');
while err2 > tol && iter2 < maxIter
    arg = 0.5 * x + 0.895;
    % 检查参数是否接近正切函数的奇点 (π/2 + kπ)
    if min(abs(arg - pi/2 - (-2:2)*pi)) < 1e-6
        fprintf('格式二参数接近奇点，迭代终止。\n');
        break;
    end
    x_new = 0.21 - 0.2 * tan(arg);
    if ~isfinite(x_new)
        fprintf('格式二在第 %d 步出现非有限值，迭代终止。\n', iter2+1);
        break;
    end
    err2 = abs(x_new - x);
    iter2 = iter2 + 1;
    x = x_new;
    x2_hist(end+1) = x;
    fprintf(' %3d   %15.10f   %15.10e   %15.10e\n', iter2, x, err2, f(x));
end
if iter2 < maxIter && err2 <= tol
    fprintf('格式二最终近似根: %.10f，迭代步数: %d\n\n', x, iter2);
elseif iter2 == maxIter
    fprintf('格式二达到最大迭代步数 %d，可能未收敛。\n\n', maxIter);
end

% ================= 可视化收敛过程 =================
figure;
subplot(2,2,1);
plot(0:length(x1_hist)-1, x1_hist, 'b-o', 'LineWidth', 1.2);
xlabel('迭代步数'); ylabel('x 值'); title('格式一：迭代序列');
grid on;

subplot(2,2,2);
semilogy(1:length(x1_hist)-1, abs(diff(x1_hist)), 'r-s', 'LineWidth', 1.2);
xlabel('迭代步数'); ylabel('|x_{n+1} - x_n|'); title('格式一：误差变化');
grid on;

if length(x2_hist) > 1
    subplot(2,2,3);
    plot(0:length(x2_hist)-1, x2_hist, 'b-o', 'LineWidth', 1.2);
    xlabel('迭代步数'); ylabel('x 值'); title('格式二：迭代序列');
    grid on;

    subplot(2,2,4);
    semilogy(1:length(x2_hist)-1, abs(diff(x2_hist)), 'r-s', 'LineWidth', 1.2);
    xlabel('迭代步数'); ylabel('|x_{n+1} - x_n|'); title('格式二：误差变化');
    grid on;
else
    fprintf('格式二无足够数据绘图 (可能未迭代或一步终止)。\n');
end

% 输出最终残差以验证
fprintf('\n最终验证：\n');
fprintf('格式一近似根处 f(x) = %.10e\n', f(x1_hist(end)));
if ~isempty(x2_hist)
    fprintf('格式二近似根处 f(x) = %.10e\n', f(x2_hist(end)));
end
