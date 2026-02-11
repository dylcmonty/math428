% Solve y' = -20(y-sin(t))+cos(t), y(0) = 1 using backwards Euler method
% y(t) = e^(-20t) + sin(t) 

% Set up the numerical parameters
t0 = 0;          % Initial time
tf = 2;          % Final time
h = 0.05;         % Step size
N = floor(tf-t0)/h;   % Number of steps

t = t0:h:tf;     % Time points
y = zeros(1,N+1);% Solution vector
y(1) = 1;        % Initial condition y(0) = 1

% At each time step, we need to solve:
% y(n+1) = y(n) + h*f(t(n+1), y(n+1))
% where f(t,y) = (1-2t)y

% Newton iteration parameters
tol = 1e-6;
maxiter = 100;

% Backward Euler implementation
for n = 1:N
    % where f(t,y) = -20*(y(n)-sin(t(n)) + cos(t(n))
    % forward Euler is y(n+1) = y(n) + h*(-20.0*(y(n)-sin(t(n))) + cos(t(n))); % 
    % (using backwards Euler now)   
    
    y(n+1) = (y(n)+h*(20*sin(t(n+1))+cos(t(n+1)) ) )/(1+20*h);
end

% Compute exact solution y = exp(t - t^2)
t_exact = linspace(t0, tf, 200);
y_exact = exp(-20*t_exact) + sin(t_exact);

% Plot numerical and exact solutions
figure;
plot(t, y, 'bo-', 'LineWidth', 1.5, 'DisplayName', 'Backward Euler');
hold on;
plot(t_exact, y_exact, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Exact Solution');
xlabel('t');
ylabel('y');
title('Solution of y'' = (1-2t)y, y(0) = 1');
legend('Location', 'best');
grid on;

% Calculate and display maximum error
error = max(abs(y - (exp(-20*t)+sin(t))));
fprintf('Maximum absolute error: %e\n', error);

% Display solution at some specific points
fprintf('\nSolution at selected points:\n');
fprintf('t\t\tNumerical\tExact\t\tError\n');
for i = 1:5:length(t)
    fprintf('%.2f\t\t%.6f\t%.6f\t%.2e\n', t(i), y(i), exp(-20*t(i))+sin(t(i)), ...
           abs(y(i)-(exp(-20*t(i))+sin(t(i)))) );
end

