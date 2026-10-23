function L = lagrange_basis(n, i, x)
% 计算 Lagrange 插值基函数 l_i(x) 在点 x 处的值
% 输入：
%   n : 等分份数（共 n+1 个等距节点）
%   i : 基函数下标 (0 <= i <= n)
%   x : 求值点（标量或向量）
% 输出：
%   L : l_i(x) 的值，与 x 尺寸相同

    % 生成等距节点 x_j = -1 + 2j/n, j = 0,1,...,n
    j = 0:n;
    x_nodes = -1 + 2 * j / n;

    % 转换为 MATLAB 下标
    idx_i = i + 1;
    L = ones(size(x));

    % 连乘 (x - x_j) / (x_i - x_j), j ≠ i
    for k = 1:(n+1)
        if k ~= idx_i
            L = L .* (x - x_nodes(k)) / (x_nodes(idx_i) - x_nodes(k));
        end
    end
end
