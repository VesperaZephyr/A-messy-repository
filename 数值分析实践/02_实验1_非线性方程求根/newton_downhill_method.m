%% Newton 下山法 vs 标准牛顿法（坏初值对比）
clear; clc;

% 方程与导数
f   = @(x) atan(5*x - 1.05) + 0.5*x + 0.895;
df  = @(x) 5./(1 + (5*x - 1.05).^2) + 0.5;

tol     = 1e-12;       % 收敛容差
maxIter = 200;         % 最大迭代步数

% 坏初值列表
x0_list = [5, 100, -50, 1000000];

fprintf('================ 标准牛顿法 (坏初值) ================\n');
for i = 1:length(x0_list)
    x = x0_list(i);
    conv_flag = false;
    for k = 1:maxIter
        fx = f(x); dfx = df(x);
        if abs(dfx) < 1e-14, break; end
        x_new = x - fx / dfx;
        if abs(x_new - x) < tol
            conv_flag = true; break;
        end
        x = x_new;
    end
    if conv_flag
        fprintf('x0=%10g  收敛于 %.12f (步数 %d)\n', x0_list(i), x, k);
    else
        fprintf('x0=%10g  未收敛! 停在 x=%.12f, |f(x)|=%.3e\n', ...
                x0_list(i), x, abs(f(x)));
    end
end

fprintf('\n============== Newton 下山法 (坏初值) ===============\n');
fprintf('参数: 初始λ=1, 缩减因子=0.5, 最小λ=1e-12\n\n');
lambda0 = 1;
shrink = 0.5;
lambda_min = 1e-12;

for i = 1:length(x0_list)
    x = x0_list(i);
    fx_old = f(x);
    conv_flag = false;
    iter = 0;
    for k = 1:maxIter
        dfx = df(x);
        if abs(dfx) < 1e-14, break; end
        dx = -fx_old / dfx;      % 全牛顿步长方向
        lambda = lambda0;
        while lambda > lambda_min
            x_try = x + lambda * dx;
            fx_try = f(x_try);
            if abs(fx_try) < abs(fx_old)   % 下山条件：|f| 严格下降
                break;
            end
            lambda = lambda * shrink;       % 缩小步长
        end
        if lambda <= lambda_min
            fprintf('x0=%10g  λ过小，终止.\n', x0_list(i));
            break;
        end
        % 更新
        x_new = x_try;
        err = abs(x_new - x);
        x = x_new;
        fx_old = fx_try;
        iter = k;
        if err < tol
            conv_flag = true; break;
        end
    end
    if conv_flag
        fprintf('x0=%10g  收敛于 %.12f (步数 %d)\n', x0_list(i), x, iter);
    elseif iter == maxIter
        fprintf('x0=%10g  达到最大步数，未收敛，x=%.12f, |f|=%.3e\n', ...
                x0_list(i), x, abs(f(x)));
    end
end
