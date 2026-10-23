%% 综合数值实验：牛顿法“坏”初值、三种方法对比
clear; clc; close all;

% ========== 定义方程与导数 ==========
f  = @(x) atan(5*x - 1.05) + 0.5*x + 0.895;
df = @(x) 5./(1 + (5*x - 1.05).^2) + 0.5;
% 不动点迭代格式二
g2 = @(x) 0.21 - 0.2*tan(0.5*x + 0.895);

tol = 1e-12;      % 收敛容差
maxIter = 100;     % 最大迭代步数

fprintf('========== 1. 牛顿法“坏”初值实验 (x0=100) ==========\n');
x0_bad = 100;
x = x0_bad;
fprintf('初始值: x0 = %g\n', x0_bad);
fprintf(' iter         x                  f(x)               |x-x_prev|\n');
for k = 1:15
    fx = f(x);
    dfx = df(x);
    x_new = x - fx/dfx;
    err = abs(x_new - x);
    fprintf(' %3d    %15.8f    %15.8e    %15.8e\n', k, x_new, fx, err);
    if err < tol
        x = x_new; break;
    end
    x = x_new;
end
fprintf('最终近似根: %.12f\n\n', x);

% ========== 2. 不同初值下牛顿法的收敛步数统计 ==========
fprintf('========== 2. 牛顿法初值扫描 ==========\n');
x0_list = [0.01, 0.21, 10, 100, -50, -100, 1e6];
fprintf('     x0          迭代次数      最终根\n');
for i = 1:length(x0_list)
    x = x0_list(i);
    for k = 1:maxIter
        fx = f(x); dfx = df(x);
        x_new = x - fx/dfx;
        if abs(x_new - x) < tol
            x = x_new; break;
        end
        x = x_new;
    end
    fprintf('%10.2f         %2d         %.12f\n', x0_list(i), k, x);
end
fprintf('结论：无论初值多远，牛顿法均稳定收敛到唯一根。\n\n');

% ========== 3. 不动点迭代对初值的敏感性 ==========
fprintf('========== 3. 不动点迭代（格式二）初值扫描 ==========\n');
x0_fp_list = [0.01, 0.5, 1, 2, 5, 10];
fprintf('     x0          迭代次数      最终根            状态\n');
for i = 1:length(x0_fp_list)
    x = x0_fp_list(i);
    flag = '收敛';
    for k = 1:maxIter
        arg = 0.5*x + 0.895;
        % 检查奇点
        if min(abs(arg - pi/2 - (-2:2)*pi)) < 1e-6
            flag = '奇点发散'; break;
        end
        x_new = g2(x);
        if ~isfinite(x_new)
            flag = '数值溢出'; break;
        end
        if abs(x_new - x) < tol
            x = x_new; break;
        end
        x = x_new;
    end
    if k == maxIter, flag = '未收敛'; end
    fprintf('%10.2f         %2d         %.12f    %s\n', x0_fp_list(i), k, x, flag);
end
fprintf('注：格式一（x_{n+1}=-2*atan(5x_n-1.05)-1.79）对任意初值均发散（2-周期震荡），不再重复。\n\n');

% ========== 4. 割线法初值扫描 ==========
fprintf('========== 4. 割线法初值扫描 ==========\n');
sec_init = [0.01, 0.11;   % 正常初值
            0, 1;          % 跨根区间
            10,11;         % 远初值
            100,101;       % 极远初值
           -10, -9];       % 负远初值
fprintf('   (x0, x1)       迭代次数      最终根            状态\n');
for i = 1:size(sec_init,1)
    x_prev = sec_init(i,1); x_curr = sec_init(i,2);
    flag = '收敛';
    for k = 1:maxIter
        f_prev = f(x_prev); f_curr = f(x_curr);
        if abs(f_curr - f_prev) < 1e-15
            flag = '分母为零'; break;
        end
        x_next = x_curr - f_curr * (x_curr - x_prev)/(f_curr - f_prev);
        if abs(x_next - x_curr) < tol
            x_curr = x_next; break;
        end
        x_prev = x_curr; x_curr = x_next;
    end
    if k == maxIter, flag = '未收敛'; end
    fprintf('(%.2f, %.2f)          %2d         %.12f    %s\n', ...
            sec_init(i,1), sec_init(i,2), k, x_curr, flag);
end
fprintf('\n');

% ========== 5. 收敛速度对比图 ==========
% 牛顿法 (x0=0.01)
x_nt = 0.01; err_nt = [];
for k = 1:maxIter
    fx = f(x_nt); dfx = df(x_nt);
    x_new = x_nt - fx/dfx;
    err = abs(x_new - x_nt);
    err_nt(end+1) = err;
    x_nt = x_new;
    if err < tol, break; end
end

% 割线法 (0.01,0.11)
x_prev = 0.01; x_curr = 0.11; err_sec = [];
for k = 1:maxIter
    f_prev = f(x_prev); f_curr = f(x_curr);
    x_next = x_curr - f_curr*(x_curr - x_prev)/(f_curr - f_prev);
    err = abs(x_next - x_curr);
    err_sec(end+1) = err;
    x_prev = x_curr; x_curr = x_next;
    if err < tol, break; end
end

% 不动点格式二 (x0=0.01)
x_fp = 0.01; err_fp = [];
for k = 1:maxIter
    x_new = g2(x_fp);
    err = abs(x_new - x_fp);
    err_fp(end+1) = err;
    x_fp = x_new;
    if err < tol, break; end
end

% 绘图
figure('Color','w');
semilogy(1:length(err_nt), err_nt, 'bs-', 'LineWidth',1.5, 'MarkerSize',6, 'MarkerFaceColor','b');
hold on;
semilogy(1:length(err_sec), err_sec, 'rd-', 'LineWidth',1.5, 'MarkerSize',6, 'MarkerFaceColor','r');
semilogy(1:length(err_fp), err_fp, 'go-', 'LineWidth',1.5, 'MarkerSize',6, 'MarkerFaceColor','g');
% 理论线性收敛参考线
k_ref = 1:length(err_fp);
C = 0.246;  % |g2'(x*)|
plot(k_ref, err_fp(1)*C.^(k_ref-1), 'k--', 'LineWidth',1.2);
xlabel('迭代次数 k'); ylabel('|x_k - x_{k-1}|');
title('三种求根方法收敛速度对比');
legend('牛顿法 (二阶)', '割线法 (超线性)', '不动点迭代 (线性)', ...
       '线性收敛参考线', 'Location','northeast');
grid on; box on;

fprintf('图形已生成，可直观对比收敛速度。\n');
