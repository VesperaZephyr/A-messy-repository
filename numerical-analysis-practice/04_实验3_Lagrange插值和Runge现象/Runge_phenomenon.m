x_fixed = 0.91;
f_true = 1 / (1 + 25 * x_fixed^2);
n_values = [3, 5, 8, 10, 15, 20];
errors = zeros(size(n_values));
P_values = zeros(size(n_values));

fprintf('n\tP_n(%.2f)\t\t误差\n', x_fixed);
fprintf('-----------------------------------\n');
for k = 1:length(n_values)
    n = n_values(k);
    Pn = lagrange_interpolation(n, x_fixed);
    errors(k) = abs(Pn - f_true);
    P_values(k) = Pn;
    fprintf('%d\t%.8f\t%.8f\n', n, Pn, errors(k));
end

% 绘图
figure;
semilogy(n_values, errors, 'b-o', 'LineWidth', 2, 'MarkerSize', 8);
grid on; 
xlabel('n', 'FontSize', 12);
ylabel('|P_n(0.91) - f(0.91)|', 'FontSize', 12);
title('固定点 x = 0.91 的插值误差随 n 的变化', 'FontSize', 14);
set(gca, 'FontSize', 11);