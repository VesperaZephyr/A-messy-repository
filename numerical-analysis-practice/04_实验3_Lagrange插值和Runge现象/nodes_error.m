nvals = [3 5 8 10 15 20];
syms x;
f = 1/(1+25*x^2);
max_deriv = zeros(size(nvals));
max_omega = zeros(size(nvals));
max_error = zeros(size(nvals));

for idx = 1:length(nvals)
    n = nvals(idx);
    
    % 等距节点
    xi = linspace(-1, 1, n+1);
    % 连乘因子 |ω(x)| 最大值(在[-1,1]上采样)
    xx = linspace(-1, 1, 2000);
    omega = ones(size(xx));
    for i = 1:n+1
        omega = omega .* (xx - xi(i));
    end
    max_omega(idx) = max(abs(omega));
    
    % 导数因子: 计算 |f^{(n+1)}(0)| / (n+1)!
    deriv = diff(f, n+1);
    deriv0 = double(subs(deriv, x, 0));
    max_deriv(idx) = abs(deriv0) / factorial(n+1);
    
    % 实际最大误差(采样)
    yy_true = double(subs(f, xx));
    yy_interp = zeros(size(xx));
    for k = 1:length(xx)
        yy_interp(k) = lagrange_interpolation(n, xx(k));
    end
    max_error(idx) = max(abs(yy_true - yy_interp));
end

% 显示结果
fprintf('n   导数因子\t\t连乘因子max\t实际max误差\n');
for idx = 1:length(nvals)
    fprintf('%d   %.3e\t\t%.3e\t\t%.3e\n', nvals(idx), max_deriv(idx), max_omega(idx), max_error(idx));
end