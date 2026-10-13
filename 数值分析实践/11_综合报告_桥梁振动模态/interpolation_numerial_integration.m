% 桥梁边值问题 - 三次样条插值与数值积分
clear; close all; clc;

L = 10;
c = @(x) 1 + 0.5*sin(x);
f = @(x) sin(pi*x/L);

% ================= 1. 参考解 (n=160) =================
n_ref = 160;
h_ref = L / n_ref;
x_ref = linspace(0, L, n_ref+1)';
xi_ref = x_ref(2:end-1);
N_ref = n_ref - 1;
off_ref = -1/h_ref^2;
main_ref = 2/h_ref^2 + c(xi_ref);
a_ref = off_ref * ones(N_ref-1,1);
d_ref = main_ref;
c_ref = off_ref * ones(N_ref-1,1);
b_ref = f(xi_ref);
u_ref_int = thomas_solver(a_ref, d_ref, c_ref, b_ref);
u_ref = [0; u_ref_int; 0];          % 全节点解 (n_ref+1)×1

% ================= 2. 数值解 (n=20) =================
n20 = 20;
h20 = L / n20;
x20 = linspace(0, L, n20+1)';
xi20 = x20(2:end-1);
N20 = n20 - 1;
off20 = -1/h20^2;
main20 = 2/h20^2 + c(xi20);
a20 = off20 * ones(N20-1,1);
d20 = main20;
c20 = off20 * ones(N20-1,1);
b20 = f(xi20);
u20_int = thomas_solver(a20, d20, c20, b20);
u20 = [0; u20_int; 0];

% ================= 3. 构造五次内部等距节点的三次样条 =================
% 选取内部 5 个等距节点：x = 1,3,5,7,9 (不含端点)
% 加上两个端点 x=0, 10
x_nodes = [0, 1, 3, 5, 7, 9, 10];
% 从 u20 中提取对应位置的函数值 (x20 = 0:0.5:10)
idx20 = [1, 3, 7, 11, 15, 19, 21];   % 对应 x=0,1,3,5,7,9,10
y_nodes = u20(idx20);

% 调用自编自然三次样条函数
pp = natural_cubic_spline(x_nodes', y_nodes');

% ================= 4. 计算 x = 3.75 处的位移 =================
x_query = 3.75;
S_query = ppval(pp, x_query);          % 样条插值

% 参考解在 x=3.75 处的值 (恰好是参考网格节点)
idx_ref_query = round(3.75 / h_ref) + 1;  % 3.75/0.0625 = 60, 索引 61
u_ref_query = u_ref(idx_ref_query);

fprintf('========== 单点插值比较 ==========\n');
fprintf('x = 3.75\n');
fprintf('三次样条值 S(3.75)   = %.10f\n', S_query);
fprintf('参考解 u_ref(3.75)     = %.10f\n', u_ref_query);
fprintf('绝对误差               = %.4e\n', abs(S_query - u_ref_query));
fprintf('相对误差               = %.4e\n\n', abs(S_query - u_ref_query)/abs(u_ref_query));

% ================= 5. 复合辛普森积分 =================
% 积分区间 [4,6], 步长 h_int = 0.1
a_int = 4; b_int = 6; h_int = 0.1;
x_int = a_int : h_int : b_int;            % 区间必须等分，且点数应为奇数（子区间偶数）
if mod(length(x_int)-1, 2) ~= 0
    error('辛普森法则要求子区间数为偶数，请调整步长。');
end
y_int = ppval(pp, x_int);                % 样条求值

% 复合辛普森公式
N_int = length(x_int) - 1;               % 子区间数 (应为偶数)
integral_approx = h_int/3 * ( y_int(1) + ...
                              4*sum(y_int(2:2:end-1)) + ...
                              2*sum(y_int(3:2:end-2)) + ...
                              y_int(end) );
I_approx = integral_approx / 2;          % 平均变形

% 参考解积分：利用参考网格直接计算（网格间隔 0.0625，区间端点恰好是节点）
idx_ref_a = round(a_int / h_ref) + 1;   % a=4 -> 65
idx_ref_b = round(b_int / h_ref) + 1;   % b=6 -> 97
x_ref_int = x_ref(idx_ref_a : idx_ref_b);
u_ref_int = u_ref(idx_ref_a : idx_ref_b);
% 辛普森（参考网格为等距 h_ref，且子区间数为 (97-65)=32，偶数）
integral_ref = h_ref/3 * ( u_ref_int(1) + ...
                           4*sum(u_ref_int(2:2:end-1)) + ...
                           2*sum(u_ref_int(3:2:end-2)) + ...
                           u_ref_int(end) );
I_ref = integral_ref / 2;

fprintf('========== 积分比较 ==========\n');
fprintf('积分区间 [4,6], 步长 h=0.1\n');
fprintf('样条积分 I_approx = %.10f\n', I_approx);
fprintf('参考积分 I_ref    = %.10f\n', I_ref);
fprintf('绝对误差          = %.4e\n', abs(I_approx - I_ref));
fprintf('相对误差          = %.4e\n', abs(I_approx - I_ref)/abs(I_ref));

% ================= 辅助函数 =================

function x = thomas_solver(a, d, c, b)
% 追赶法解三对角线性方程组
N = length(d);
x = zeros(N,1);
for i = 2:N
    w = a(i-1) / d(i-1);
    d(i) = d(i) - w * c(i-1);
    b(i) = b(i) - w * b(i-1);
end
x(N) = b(N) / d(N);
for i = N-1:-1:1
    x(i) = (b(i) - c(i) * x(i+1)) / d(i);
end
end

function pp = natural_cubic_spline(x, y)
% 自然三次样条（边界二阶导为0）
% 输入: x 严格递增列向量, y 函数值列向量
% 输出: pp 结构（可用 ppval 求值）
n = length(x) - 1;   % 区间个数
h = diff(x);         % n 个步长
% 三弯矩方程组 A*M = d
A = zeros(n+1, n+1);
d_vec = zeros(n+1, 1);

% 自然边界 M(1)=0, M(n+1)=0
A(1,1) = 1;   d_vec(1) = 0;
A(n+1,n+1) = 1; d_vec(n+1) = 0;

for i = 2:n
    A(i, i-1) = h(i-1)/6;
    A(i, i)   = (h(i-1)+h(i))/3;
    A(i, i+1) = h(i)/6;
    d_vec(i) = (y(i+1)-y(i))/h(i) - (y(i)-y(i-1))/h(i-1);
end
M = A \ d_vec;   % 弯矩列向量 (n+1)×1

% 构建分段多项式系数矩阵 (每行4个系数, 降幂排列: a3, a2, a1, a0)
coefs = zeros(n, 4);
for i = 1:n
    hi = h(i);
    dx = x(i);   % 区间左端点
    % 由弯矩公式计算系数 (以 (x - x_i) 为变量)
    a3 = (M(i+1) - M(i)) / (6*hi);
    a2 = M(i)/2;
    a1 = (y(i+1)-y(i))/hi - hi*(2*M(i) + M(i+1))/6;
    a0 = y(i);
    % 转化为以 x 为自变量的多项式: 平移多项式
    % S(x) = a0 + a1*(x-x_i) + a2*(x-x_i)^2 + a3*(x-x_i)^3
    % 保存为 pp 结构需要的降幂格式: a3, a2, a1, a0
    coefs(i, :) = [a3, a2, a1, a0];
end

pp = mkpp(x, coefs);
end
