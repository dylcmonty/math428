% Solve y' = (1-2t)y, y(0) = 1 using forward Euler method

clear all;

% Parameters
t0 = 0;          % Initial time
tf = 2;          % Final time
h = 0.2;         % Step size
N = (tf-t0)/h;   % Number of steps

% Initialize arrays
t = t0:h:tf;     % Time points
y = zeros(1,N+1);% Solution array
y(1) = 1;        % Initial condition y(0) = 1

% Forward Euler method
for n = 1:N
    % y(n+1) = y(n) + h*f(t(n),y(n))
    % where f(t,y) = (1-2t)y
    y(n+1) = y(n) + h*((1-2*t(n))*y(n));
end

% Calculate exact solution y = exp(t - t^2)
t_exact = linspace(t0, tf, 200);
y_exact = exp(t_exact - t_exact.^2);

% Plot numerical and exact solutions
figure;
plot(t, y, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Forward Euler');
hold on;
plot(t_exact, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Exact Solution');
xlabel('t');
ylabel('y');
title('Solution of y'' = (1-2t)y, y(0) = 1');
legend('Location', 'best');
grid on;

% Calculate and display maximum error
error = max(abs(y - exp(t - t.^2)));
fprintf('Maximum absolute error: %e\n', error);

% Display solution at selected points
fprintf('\nSolution at selected points:\n');
fprintf('t\t\tNumerical\tExact\t\tError\n');
for i = 1:5:length(t)
    fprintf('%.2f\t\t%.6f\t%.6f\t%.2e\n', t(i), y(i), exp(t(i)-t(i)^2), ...
            abs(y(i)-exp(t(i)-t(i)^2)));
end



%1. Uses forward Euler method to solve y' = (1-2t)y with y(0) = 1 on the interval [0,2]
%2. Uses step size h = 0.1
%3. Compares the numerical solution with the exact solution y = exp(t - t²)
%4. Creates a visualization comparing both solutions
%5. Calculates and displays the error at selected points

%The main difference between this and the backward Euler method is that forward Euler is explicit - we can calculate y(n+1) directly from y(n), without needing to solve a nonlinear equation at each step.
