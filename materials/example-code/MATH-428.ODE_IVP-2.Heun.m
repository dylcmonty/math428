% Solve y' = (1-2t)y, y(0) = 1 using both Heun's method and Forward Euler

clear all; 
% Parameters
t0 = 0;          % Initial time
tf = 2;          % Final time
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

% Calculate and display maximum errors
error_heun = max(abs(y_heun - exp(t - t.^2)));
error_euler = max(abs(y_euler - exp(t - t.^2)));
fprintf('Maximum absolute errors:\n');
fprintf("Heun's method: %e\n", error_heun);
fprintf('Forward Euler: %e\n', error_euler);

% Display solution at selected points
fprintf('\nSolution comparison at selected points:\n');
fprintf('t\t\tHeun\t\tEuler\t\tExact\n');
for i = 1:5:length(t)
    exact = exp(t(i) - t(i)^2);
    fprintf('%.2f\t\t%.6f\t%.6f\t%.6f\n', t(i), y_heun(i), y_euler(i), exact);
end

% Calculate relative improvement
rel_improvement = (error_euler - error_heun)/error_euler * 100;
fprintf('\nRelative improvement of Heun over Euler: %.2f%%\n', rel_improvement);


%1. Uses both Heun's method and Forward Euler to solve y' = (1-2t)y with y(0) = 1
%2. Shows key differences between the methods:
%   - Forward Euler uses one function evaluation per step
%   - Heun's method uses two function evaluations per step (predictor and corrector)
%3. Compares both methods with the exact solution y = exp(t - t²)
%4. Visualizes all three solutions (Heun's in green, Euler's in blue, exact in red)
%5. Calculates and displays:
%   - Maximum absolute errors for both methods
%   - Solutions at selected points
%   - Relative improvement of Heun's method over Euler
%
%Key observations:
%- Heun's method is generally more accurate than Forward Euler because it's a second-order method
%- Both methods use the same step size h = 0.1
%- The green line (Heun's method) typically stays closer to the red dashed line (exact solution) than the blue line (Forward Euler)

