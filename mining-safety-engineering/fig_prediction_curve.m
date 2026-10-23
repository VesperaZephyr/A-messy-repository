clear; clc; close all;

% 时间轴（分钟）
t = 0:10:60;

% 各模型预测数据
LSTM_pred        = [0.45, 0.52, 0.58, 0.63, 0.67, 0.70, 0.72];
GRU_pred         = [0.46, 0.54, 0.60, 0.65, 0.69, 0.71, 0.73];
Transformer_pred = [0.44, 0.51, 0.59, 0.66, 0.70, 0.74, 0.77];
True_val         = [0.45, 0.53, 0.61, 0.67, 0.71, 0.75, 0.78];

% 插值到更密的点以获得平滑曲线
t_fine = 0:1:60;
LSTM_fine  = interp1(t, LSTM_pred, t_fine, 'pchip');
GRU_fine   = interp1(t, GRU_pred, t_fine, 'pchip');
Trans_fine = interp1(t, Transformer_pred, t_fine, 'pchip');
True_fine  = interp1(t, True_val, t_fine, 'pchip');

% 绘图
figure('Position', [100, 100, 800, 520], 'Color', 'w');
hold on; box on;

p1 = plot(t_fine, LSTM_fine, '-o', 'LineWidth', 1.5, ...
    'MarkerSize', 5, 'Color', [0.00 0.45 0.74], ...
    'MarkerFaceColor', [0.00 0.45 0.74]);
p2 = plot(t_fine, GRU_fine, '-s', 'LineWidth', 1.5, ...
    'MarkerSize', 5, 'Color', [0.85 0.33 0.10], ...
    'MarkerFaceColor', [0.85 0.33 0.10]);
p3 = plot(t_fine, Trans_fine, '-^', 'LineWidth', 1.5, ...
    'MarkerSize', 5, 'Color', [0.47 0.67 0.19], ...
    'MarkerFaceColor', [0.47 0.67 0.19]);
p4 = plot(t_fine, True_fine, '--k', 'LineWidth', 2.0);

% 坐标轴设置
xlim([0 60]);
ylim([0.2 1.0]);
set(gca, 'XTick', 0:10:60);
set(gca, 'YTick', 0.2:0.1:1.0);

xlabel('时间步（分钟）', 'FontSize', 12, 'FontName', '宋体');
ylabel('瓦斯浓度预测值（%）', 'FontSize', 12, 'FontName', '宋体');
title('不同模型对未来60分钟瓦斯浓度的预测结果对比', ...
    'FontSize', 14, 'FontName', '黑体', 'FontWeight', 'bold');

grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);

legend([p1, p2, p3, p4], ...
    {'LSTM', 'GRU', 'Transformer', '真实值'}, ...
    'Location', 'northwest', 'FontSize', 11);

set(gca, 'LineWidth', 1.0);

% 保存图片
print(gcf, 'fig_prediction_curve.pdf', '-dpdf', '-r300');
fprintf('图片已成功保存为 fig_prediction_curve.pdf\n');