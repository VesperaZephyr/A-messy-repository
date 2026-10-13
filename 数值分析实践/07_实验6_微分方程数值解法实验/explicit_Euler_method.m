% 显式欧拉法：求解 y' = -y + 2t, y(0)=1, t∈[0,5]
clear; clc;

% 解析解与右端函数
exact = @(t) 2*t - 2 + 3*exp(-t);
f = @(t, y) -y + 2*t;

% 参数
y0 = 1;
t_span = [0, 5];
h_list = [0.1, 0.05, 0.01];

fprintf('========== 显式欧拉法 ==========\n');
fprintf(' h      N     y(5)数值    全局最大误差      耗时(s)\n');
fprintf('----------------------------------------------\n');

for h = h_list
    N = round((t_span(2) - t_span(1)) / h);
    t = linspace(t_span(1), t_span(2), N+1);
    
    % 欧拉法计算
    y = zeros(1, N+1);
    y(1) = y0;
    tic;                % 开始计时
    for i = 1:N
        y(i+1) = y(i) + h * f(t(i), y(i));
    end
    elapsed = toc;      % 结束计时
    
    % 误差分析
    err = max(abs(y - exact(t)));
    
    fprintf('%.2f   %4d   %8.6f   %12.6e   %.6f\n', ...
            h, N, y(end), err, elapsed);
end
