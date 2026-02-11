% ODE IVP Solver: y' = -20(y-sin(t)) + cos(t), y(0) = 1
% clear up everything 
clear all; 
close all; 
clc;



% ODE IVP Solver: y' = -20(y-sin(t)) + cos(t), y(0) = 1

% Define the ODE function
odefun = @(t, y) -20*(y - sin(t)) + cos(t);

% Exact solution function
exact_solution = @(t) exp(-20*t) + sin(t);

% Initial conditions
y0 = 1;
t0 = 0;
tf = 2.5
tspan = [0 tf];  % Solve from t=0 to t=10

% Solve using ode45
[t_ode45, y_ode45] = ode45(odefun, tspan, y0);

% Generate exact solution points
t_exact = linspace(t0, tf, 1000);
y_exact = exact_solution(t_exact);

% Compute absolute error
interp_exact = interp1(t_exact, y_exact, t_ode45);
absolute_error = abs(interp_exact - y_ode45);
max_absolute_error = max(absolute_error);
mean_absolute_error = mean(absolute_error);

% Plotting
figure;

% Subplot 1: Numerical vs Exact Solution
subplot(2,1,1);
plot(t_ode45, y_ode45, 'b-', t_exact, y_exact, 'r--');
title('Numerical vs Exact Solution');
xlabel('Time (t)');
ylabel('y(t)');
legend('ode45 Numerical', 'Exact Solution');
grid on;

% Subplot 2: Absolute Error
subplot(2,1,2);
plot(t_ode45, absolute_error, 'g-');
title('Absolute Error');
xlabel('Time (t)');
ylabel('|Exact - Numerical|');
grid on;

% Display error statistics
fprintf('Maximum Absolute Error: %e\n', max_absolute_error);
fprintf('Mean Absolute Error: %e\n', mean_absolute_error);