clear; clc;
step = 1.5e-3;
grad_tol = 1e-5;
x = 2*rand;
y = 200e-6*(x-1)^2;
fprintf('Phase 1 - Iteration: %d, x = %.12f, y = %.12f\n', 0, x, y);
grad = 400e-6*(x-1);
iter = 0;
figure;
x_vals = linspace(0,2,400);
y_vals = 200e-6*(x_vals-1).^2;
plot(x_vals, y_vals, 'b-', 'LineWidth', 2);
hold on;
h_point = plot(x, y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
title('Phase 1 Gradient Descent');
xlabel('x'); ylabel('y'); grid on;
drawnow; pause(0.1);
while abs(grad) > grad_tol
    if grad > 0
        x = x - step;
    else
        x = x + step;
    end
    iter = iter + 1;
    y = 200e-6*(x-1)^2;
    grad = 400e-6*(x-1);
    set(h_point, 'XData', x, 'YData', y);
    title(sprintf('Phase 1 Coarse Tuning: Iteration %d', iter));
    drawnow; pause(0.01);
    fprintf('Phase 1 - Iteration: %d, x = %.8f, y = %.8f\n', iter, x, y);
end
fprintf('Phase 1 complete: Minimum found at x = %.12f in %d iterations.\n', x, iter);
fprintf('Phase 1: Minimum value of y = %.12e\n\n', y);
grad_tol = 2e-8;
step = 50e-6;
iter2 = 0;
fprintf('Starting Phase 2 refinement...\n\n');
figure;
plot(x_vals, y_vals, 'b-', 'LineWidth', 2);
hold on;
h_point2 = plot(x, y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
title('Phase 2 Gradient Descent Refinement');
xlabel('x'); ylabel('y'); grid on;
xlim([0.95, 1.05]);
ylim([0, 1e-6]);
drawnow; pause(0.1);
while abs(grad) > grad_tol
    if grad > 0
        x = x - step;
    else
        x = x + step;
    end
    iter2 = iter2 + 1;
    y = 200e-6*(x-1)^2;
    grad = 400e-6*(x-1);
    set(h_point2, 'XData', x, 'YData', y);
    title(sprintf('Fine Tuning: Iteration %d', iter2));
    drawnow; pause(0.01);
    fprintf('Phase 2 - Iteration: %d, x = %.8f, y = %.8f\n', iter2, x, y);
end
fprintf('\nRefined minimum found at x = %.12f in %d refinement iterations.\n', x, iter2);
fprintf('Final minimum value of y = %.12e\n', y);
