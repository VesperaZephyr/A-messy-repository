clear; clc; close all;
rng(42); % 固定随机种子保证可复现

% ================= 1. 生成模拟数据 =================
% 辅助匿名函数：根据五数概括生成模拟数据（纯基础函数）
gen_data = @(lw, lq, med, uq, uw, n) sort(max(min([ ...
    lq + (med-lq)*randn(floor(n/2),1)*0.6; ...
    lw + (lq-lw)*rand(round(floor(n/2)*0.1),1); ...
    med + (uq-med)*randn(n-floor(n/2),1)*0.6; ...
    uq + (uw-uq)*rand(round((n-floor(n/2))*0.1),1) ...
    ], lw-0.01), uw+0.01));

N = 100; % 每组样本数
data_base = gen_data(0.08, 0.12, 0.15, 0.19, 0.24, N);
data_attn = gen_data(0.07, 0.11, 0.14, 0.18, 0.23, N);
data_conv = gen_data(0.09, 0.13, 0.16, 0.20, 0.25, N);
data_full = gen_data(0.05, 0.08, 0.10, 0.13, 0.18, N);

all_data = {data_base, data_attn, data_conv, data_full};
labels = {'Base', '-Attn', '-Conv', 'Full Model'};
colors = [0.00 0.45 0.74; 0.85 0.33 0.10; 0.93 0.69 0.13; 0.47 0.67 0.19];

% ================= 2. 手动计算统计量并绘图 =================
figure('Position', [100, 100, 800, 500], 'Color', 'w');
hold on; box on;

width = 0.4; % 箱体宽度

for i = 1:4
    data = sort(all_data{i});
    n = length(data);
    
    % 计算五数概括 (免工具箱算法)
    q1 = data(round(n * 0.25));
    med = data(round(n * 0.5));
    q3 = data(round(n * 0.75));
    iqr = q3 - q1;
    
    % 计算上下须 (1.5倍IQR规则)
    lower_fence = q1 - 1.5 * iqr;
    upper_fence = q3 + 1.5 * iqr;
    
    % 找到须的实际端点（范围内的最大最小值）
    whisker_low = min(data(data >= lower_fence));
    whisker_high = max(data(data <= upper_fence));
    
    % 找出异常值
    outliers = data(data < whisker_low | data > whisker_high);
    
    % --- 绘制箱体 (Box) ---
    patch([i-width/2, i+width/2, i+width/2, i-width/2], ...
          [q1, q1, q3, q3], colors(i,:), ...
          'FaceAlpha', 0.4, 'EdgeColor', colors(i,:), 'LineWidth', 1.5);
          
    % --- 绘制中位线 (Median) ---
    line([i-width/2, i+width/2], [med, med], ...
         'Color', 'k', 'LineWidth', 2.5);
         
    % --- 绘制上下须 (Whiskers) ---
    % 垂直线
    line([i, i], [whisker_low, q1], 'Color', 'k', 'LineWidth', 1.2);
    line([i, i], [q3, whisker_high], 'Color', 'k', 'LineWidth', 1.2);
    % 水平端点线
    line([i-width/4, i+width/4], [whisker_low, whisker_low], 'Color', 'k', 'LineWidth', 1.2);
    line([i-width/4, i+width/4], [whisker_high, whisker_high], 'Color', 'k', 'LineWidth', 1.2);
    
    % --- 绘制异常值 (Outliers) ---
    if ~isempty(outliers)
        plot(i*ones(size(outliers)), outliers, 'o', ...
             'MarkerEdgeColor', colors(i,:), 'MarkerFaceColor', colors(i,:), ...
             'MarkerSize', 5);
    end
end

% ================= 3. 坐标轴与格式设置 =================
xlim([0.5, 4.5]);
ylim([0, 0.30]);
set(gca, 'XTick', 1:4);
set(gca, 'XTickLabel', labels);
set(gca, 'YTick', 0:0.05:0.30);

xlabel('模型变体', 'FontSize', 12, 'FontName', '宋体');
ylabel('绝对误差分布（%）', 'FontSize', 12, 'FontName', '宋体');
title('各模型预测误差分布的箱线图比较', ...
    'FontSize', 14, 'FontName', '黑体', 'FontWeight', 'bold');

grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.3);
set(gca, 'LineWidth', 1.0);

% ================= 4. 保存图片 =================
print(gcf, 'fig_error_boxplot.pdf', '-dpdf', '-r300');
fprintf('免工具箱版箱线图已成功保存为 fig_error_boxplot.pdf\n');