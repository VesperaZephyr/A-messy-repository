function P = lagrange_interpolation_chebyshev(n, x)
    % Chebyshev 节点
    k = 0:n;
    x_nodes = cos(k * pi / n);
    y_nodes = 1 ./ (1 + 25 * x_nodes.^2);
    
    P = zeros(size(x));
    for i = 0:n
        L = ones(size(x));
        xi = x_nodes(i+1);
        for j = 0:n
            if j ~= i
                L = L .* (x - x_nodes(j+1)) / (xi - x_nodes(j+1));
            end
        end
        P = P + y_nodes(i+1) * L;
    end
end