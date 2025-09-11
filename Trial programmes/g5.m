% MATLAB code with increasing resolution towards minima
clc; clear; close all;

% Function definition
f = @(x) 400 * (x - 1).^2; % Given function y = 400(x-1)^2

% Initial settings
x = linspace(0, 2, 1000); % Range for visualization
y = f(x);
I_dc = rand() * 2; % Random initial point in range [0, 2]
step_coarse = 0.1; % Coarse tuning step size
step_fine = 50e-6; % Fine tuning step size (5uA)
epsilon = 1e-6; % Small tolerance for stopping condition
modulating_amplitude = 5e-6; % Initial modulating amplitude
epsilon1 = 1e-7;

% Plot the function
figure('Color', 'w');
plot(x, y, 'b-', 'LineWidth', 1.5);
hold on;
xlabel('I_{dc}');
ylabel('y = 400(x-1)^2');
title('Minima Search Simulation with Increasing Resolution');
grid on;

% Step 1: Find which side we are on
y1 = f(I_dc);
y2 = f(I_dc + step_fine);

if y2 > y1
    direction = -1; % Decrease I_dc if we are on the right side
else
    direction = 1; % Increase I_dc if we are on the left side
end

% Plot initial position
marker = plot(I_dc, y1, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

% Step 2: Coarse tuning
while true
    prev_y1 = y1;
    I_dc = I_dc + direction * step_coarse;
    y1 = f(I_dc);
    
    % Update marker position
    set(marker, 'XData', I_dc, 'YData', y1);
    pause(0.01);
    
    if y1 > prev_y1 % Crossed the minima
        direction = -direction; % Flip direction
        break;
    end
end

% Step 3: Fine tuning with increasing resolution
resolution_factor = 1;  % Initialize resolution factor

while true
    prev_y1 = y1;
    I_dc = I_dc + direction * step_fine * resolution_factor;
    y1 = f(I_dc);
    % Update marker position
    set(marker, 'XData', I_dc, 'YData', y1);
    pause(0.01);
    
    if abs(y1 - prev_y1) < epsilon % Stopping condition
        break;
    end
end

% Step 4: Decrease modulating amplitude for even finer precision
while modulating_amplitude > epsilon1
    modulating_amplitude = modulating_amplitude * 0.9; % Reduce amplitude
    step_fine = modulating_amplitude; % Update step size
    
    prev_y1 = y1;
    I_dc = I_dc + direction * step_fine;
    y1 = f(I_dc);
    
    % Update marker position
    set(marker, 'XData', I_dc, 'YData', y1);
    pause(0.01);
    
    if abs(y1 - prev_y1) < epsilon1
        break;
    end
end

% Display results
fprintf('Approximate Minima Found at I_dc = %.9f\n', I_dc);
fprintf('Function Value at Minima = %.9f\n', y1);
