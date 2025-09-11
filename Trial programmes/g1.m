

a = 200;            % Parabolic shape parameter
h = 1;           % Horizontal shift
k = 0;       % Vertical shift
IDC_min = 0;      % Minimum DC driving current
IDC_max = 2;     % Maximum DC driving current
num_points = 100; % Number of points in the plot


IDC_values = linspace(IDC_min, IDC_max, num_points);


IPD_values = a * (IDC_values - h).^2 + k;


figure;
plot(IDC_values, IPD_values, 'r', 'LineWidth', 1.5);
grid on;
xlabel('DC Driving Current (mA)');
ylabel('Photodiode Current (\muA)');
title('Parabola Plot for Photodiode Current vs DC Driving Current');


disp('DC Driving Current (IDC) values:');
disp(IDC_values);
