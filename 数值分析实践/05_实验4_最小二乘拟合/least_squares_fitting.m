% 原始数据
t = [5, 10, 15, 20, 25, 30, 35, 40]';
h = [0.8, 1.6, 2.3, 3.1, 3.8, 4.5, 5.2, 6.0]';
m = length(t);

% 计算统计量
St = sum(t);
Sh = sum(h);
Stt = sum(t.^2);
Sth = sum(t .* h);

% 参数估计
b = (m * Sth - St * Sh) / (m * Stt - St^2);
a = mean(h) - b * mean(t);

fprintf('拟合方程: h = %.4f + %.4f t\n', a, b);
fprintf('初始磨损量 a = %.4f mm\n', a);
fprintf('磨损速率 b = %.4f mm/天\n', b);

% 残差平方和与决定系数
h_pred = a + b * t;
residuals = h - h_pred;
Q = sum(residuals.^2);
SS_res = Q;
SS_tot = sum((h - mean(h)).^2);
R2 = 1 - SS_res / SS_tot;

fprintf('残差平方和 Q = %.6f\n', Q);
fprintf('决定系数 R^2 = %.6f\n', R2);

% 预测报废时间 (h=8.0 mm)
h_target = 8.0;
t_predict = (h_target - a) / b;
fprintf('预测达到 8.0 mm 磨损量的服役天数: t = %.2f 天\n', t_predict);