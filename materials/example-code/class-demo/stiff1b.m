clear all;
clc
%
% Main script to solve the stiff ODE system
% x' = -2x + y
% y' = 998x - 999y
% with initial conditions x(0) = 1, y(0) = 1

% Define the time span
tspan = [0 10];  % Solve from t=0 to t=10

% Initial conditions
y0 = [-1; 1];    % [x(0); y(0)]

% Solve the ODE system using ode45
[t, y] = ode45(@odefun, tspan, y0);

% Create a figure with two subplots
figure('Position', [100 100 1000 400])

% Plot x(t)
subplot(1,2,1)
plot(t, y(:,1), 'b-', 'LineWidth', 1.5)
grid on
xlabel('$t$', 'Interpreter', 'latex')
ylabel('$x(t)$', 'Interpreter', 'latex')
title('$\frac{dx}{dt} = -2x + y$', 'Interpreter', 'latex')
set(gca, 'FontSize', 12)

% Plot y(t)
subplot(1,2,2)
plot(t, y(:,2), 'r-', 'LineWidth', 1.5)
grid on
xlabel('$t$', 'Interpreter', 'latex')
ylabel('$y(t)$', 'Interpreter', 'latex')
title('$\frac{dy}{dt} = 998x - 999y$', 'Interpreter', 'latex')
set(gca, 'FontSize', 12)


% Function defining the ODE system
function dydt = odefun(t, y)
    % y(1) is x, y(2) is y
    dydt = zeros(2,1);
    
    % Define the system of ODEs
    dydt(1) = -2*y(1) + y(2);        % x' = -2x + y
    dydt(2) = 998*y(1) - 999*y(2);   % y' = 998x - 999y
end