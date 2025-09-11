% Parameters
a = 200;      % Parabolic shape parameter
h = 1;        % Horizontal shift
k = 0;        % Vertical shift
T = 1;        % Period of the square wave (in seconds)
I_a = 0.75;   % DC bias for IDC signal
I_b = 0.025;  % Offset current
duration = 5; % Duration of the signal (in seconds)
sampling_rate = 100000; % Higher sampling frequency for AM (100 kHz)
t = linspace(0, duration, duration * sampling_rate); % Time vector

% Square wave as modulating signal (message signal)
IDC_values = 0.005 * square(2 * pi * t / T) + I_a + I_b;

% Photodiode current response (Nonlinear transformation)
IPD_values = a * (IDC_values - h).^2 + k;

% AM Modulation
fc = 10000; % Carrier frequency (10 kHz)
carrier = 1*square(2 * pi * fc * t); % Carrier signal

% Amplitude Modulated (AM) Signal
AM_signal = (1 + IDC_values) .* carrier; 

% Plotting the results
figure;

subplot(3, 1, 1);
plot(t, IDC_values, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('DC Driving Current (mA)');
title('Square Wave Input for I_{DC}');

subplot(3, 1, 2);
plot(t, IPD_values, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Photodiode Current (\muA)');
title('Photodiode Current I_{PD} Response');

subplot(3, 1, 3);
plot(t, AM_signal, 'k', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Amplitude Modulated Signal with 10 kHz Carrier');
