% 两点边值问题: -u'' + c(x)u = f(x), x in [0, L]
% u(0)=0, u(L)=0
clear; clc;

L = 10;
c = @(x) 1 + 0.5*sin(x);
f = @(x) sin(pi*x/L);

n_list = [20, 40, 80];

% 参考解 (极细网格)
n_ref = 1280;
h_ref = L / n_ref;
x_ref = linspace(0, L, n_ref+1)';
x_ref_in = x_ref(2:end-1);
N_ref = n_ref - 1;   % 内点数

% 构造参考解矩阵 (三对角对称正定)
main_diag_ref = 2/h_ref^2 + c(x_ref_in);      % N_ref × 1
sub_diag_vals = -1/h_ref^2 * ones(N_ref-1, 1); % 次对角线元素
% 将三列都填充为 N_ref 行
B_ref = [ [sub_diag_vals; 0], main_diag_ref, [0; sub_diag_vals] ];
A_ref = spdiags(B_ref, [-1 0 1], N_ref, N_ref);
b_ref = f(x_ref_in);
u_ref = A_ref \ b_ref;

% 存储误差和步长
E_rel = zeros(size(n_list));
h_vals = zeros(size(n_list));

fprintf('   n       h           E_rel\n');
fprintf('-----------------------------\n');

for idx = 1:length(n_list)
    n = n_list(idx);
    h = L / n;
    h_vals(idx) = h;
    x = linspace(0, L, n+1)';
    x_in = x(2:end-1);
    N = n - 1;   % 内点数

    % 构造矩阵 A
    main_diag = 2/h^2 + c(x_in);
    sub_diag_vals = -1/h^2 * ones(N-1, 1);
    B = [ [sub_diag_vals; 0], main_diag, [0; sub_diag_vals] ];
    A = spdiags(B, [-1 0 1], N, N);
    b = f(x_in);
    u_n = A \ b;

    % 提取参考解在粗网格内点上的值 (注意整除)
    idx_ref = (1:N)' * (n_ref / n);
    u_ref_coarse = u_ref(idx_ref);

    % 相对误差 (2-范数)
    err = norm(u_n - u_ref_coarse) / norm(u_ref_coarse);
    E_rel(idx) = err;
    fprintf('  %2d     %.4f     %12.6e\n', n, h, err);
end

% 收敛阶
if length(n_list) >= 3
    p1 = log2(E_rel(1) / E_rel(2));
    p2 = log2(E_rel(2) / E_rel(3));
    fprintf('\n收敛阶:\n');
    fprintf('  n=20 -> n=40 : %.4f\n', p1);
    fprintf('  n=40 -> n=80 : %.4f\n', p2);
end

% ===== 绘制误差随 h 的变化趋势（双对数图） =====
figure;
loglog(h_vals, E_rel, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 8);
hold on;

% 二阶参考线（从第一个数据点开始，斜率为2）
p = 2;
ref_curve = E_rel(1) * (h_vals / h_vals(1)).^p;
loglog(h_vals, ref_curve, 'r--', 'LineWidth', 1.2);

xlabel('步长 h');
ylabel('相对误差 E_{rel}');
title('误差随步长变化及二阶收敛验证');
legend('实际误差', 'O(h^2) 参考线', 'Location', 'northwest');
grid on;
hold off;