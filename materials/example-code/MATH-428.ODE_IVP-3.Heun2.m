% Solve y' = (1-2t)y, y(0) = 1 using both Heun's method and Forward Euler

clear all; 

% Parameters
t0 = 0;          % Initial time
tf = 3;          % Final time
h = 0.1;         % Step size
N = (tf-t0)/h;   % Number of steps

% Initialize arrays
t = t0:h:tf;     % Time points
y_heun = zeros(1,N+1);    % Solution array for Heun's method
y_euler = zeros(1,N+1);   % Solution array for Forward Euler
y_heun(1) = 1;           % Initial condition y(0) = 1
y_euler(1) = 1;          % Initial condition y(0) = 1

% ODE function
f = @(t,y) (1-2*t)*y;

% Implement both methods
for n = 1:N
    % Forward Euler method
    y_euler(n+1) = y_euler(n) + h*f(t(n), y_euler(n));
    
    % Heun's method (predictor-corrector)
    % Predictor (Forward Euler)
    y_pred = y_heun(n) + h*f(t(n), y_heun(n));
    % Corrector (Trapezoidal rule)
    y_heun(n+1) = y_heun(n) + (h/2)*(f(t(n), y_heun(n)) + f(t(n+1), y_pred));
end

% Calculate exact solution y = exp(t - t^2)
t_exact = linspace(t0, tf, 200);
y_exact = exp(t_exact - t_exact.^2);
y_exact_at_t = exp(t - t.^2);

% Create plot
figure;
plot(t, y_heun, 'go-', 'LineWidth', 1.5, 'DisplayName', "Heun's Method");
hold on;
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
max_error_heun = max(abs(y_heun - y_exact_at_t));
max_error_euler = max(abs(y_euler - y_exact_at_t));
fprintf('1. Maximum Absolute Error:\n');
fprintf("   Heun's method:  %e\n", max_error_heun);
fprintf('   Forward Euler:  %e\n', max_error_euler);

% 2. Root Mean Square Error (RMSE)
rmse_heun = sqrt(mean((y_heun - y_exact_at_t).^2));
rmse_euler = sqrt(mean((y_euler - y_exact_at_t).^2));
fprintf('\n2. Root Mean Square Error (RMSE):\n');
fprintf("   Heun's method:  %e\n", rmse_heun);
fprintf('   Forward Euler:  %e\n', rmse_euler);

% 3. Mean Absolute Error (MAE)
mae_heun = mean(abs(y_heun - y_exact_at_t));
mae_euler = mean(abs(y_euler - y_exact_at_t));
fprintf('\n3. Mean Absolute Error (MAE):\n');
fprintf("   Heun's method:  %e\n", mae_heun);
fprintf('   Forward Euler:  %e\n', mae_euler);

% 4. Relative Error at each point
rel_error_heun = abs((y_heun - y_exact_at_t)./y_exact_at_t);
rel_error_euler = abs((y_euler - y_exact_at_t)./y_exact_at_t);

% Maximum Relative Error
max_rel_error_heun = max(rel_error_heun);
max_rel_error_euler = max(rel_error_euler);
fprintf('\n4. Maximum Relative Error:\n');
fprintf("   Heun's method:  %e\n", max_rel_error_heun);
fprintf('   Forward Euler:  %e\n', max_rel_error_euler);

% 5. Detailed error at selected points
fprintf('\n5. Detailed Error Analysis at Selected Points:\n');
fprintf('t\tHeun Error\tEuler Error\tHeun Rel.Error\tEuler Rel.Error\n');
fprintf('----------------------------------------------------------------\n');
for i = 1:5:length(t)
    fprintf('%.2f\t%e\t%e\t%e\t%e\n', ...
        t(i), ...
        abs(y_heun(i) - y_exact_at_t(i)), ...
        abs(y_euler(i) - y_exact_at_t(i)), ...
        rel_error_heun(i), ...
        rel_error_euler(i));
end

% 6. Performance Improvement
fprintf('\n6. Performance Comparison:\n');
fprintf('Heun vs Euler Improvement Percentages:\n');
fprintf('   Maximum Absolute Error:  %.2f%%\n', (max_error_euler - max_error_heun)/max_error_euler * 100);
fprintf('   RMSE:                   %.2f%%\n', (rmse_euler - rmse_heun)/rmse_euler * 100);
fprintf('   MAE:                    %.2f%%\n', (mae_euler - mae_heun)/mae_euler * 100);
fprintf('   Maximum Relative Error: %.2f%%\n', (max_rel_error_euler - max_rel_error_heun)/max_rel_error_euler * 100);

% Create error plot
figure;
semilogy(t, abs(y_heun - y_exact_at_t), 'g-', 'LineWidth', 1.5, 'DisplayName', "Heun's Method Error");
hold on;
semilogy(t, abs(y_euler - y_exact_at_t), 'b-', 'LineWidth', 1.5, 'DisplayName', 'Forward Euler Error');
xlabel('t');
ylabel('Absolute Error (log scale)');
title('Error Comparison of Numerical Methods');
legend('Location', 'best');
grid on;


%1. Maximum Absolute Error - shows the largest deviation from the exact solution
%2. Root Mean Square Error (RMSE) - measures the average magnitude of errors
%3. Mean Absolute Error (MAE) - average of absolute errors
%4. Relative Error Analysis - shows errors relative to the exact solution
%5. Point-by-point error comparison at selected points
%6. Performance improvement metrics comparing Heun's vs Euler
%
%Additionally, I've added:
%- A second plot showing the absolute errors on a logarithmic scale
%- Detailed printouts of various error metrics
%- Percentage improvements of Heun's method over Forward Euler
%
%The error analysis clearly shows that Heun's method (being a second-order method) generally produces more accurate results than Forward Euler (a first-order method).

