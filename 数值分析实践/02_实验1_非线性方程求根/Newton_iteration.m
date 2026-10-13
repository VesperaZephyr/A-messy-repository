%% 牛顿迭代法求解 f(x) = arctan(5x - 1.05) + 0.5x + 0.895 = 0
clear; clc;

% 定义函数及其导数
f = @(x) atan(5*x - 1.05) + 0.5*x + 0.895;
df = @(x) 5./(1 + (5*x - 1.05).^2) + 0.5;

% 参数设置
x0 = 0.01;          % 初始值
tol = 1e-12;        % 收敛容差
maxIter = 50;       % 最大迭代步数

% 牛顿迭代
x = x0;
fprintf('牛顿迭代法 (x0 = %.2f):\n', x0);
fprintf(' iter          x                  f(x)               |x-x_prev|\n');
for k = 1:maxIter
    fx = f(x);
    dfx = df(x);
    if abs(dfx) < 1e-14
        error('导数接近零，无法继续迭代');
    end
    x_new = x - fx / dfx;
    err = abs(x_new - x);
    fprintf(' %3d    %15.10f    %15.10e    %15.10e\n', k, x_new, fx, err);
    if err < tol
        x = x_new;
        break;
    end
    x = x_new;
end

fprintf('\n近似根: x* = %.12f\n', x);
fprintf('残差  f(x*) = %.2e\n', f(x));
fprintf('迭代步数: %d\n', k);
