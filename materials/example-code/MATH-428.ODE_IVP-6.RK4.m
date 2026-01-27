% Solve y' = (1-2t)y, y(0) = 1 using RK4, Heun's, and Forward Euler methods

clear all; 

% Parameters
t0 = 0;          % Initial time
tf = 2;          % Final time
h = 0.2;         % Step size
N = (tf-t0)/h;   % Number of steps

% Initialize arrays
t = t0:h:tf;     % Time points
y_rk4 = zeros(1,N+1);     % Solution array for RK4
y_heun = zeros(1,N+1);    % Solution array for Heun's method
y_euler = zeros(1,N+1);   % Solution array for Forward Euler
y_rk4(1) = 1;            % Initial condition y(0) = 1
y_heun(1) = 1;           % Initial condition y(0) = 1
y_euler(1) = 1;          % Initial condition y(0) = 1

% ODE function
f = @(t,y) (1-2*t)*y;

% Implement all three methods
for n = 1:N
    % Forward Euler method
    y_euler(n+1) = y_euler(n) + h*f(t(n), y_euler(n));
    
    % Heun's method (predictor-corrector)
    y_pred = y_heun(n) + h*f(t(n), y_heun(n));
    y_heun(n+1) = y_heun(n) + (h/2)*(f(t(n), y_heun(n)) + f(t(n+1), y_pred));
    
    % RK4 method
    k1 = f(t(n), y_rk4(n));
    k2 = f(t(n) + h/2, y_rk4(n) + h*k1/2);
    k3 = f(t(n) + h/2, y_rk4(n) + h*k2/2);
    k4 = f(t(n) + h, y_rk4(n) + h*k3);
    y_rk4(n+1) = y_rk4(n) + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end

% Calculate exact solution y = exp(t - t^2)
t_exact = linspace(t0, tf, 200);
y_exact = exp(t_exact - t_exact.^2);
y_exact_at_t = exp(t - t.^2);

% Create solution plot
figure;
plot(t, y_rk4, 'mo-', 'LineWidth', 1.5, 'DisplayName', 'RK4');
hold on;
plot(t, y_heun, 'go-', 'LineWidth', 1.5, 'DisplayName', "Heun's Method");
plot(t, y_euler, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Forward Euler');
plot(t_exact, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Exact Solution');
xlabel('t');
ylabel('y');
title("Comparison of Numerical Methods for y' = (1-2t)y, y(0) = 1");
legend('Location', 'best');
grid on;

% Error Analysis
fprintf('\n-------- ERROR ANALYSIS --------\n\n');

% 1. Maximum Absolute Error
max_error_rk4 = max(abs(y_rk4 - y_exact_at_t));
max_error_heun = max(abs(y_heun - y_exact_at_t));
max_error_euler = max(abs(y_euler - y_exact_at_t));
fprintf('1. Maximum Absolute Error:\n');
fprintf('   RK4 method:     %e\n', max_error_rk4);
fprintf("   Heun's method:  %e\n", max_error_heun);
fprintf('   Forward Euler:  %e\n', max_error_euler);

% 2. Root Mean Square Error (RMSE)
rmse_rk4 = sqrt(mean((y_rk4 - y_exact_at_t).^2));
rmse_heun = sqrt(mean((y_heun - y_exact_at_t).^2));
rmse_euler = sqrt(mean((y_euler - y_exact_at_t).^2));
fprintf('\n2. Root Mean Square Error (RMSE):\n');
fprintf('   RK4 method:     %e\n', rmse_rk4);
fprintf("   Heun's method:  %e\n", rmse_heun);
fprintf('   Forward Euler:  %e\n', rmse_euler);

% 3. Mean Absolute Error (MAE)
mae_rk4 = mean(abs(y_rk4 - y_exact_at_t));
mae_heun = mean(abs(y_heun - y_exact_at_t));
mae_euler = mean(abs(y_euler - y_exact_at_t));
fprintf('\n3. Mean Absolute Error (MAE):\n');
fprintf('   RK4 method:     %e\n', mae_rk4);
fprintf("   Heun's method:  %e\n", mae_heun);
fprintf('   Forward Euler:  %e\n', mae_euler);

% 4. Relative Error Analysis
rel_error_rk4 = abs((y_rk4 - y_exact_at_t)./y_exact_at_t);
rel_error_heun = abs((y_heun - y_exact_at_t)./y_exact_at_t);
rel_error_euler = abs((y_euler - y_exact_at_t)./y_exact_at_t);

max_rel_error_rk4 = max(rel_error_rk4);
max_rel_error_heun = max(rel_error_heun);
max_rel_error_euler = max(rel_error_euler);

fprintf('\n4. Maximum Relative Error:\n');
fprintf('   RK4 method:     %e\n', max_rel_error_rk4);
fprintf("   Heun's method:  %e\n", max_rel_error_heun);
fprintf('   Forward Euler:  %e\n', max_rel_error_euler);

% 5. Detailed error at selected points
fprintf('\n5. Detailed Error Analysis at Selected Points:\n');
fprintf('t\tRK4 Error\tHeun Error\tEuler Error\n');
fprintf('--------------------------------------------------------\n');
for i = 1:5:length(t)
    fprintf('%.2f\t%e\t%e\t%e\n', ...
        t(i), ...
        abs(y_rk4(i) - y_exact_at_t(i)), ...
        abs(y_heun(i) - y_exact_at_t(i)), ...
        abs(y_euler(i) - y_exact_at_t(i)));
end

% 6. Relative Performance Comparison
fprintf('\n6. Performance Comparison (relative to Forward Euler):\n');
fprintf('Improvement Percentages:\n');
fprintf('RK4 vs Forward Euler:\n');
fprintf('   Maximum Absolute Error:  %.2f%%\n', (max_error_euler - max_error_rk4)/max_error_euler * 100);
fprintf('   RMSE:                   %.2f%%\n', (rmse_euler - rmse_rk4)/rmse_euler * 100);
fprintf('   MAE:                    %.2f%%\n', (mae_euler - mae_rk4)/mae_euler * 100);
fprintf('   Maximum Relative Error: %.2f%%\n\n', (max_rel_error_euler - max_rel_error_rk4)/max_rel_error_euler * 100);

fprintf('Heun vs Forward Euler:\n');
fprintf('   Maximum Absolute Error:  %.2f%%\n', (max_error_euler - max_error_heun)/max_error_euler * 100);
fprintf('   RMSE:                   %.2f%%\n', (rmse_euler - rmse_heun)/rmse_euler * 100);
fprintf('   MAE:                    %.2f%%\n', (mae_euler - mae_heun)/mae_euler * 100);
fprintf('   Maximum Relative Error: %.2f%%\n', (max_rel_error_euler - max_rel_error_heun)/max_rel_error_euler * 100);

% Create error plot
figure;
semilogy(t, abs(y_rk4 - y_exact_at_t), 'm-', 'LineWidth', 1.5, 'DisplayName', 'RK4 Error');
hold on;
semilogy(t, abs(y_heun - y_exact_at_t), 'g-', 'LineWidth', 1.5, 'DisplayName', "Heun's Error");
semilogy(t, abs(y_euler - y_exact_at_t), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Forward Euler Error');
xlabel('t');
ylabel('Absolute Error (log scale)');
title('Error Comparison of Numerical Methods');
legend('Location', 'best');
grid on;


%This implementation includes:
%
%1. Three numerical methods:
%   - RK4 (fourth-order)
%   - Heun's method (second-order)
%   - Forward Euler method (first-order)
%
%2. Comprehensive error analysis:
%   - Maximum Absolute Error
%   - Root Mean Square Error (RMSE)
%   - Mean Absolute Error (MAE)
%   - Relative Error Analysis
%   - Point-by-point error comparison
%   - Performance improvement metrics
%
%
%The results show the increasing accuracy from:
%1. Forward Euler (first-order)
%2. Heun's method (second-order)
%3. RK4 (fourth-order)

