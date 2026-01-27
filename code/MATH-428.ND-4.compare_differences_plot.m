close all;
clear all;


% Define the function
f = @(x) sin(x);
df_exact = @(x) cos(x); % Exact derivative

x = 1; % Point of evaluation

h_values = [0.1, 0.05, 0.01, 0.005, 0.001];

% Initialize arrays to store errors
forward_errors = zeros(1, length(h_values));
backward_errors = zeros(1, length(h_values));
central_errors = zeros(1, length(h_values));

% Calculate the exact derivative
exact_derivative = df_exact(x);

% Loop through different h values
for i = 1:length(h_values)
    h = h_values(i);

    % Forward difference
    df_forward = (f(x + h) - f(x)) / h;
    forward_errors(i) = abs(df_forward - exact_derivative);

    % Backward difference
    df_backward = (f(x) - f(x - h)) / h;
    backward_errors(i) = abs(df_backward - exact_derivative);

    % Central difference
    df_central = (f(x + h) - f(x - h)) / (2 * h);
    central_errors(i) = abs(df_central - exact_derivative);
end

% Print the results in a table
fprintf('h\t\t\tForward Error\t\tBackward Error\t\tCentral Error\n');
fprintf('------------------------------------------------------------\n');
for i = 1:length(h_values)
    fprintf('%10.6e\t\t%16.10e\t%16.10e\t%16.10e\n', h_values(i), forward_errors(i), backward_errors(i), central_errors(i));
end

% Plot the errors on a log-log scale
figure;
loglog(h_values, forward_errors, '-o', h_values, backward_errors, '-x', h_values, central_errors, '-*');
xlabel('h');
ylabel('Error');
title('results for Different Difference Methods');
legend('Forward Difference', 'Backward Difference', 'Central Difference');
grid on;

% Line fitting to determine the order of error
% Fit a line to the log-log plot (y = mx + c  => log(y) = m*log(x) + log(c))
p_forward = polyfit(log(h_values), log(forward_errors), 1);
p_backward = polyfit(log(h_values), log(backward_errors), 1);
p_central = polyfit(log(h_values), log(central_errors), 1);

% The slope of the line (p(1)) is the order of the error
fprintf('\nOrder of Error:\n');
fprintf('Forward Difference: %.2f\n', p_forward(1));
fprintf('Backward Difference: %.2f\n', p_backward(1));
fprintf('Central Difference: %.2f\n', p_central(1));


%Overlay the fitted lines on the plot
hold on
loglog(h_values,exp(polyval(p_forward,log(h_values))),'--r','LineWidth',1.5)
loglog(h_values,exp(polyval(p_backward,log(h_values))),'--g','LineWidth',1.5)
loglog(h_values,exp(polyval(p_central,log(h_values))),'--b','LineWidth',1.5)
hold off