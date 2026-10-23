clear; clc;
f = @(x) exp(-5*x.^2);
a = 0; b = 3;
I_exact = integral(f, a, b, 'RelTol',1e-12, 'AbsTol',1e-14);
fprintf('高精度参考值 = %.12f\n\n', I_exact);

% ----------------- 等距节点方法 -----------------
% 梯形法（2 个端点）
tic;
x_trap = [a, b];
I_trap = (b-a)/2 * (f(x_trap(1)) + f(x_trap(2)));
t_trap = toc;
err_trap = abs(I_trap - I_exact);

% Simpson 1/3（3 个等距节点）
tic;
x_simp = [a, (a+b)/2, b];
I_simp = (b-a)/6 * (f(x_simp(1)) + 4*f(x_simp(2)) + f(x_simp(3)));
t_simp = toc;
err_simp = abs(I_simp - I_exact);

% ----------------- Gauss-Legendre 方法 -----------------
% 2 点 Gauss
tic;
t2 = [-1/sqrt(3), 1/sqrt(3)];
w2 = [1, 1];
x_gl2 = (a+b)/2 + (b-a)/2 * t2;
I_gl2 = (b-a)/2 * sum(w2 .* f(x_gl2));
t_gl2 = toc;
err_gl2 = abs(I_gl2 - I_exact);

% 3 点 Gauss
tic;
t3 = [-sqrt(3/5), 0, sqrt(3/5)];
w3 = [5/9, 8/9, 5/9];
x_gl3 = (a+b)/2 + (b-a)/2 * t3;
I_gl3 = (b-a)/2 * sum(w3 .* f(x_gl3));
t_gl3 = toc;
err_gl3 = abs(I_gl3 - I_exact);

% ----------------- 输出比较 -----------------
fprintf('方法          节点数  近似值            绝对误差          耗时(s)\n');
fprintf('----------------------------------------------------------------\n');
fprintf('梯形法        %2d      %.12f   %.6e   %.6f\n', 2, I_trap, err_trap, t_trap);
fprintf('Gauss 2 点    %2d      %.12f   %.6e   %.6f\n', 2, I_gl2, err_gl2, t_gl2);
fprintf('Simpson 1/3   %2d      %.12f   %.6e   %.6f\n', 3, I_simp, err_simp, t_simp);
fprintf('Gauss 3 点    %2d      %.12f   %.6e   %.6f\n', 3, I_gl3, err_gl3, t_gl3);