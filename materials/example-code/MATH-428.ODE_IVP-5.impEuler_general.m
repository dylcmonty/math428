% Solve y' = (1-2t)y, y(0) = 1 using backward Euler method

% Set up the numerical parameters
t0 = 0;          % Initial time
tf = 2;          % Final time
h = 0.05;         % Step size
N = (tf-t0)/h;   % Number of steps
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
    % Initial guess (using explicit Euler)
    y_guess = y(n) + h*((1-2*t(n))*y(n));
    
    % Newton iteration
    yn = y_guess;
    for k = 1:maxiter
        % The equation to solve is:
        % yn - y(n) - h*(1-2t(n+1))*yn = 0
        
        % Compute residual
        R = yn - y(n) - h*(1-2*t(n+1))*yn;
        
        % Compute Jacobian
        % J = 1 - h*(1-2t(n+1))
        J = 1 - h*(1-2*t(n+1));
        
        % Update
        delta = -R/J;
        yn = yn + delta;
        
        % Check convergence
        if abs(delta) < tol
            break
        end
    end
    
    y(n+1) = yn;
end

% Compute exact solution y = exp(t - t^2)
t_exact = linspace(t0, tf, 200);
y_exact = exp(t_exact - t_exact.^2);

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
error = max(abs(y - exp(t - t.^2)));
fprintf('Maximum absolute error: %e\n', error);

% Display solution at some specific points
fprintf('\nSolution at selected points:\n');
fprintf('t\t\tNumerical\tExact\t\tError\n');
for i = 1:5:length(t)
    fprintf('%.2f\t\t%.6f\t%.6f\t%.2e\n', t(i), y(i), exp(t(i)-t(i)^2), ...
            abs(y(i)-exp(t(i)-t(i)^2)));
end

