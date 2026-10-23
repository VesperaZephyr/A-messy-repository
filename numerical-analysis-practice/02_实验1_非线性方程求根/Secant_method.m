% 割线法 vs 牛顿法：收敛速度与效率对比
clear; clc;

% 定义函数
f = @(x) atan(5*x - 1.05) + 0.5*x + 0.895;
% 导数（仅牛顿法使用）
df = @(x) 5./(1 + (5*x - 1.05).^2) + 0.5;

% 参数设置
tol = 1e-12;        % 收敛容差
maxIter = 100;

% 初始值
x0_secant = 0.01;
x1_secant = 0.11;   % 割线法两个初始点
x0_newton = 0.01;   % 牛顿法初值

% ================== 割线法 ==================
x_prev = x0_secant;
x_curr = x1_secant;
iter_sec = 0;
tic;
for k = 1:maxIter
    f_prev = f(x_prev);
    f_curr = f(x_curr);
    denom = f_curr - f_prev;
    if abs(denom) < 1e-15
        warning('割线法分母接近零，中止');
        break;
    end
    x_next = x_curr - f_curr * (x_curr - x_prev) / denom;
    err = abs(x_next - x_curr);
    x_prev = x_curr;
    x_curr = x_next;
    iter_sec = k;
    if err < tol
        break;
    end
end
time_sec = toc;
x_sec = x_curr;

% ================== 牛顿法 ==================
x = x0_newton;
iter_newt = 0;
tic;
for k = 1:maxIter
    fx = f(x);
    dfx = df(x);
    if abs(dfx) < 1e-14
        warning('牛顿法导数接近零，中止');
        break;
    end
    x_next = x - fx/dfx;
    err = abs(x_next - x);
    x = x_next;
    iter_newt = k;
    if err < tol
        break;
    end
end
time_newt = toc;
x_newt = x;

% ================== 结果输出 ==================
fprintf('          |  迭代次数  |  计算时间 (s)  |  最终近似根\n');
fprintf('---------------------------------------------------------\n');
fprintf('割线法    |    %2d      |  %12.3e  |  %.12f\n', iter_sec, time_sec, x_sec);
fprintf('牛顿法    |    %2d      |  %12.3e  |  %.12f\n', iter_newt, time_newt, x_newt);
fprintf('\n收敛容差 tol = %e\n', tol);
