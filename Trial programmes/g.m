% Parameters
a =200 ;            % Parabolic shape parameter
h = 1;           % Horizontal shift
k = 0;       % Vertical shift
T = 1;            % Period of the square wave (in seconds)
I_a = 0.75;
I_b = 0.025;
duration = 5;     % Duration of the signal (in seconds)
sampling_rate = 1000; % Sampling frequency (samples per second)
t = linspace(0, duration, duration * sampling_rate);
IDC_values = 0.005 * square(2 * pi * t / T) + I_a + I_b; 
IPD_values = a * (IDC_values - h).^2 + k;
figure;
subplot(2, 1, 1);
plot(t, IDC_values, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('DC Driving Current (mA)');
title('Square Wave Input for I_{DC}');
subplot(2, 1, 2);
plot(t, IPD_values, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Photodiode Current (\muA)');
title('Photodiode Current I_{PD} Response');


