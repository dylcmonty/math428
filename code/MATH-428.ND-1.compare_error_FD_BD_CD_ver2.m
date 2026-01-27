clear all;

% Define the function and the point of interest
f = @(x) sin(x);
x = 1;
h_values = [0.1, 0.05, 0.01, 0.005, 0.001]; % Different step sizes

% Exact derivative
exact_derivative = cos(x);

% Display header
fprintf('%10s %20s %20s %20s %20s %20s %20s\n', 'h', 'Forward Diff', 'Error', 'Backward Diff', 'Error', 'Central Diff', 'Error');

% Loop through each step size
for h = h_values
    % Forward difference approximation
    forward_diff = (f(x + h) - f(x)) / h;
    error_forward = (forward_diff - exact_derivative);

    % Backward difference approximation
    backward_diff = (f(x) - f(x - h)) / h;
    error_backward = (backward_diff - exact_derivative);

    % Central difference approximation
    central_diff = (f(x + h) - f(x - h)) / (2 * h);
    error_central = (central_diff - exact_derivative);

    % Display the results and errors
    fprintf('%10.4e %20.10f %20.10e %20.10f %20.10e %20.10f %20.10e\n', h, forward_diff, error_forward, backward_diff, error_backward, central_diff, error_central);
end