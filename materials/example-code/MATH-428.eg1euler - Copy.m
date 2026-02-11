% Solve y' = -20(y-sin(t))+cos(t), y(0) = 1 using forward Euler method
% y(t) = e^(-20t) + sin(t) 

clear all;
close all; 

clc;


% Parameters
t0 = 0;          % Initial time
tf = 2.5;          % Final time
h = 0.01;         % Step size
N = floor((tf-t0)/h);   % Number of steps


% Initialize arrays
t = t0:h:tf;     % Time points
y = zeros(1,N+1);% Solution array
y(1) = 1;        % Initial condition y(0) = 1


% Forward Euler method
for n = 1:N
    % y(n+1) = y(n) + h*f(t(n),y(n))
    % where f(t,y) = -20*(y(n)-sin(t(n)) + cos(t(n))
    y(n+1) = y(n) + h*(-20.0*(y(n)-sin(t(n))) + cos(t(n))); % 
end

% Calculate exact solution y = e^(-20t)+sint
t_exact = linspace(t0, tf, 200);
y_exact = exp(-20*t_exact) + sin(t_exact);


% Plot numerical and exact solutions
figure;
plot(t, y, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Forward Euler');
hold on;
plot(t_exact, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Exact Solution');
xlabel('t');
ylabel('y');
title('Solution of y'' = -20(y-sin(t))+cos(t), y(0) = 1');
legend('Location', 'best');
grid on;

% Calculate and display maximum error
error = max(abs(y - (exp(-20*t)+sin(t))));
fprintf('Maximum absolute error: %e\n', error);

% Display solution at selected points
fprintf('\nSolution at selected points:\n');
fprintf('t\t\tNumerical\tExact\t\tError\n');
for i = 1:5:length(t)
    fprintf('%.2f\t\t%.6f\t%.6f\t%.2e\n', t(i), y(i), exp(-20*t(i))+sin(t(i)), ...
           abs(y(i)-(exp(-20*t(i))+sin(t(i)))) );
end



