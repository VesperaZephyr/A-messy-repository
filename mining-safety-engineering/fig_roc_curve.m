%% fig_roc_curve.m
%  多灾种联动预警系统的ROC曲线与AUC值
clear; clc; close all;

% ROC 曲线数据点（与原文 TikZ 一致）
FPR = [0.00, 0.02, 0.05, 0.10, 0.15, 0.20, 0.30, 0.40, 0.50, ...
       0.60, 0.70, 0.80, 0.90, 1.00];
TPR = [0.00, 0.35, 0.58, 0.72, 0.78, 0.83, 0.88, 0.91, 0.93, ...
       0.94, 0.95, 0.96, 0.97, 1.00];

% 插值获得平滑曲线
fpr_fine = linspace(0, 1, 500);
tpr_fine = interp1(FPR, TPR, fpr_fine, 'pchip');

%% 绘图
figure('Position', [100, 100, 640, 640], 'Color', 'w');  % 正方形
hold on; box on;

% 绘制 ROC 曲线
p1 = plot(fpr_fine, tpr_fine, '-', 'LineWidth', 2.5, 'Color', [0.00 0.45 0.74]);

% 绘制 AUC 填充区域
fill([fpr_fine, 1, 0], [tpr_fine, 0, 0], [0.00 0.45 0.74], ...
     'FaceAlpha', 0.10, 'EdgeColor', 'none');

% 绘制随机分类器对角线
p2 = plot([0 1], [0 1], '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.5);

% 添加 AUC 标注文本
text(0.55, 0.30, sprintf('AUC = 0.943\n准确率 = 91.2%%'), ...
    'FontSize', 12, 'FontName', '宋体', ...
    'BackgroundColor', [1 1 1 0.8], 'EdgeColor', 'k', 'LineWidth', 0.5, ...
    'HorizontalAlignment', 'center');

% 坐标轴设置
xlim([0 1]);
ylim([0 1]);
set(gca, 'XTick', 0:0.2:1);
set(gca, 'YTick', 0:0.2:1);
set(gca, 'XTickLabel', {'0','0.2','0.4','0.6','0.8','1.0'});
set(gca, 'YTickLabel', {'0','0.2','0.4','0.6','0.8','1.0'});
axis equal;

xlabel('假正率（FPR）', 'FontSize', 13, 'FontName', '宋体');
ylabel('真正率（TPR）', 'FontSize', 13, 'FontName', '宋体');
title('多灾种联动预警系统的ROC曲线与AUC值', 'FontSize', 14, 'FontName', '黑体', 'FontWeight', 'bold');

grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);

legend([p1, p2], {'预警模型（AUC = 0.943）', '随机分类器'}, ...
    'Location', 'southeast', 'FontSize', 11);

set(gca, 'LineWidth', 1.0);

% 保存图片
print(gcf, 'fig_roc_curve.pdf', '-dpdf', '-r300');

fprintf('ROC曲线已保存。\n');