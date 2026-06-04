function LinearSolverMenu()
    % 线性方程组求解器菜单主程序
    % 预设测试矩阵 A 和向量 b (根据题目要求的测试案例)
    % A = rand(100) + 100*eye(100);
    % b = A(:, 1);
    
    % 为了演示方便，这里先生成默认数据，实际运行时直接使用
    n = 100;
    A = rand(n) + 100*eye(n);
    b = A(:, 1);
    
    exit_flag = false;
    
    while ~exit_flag
        % 1. 生成菜单
        choice = menu('线性方程组求解器', ...
                      'Jacobi迭代', ...
                      'Gauss-Seidel迭代', ...
                      'SOR迭代', ...
                      '退出');
        
        % 处理退出逻辑
        if choice == 4 || choice == 0
            exit_flag = true;
            fprintf('\n程序已退出。\n');
            continue;
        end
        
        fprintf('\n--------------------------------------------------\n');
        switch choice
            case 1
                fprintf('您选择了: Jacobi迭代\n');
            case 2
                fprintf('您选择了: Gauss-Seidel迭代\n');
            case 3
                fprintf('您选择了: SOR迭代\n');
        end
        
        % 2. 提示用户输入参数
        try
            % 输入初值 x0
            x0 = input('请输入迭代初值 x0 (例如 rand(100,1)): ');
            if isempty(x0), x0 = rand(n,1); end % 防止空输入报错
            
            % 输入精度 tol
            tol = input('请输入近似解的精度 tol (例如 1e-12): ');
            if isempty(tol), tol = 1e-12; end
            
            % 输入最大迭代次数
            maxit = input('请输入最大迭代次数 maxit (例如 100): ');
            if isempty(maxit), maxit = 100; end
            
            % 针对 SOR 迭代额外输入松弛因子
            w = 1; % 默认值
            if choice == 3
                w = input('请输入松弛因子 omega (0 <= omega <= 2): ');
            end
            
            % 3. 调用求解函数
            k = 0; % 迭代次数
            % 注意：此处假设 A, b 已定义。若需用户输入 A, b 可在此处添加 input
            
            switch choice
                case 1
                    [~, k] = testjacobi(A, b, x0, tol, maxit);
                case 2
                    [~, k] = testgauss(A, b, x0, tol, maxit);
                case 3
                    [~, k] = testsor(A, b, x0, w, tol, maxit);
            end
            
            % 4. 输出结果
            if k < maxit
                fprintf('计算成功！达到精度所需的迭代次数为: %d\n', k);
            else
                fprintf('提示: 在最大迭代次数 (%d) 允许的范围内未收敛。\n', maxit);
            end
            
        catch ME
            fprintf('输入有误或计算出错: %s\n', ME.message);
        end
    end
end

%% --- 局部函数定义 (为了代码可直接运行，将算法包含在内) ---

function [x, k] = testjacobi(A, b, x0, tol, maxit)
    n = length(b); x = x0; k = 0;
    while k < maxit
        x_new = zeros(n, 1);
        for i = 1:n
            sigma = A(i, :) * x - A(i, i) * x(i);
            x_new(i) = (b(i) - sigma) / A(i, i);
        end
        if norm(b - A*x_new) < tol, k=k+1; x=x_new; return; end
        x = x_new; k = k + 1;
    end
end

function [x, k] = testgauss(A, b, x0, tol, maxit)
    n = length(b); x = x0; k = 0;
    while k < maxit
        for i = 1:n
            sigma = A(i, :) * x - A(i, i) * x(i);
            x(i) = (b(i) - sigma) / A(i, i);
        end
        if norm(b - A*x) < tol, k=k+1; return; end
        k = k + 1;
    end
end

function [x, k] = testsor(A, b, x0, w, tol, maxit)
    n = length(b); x = x0; k = 0;
    while k < maxit
        for i = 1:n
            sigma = A(i, :) * x - A(i, i) * x(i);
            x_gs = (b(i) - sigma) / A(i, i);
            x(i) = (1 - w) * x(i) + w * x_gs;
        end
        if norm(b - A*x) < tol, k=k+1; return; end
        k = k + 1;
    end
end