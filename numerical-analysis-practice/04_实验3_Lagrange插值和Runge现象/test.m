% 参数设置
n = 5;              % 使用5次插值多项式
x_test = 0.5;      % 单个测试点

% 基函数测试
fprintf('n = %d 时各基函数在 x = %.2f 的值:\n', n, x_test);
for i = 0:n
    li = lagrange_basis(n, i, x_test);
    fprintf('  l_%d(%.2f) = %.6f\n', i, x_test, li);
end

% 插值结果与真值对比
Pn = lagrange_interpolation(n, x_test);
true_val = 1 / (1 + 25 * x_test^2);
fprintf('\nP_%d(%.2f) = %.6f,  真实值 = %.6f\n', n, x_test, Pn, true_val);

% 多点比较
x_vec = linspace(-1, 1, 11);
P_vec = lagrange_interpolation(n, x_vec);
true_vec = 1 ./ (1 + 25 * x_vec.^2);

fprintf('\n多点插值结果 (n = %d):\n', n);
fprintf('  x\t\tP_n(x)\t\tf(x)\t\t|Error|\n');
for k = 1:length(x_vec)
    fprintf('  %6.3f\t%10.6f\t%10.6f\t%10.2e\n', ...
        x_vec(k), P_vec(k), true_vec(k), abs(P_vec(k)-true_vec(k)));
end