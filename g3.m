% MATLAB Code to Find the Minimum of f(x) = 200*(x-1)^2 * 10^(-6)

% Define the function
f = @(x) 200e-6 * (x - 1).^2;

% Initialize x randomly between 0 and 2
x = 2 * rand();  % x is in [0,2]

% Define step sizes
step_large = 1.5e-3;   % Coarse step size when far from the minimum
step_small = 50e-6;    % Fine step size when close to the minimum

% Define threshold: when |x-1| is below this, use the small step size.
% Here we choose the threshold equal to the coarse step size.
threshold = step_large;

% Define stopping tolerance (when x is very close to 1)
tol = 1e-8;

% Maximum iterations to prevent infinite loops
max_iter = 10000;
iter = 0;

% Display the starting value
fprintf('Starting x = %.8f\n', x);

% Iterative procedure
while abs(x - 1) > tol && iter < max_iter
    % Choose step size based on the current distance from 1
    if abs(x - 1) > threshold
        step = step_large;
    else
        step = step_small;
    end
    
    % Update x in the proper direction (toward x = 1)
    if x < 1
        % Check to avoid overshooting 1
        if (x + step) > 1
            x = 1;
        else
            x = x + step;
        end
    elseif x > 1
        if (x - step) < 1
            x = 1;
        else
            x = x - step;
        end
    else
        break;  % x is exactly 1
    end
    
    iter = iter + 1;
end

% Display the result
fprintf('Minimum found at x = %.8f after %d iterations.\n', x, iter);
fprintf('Function value at the minimum: %.8e\n', f(x));
