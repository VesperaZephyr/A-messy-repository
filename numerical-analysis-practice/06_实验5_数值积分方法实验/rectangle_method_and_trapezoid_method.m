clear; clc;
f = @(x) exp(-5*x.^2);
a = 0; b = 3;
I_exact = integral(f, a, b, 'RelTol',1e-12, 'AbsTol',1e-14);
fprintf('高精度参考值 (integral): %.12f\n\n', I_exact);

ns = [10, 20, 50, 100];
fprintf('%-4s  %-12s  %-12s  %-12s  %-12s  %-12s  %-12s  %-12s  %-12s\n', ...
    'n', '左矩形误差', '右矩形误差', '中矩形误差', '梯形法误差', ...
    '左矩形时间(s)', '右矩形时间(s)', '中矩形时间(s)', '梯形法时间(s)');
fprintf('----------------------------------------------------------------------------------------------------------------------------------\n');

for n = ns
    h = (b-a)/n;
    x = linspace(a, b, n+1);   % 包括端点的网格点
    fx = f(x);
    
    % 左矩形 (使用x(1)~x(end-1))
    tic;
    I_left = h * sum(fx(1:end-1));
    t_left = toc;
    err_left = abs(I_left - I_exact);
    
    % 右矩形 (使用x(2)~x(end))
    tic;
    I_right = h * sum(fx(2:end));
    t_right = toc;
    err_right = abs(I_right - I_exact);
    
    % 中矩形
    tic;
    midpoints = (x(1:end-1) + x(2:end)) / 2;
    I_mid = h * sum(f(midpoints));
    t_mid = toc;
    err_mid = abs(I_mid - I_exact);
    
    % 梯形法
    tic;
    I_trap = h * ( (fx(1)+fx(end))/2 + sum(fx(2:end-1)) );
    t_trap = toc;
    err_trap = abs(I_trap - I_exact);
    
    fprintf('%-4d  %12.8e  %12.8e  %12.8e  %12.8e  %12.6f  %12.6f  %12.6f  %12.6f\n', ...
        n, err_left, err_right, err_mid, err_trap, ...
        t_left, t_right, t_mid, t_trap);
end