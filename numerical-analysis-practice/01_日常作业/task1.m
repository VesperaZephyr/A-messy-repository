clear; clc; close all;

a_list = [0.05, 15];
N = 22;
n_max = 20;
n_values = 0:n_max;
num_n = n_max + 1;

% 用于存储结果的结构
results = struct();

for idx = 1:length(a_list)
    a = a_list(idx);
    fprintf('=========================\n');
    fprintf('  a = %.2f\n', a);
    fprintf('=========================\n');
    
    % ---------- 真值（高精度数值积分）----------
    I_true = zeros(1, num_n);
    for k = 1:num_n
        n = n_values(k);
        I_true(k) = integral(@(x) x.^n ./ (a + x), 0, 1, ...
                             'AbsTol', 1e-14, 'RelTol', 1e-14);
    end
    
    % ---------- 方案 I ----------
    I1 = zeros(1, num_n);
    I1(1) = log((a + 1) / a);   % I0
    for n = 1:n_max
        I1(n+1) = -a * I1(n) + 1/n;
    end
    
    % ---------- 方案 II（反向递推）----------
    I2_all = zeros(1, N+1);     % 下标 1 对应 I0，N+1 对应 I_N
    % 估计递推初值 I_N
    if a >= N / (N + 1)
        I2_all(N+1) = (2*a + 1) / (2 * a * (a + 1) * (N + 1));
    else
        I2_all(N+1) = 0.5 * (1 / ((a + 1) * (N + 1)) + 1 / N);
    end
    % 反向递推 I_{n-1} = (1/n - I_n)/a
    for n = N:-1:1
        I2_all(n) = (1/n - I2_all(n+1)) / a;
    end
    I2 = I2_all(1:num_n);   % 取 I0 ~ I20
    
    % ---------- 误差 ----------
    err1 = abs(I1 - I_true);
    err2 = abs(I2 - I_true);
    
    % ---------- 打印表格 ----------
    fprintf('%-3s  %-18s  %-18s  %-18s  %-14s  %-14s\n', ...
            'n', '真值', '方案I', '方案II', '误差I', '误差II');
    for k = 1:num_n
        n = n_values(k);
        fprintf('%2d  %18.10e  %18.10e  %18.10e  %14.6e  %14.6e\n', ...
                n, I_true(k), I1(k), I2(k), err1(k), err2(k));
    end
    
    % ---------- 绘图 ----------
    figure(idx);
    semilogy(n_values, err1, 'o-', 'LineWidth', 1.5, 'MarkerSize', 6);
    hold on;
    semilogy(n_values, err2, 's-', 'LineWidth', 1.5, 'MarkerSize', 6);
    xlabel('n'); ylabel('绝对误差');
    title(['a = ', num2str(a)]);
    legend('方案 I (正向)', '方案 II (反向)');
    grid on; set(gca, 'FontSize', 12);
    
    % 保存结果以便后续查看
    results(idx).a = a;
    results(idx).I_true = I_true;
    results(idx).I1 = I1;
    results(idx).I2 = I2;
end
