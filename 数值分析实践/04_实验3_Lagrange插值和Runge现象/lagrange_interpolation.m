function P = lagrange_interpolation(n, x)
% 计算 Lagrange 插值多项式 P_n(x) 在点 x 处的值
% 插值节点: 等距节点 x_i = -1 + 2i/n, i = 0,1,...,n
% 被插函数: f(x) = 1/(1+25x^2), x ∈ [-1,1]
% 输入: 
%   n : 等分份数
%   x : 求值点（标量或向量）
% 输出: 
%   P : P_n(x) 的值，与 x 尺寸相同

    % 节点与函数值
    j = 0:n;
    x_nodes = -1 + 2 * j / n;
    y_nodes = 1 ./ (1 + 25 * x_nodes.^2);

    % 初始化为零
    P = zeros(size(x));

    % 累加 y_i * l_i(x)
    for i = 0:n
        P = P + y_nodes(i+1) * lagrange_basis(n, i, x);
    end
end