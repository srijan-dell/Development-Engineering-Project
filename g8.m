%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Composite Signal Example:
%   - Coarse region: from 2.0 mA to 1.5 mA in ~12 µA steps.
%   - Fine-tuning region: starting at 1.5 mA with 100 nA steps (N_fine steps).
%   - The high-frequency square wave is now modified to range from 0 to 5 µA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; clc; close all;

%% 1) Define the common step rate parameters
f_step = 9.7e3;         % Stepping frequency (steps per second)
T_step = 1 / f_step;    % Time period for each step

%% 2) Coarse Region Setup (2.0 mA down to 1.5 mA with ~12 µA decrements)
x1_start = 2.0e-3;      % 2.0 mA
x1_target = 1.5e-3;     % 1.5 mA

% Calculate number of coarse steps so that final value equals 1.5 mA.
% Desired step size is 12 µA, but the exact number may not be an integer.
N_coarse = round((x1_start - x1_target) / (12e-6/2.5));
% Use linspace so that the final value is exactly 1.5 mA.
x1_coarse = linspace(x1_start, x1_target, N_coarse+1); 
t_step_coarse = (0:N_coarse) * T_step;

%% 3) Fine-Tuning Region Setup (starting at 1.5 mA, +100 nA per step)
N_fine = 5;                     % Number of fine steps (adjust as needed)
fine_step_size = 100e-9;        % 100 nA per step
x1_fine = x1_target + (0:N_fine)*fine_step_size;
% For the fine steps, define time points starting from the end of coarse.
t_step_fine = (N_coarse : N_coarse+N_fine) * T_step;

%% 4) Combine Coarse and Fine Regions
% Avoid duplicating the time point at 1.5 mA (end of coarse = start of fine).
t_step_all = [t_step_coarse, t_step_fine(2:end)];
x1_all = [x1_coarse, x1_fine(2:end)];

%% 5) Create a Fine Time Axis for Smooth Plotting
Fs = 1e6;                     % Sampling rate: 1 MHz
t_fine_end = t_step_all(end);
t_fine = 0 : 1/Fs : t_fine_end;

%% 6) Build the Step-Hold (Staircase) Signal using 'previous' interpolation
x1_step = interp1(t_step_all, x1_all, t_fine, 'previous');

%% 7) Build the Modified High-Frequency Square Wave Component
% Define the frequency for the 30 kHz square wave.
f_high = 9.7e3;  % 30 kHz square wave frequency

% Generate the base square wave, originally ±1.
sq_wave_base = square(2*pi*f_high*t_fine);

% Convert the bipolar square wave (range -1 to 1) to unipolar (range 0 to 1)
% and then scale it to have an amplitude from 0 to 5 µA.
sq_wave_final = (sq_wave_base ) * 5e-6;

%% 8) Combine the Step-Hold Signal with the Square Wave
x1_final = x1_step + sq_wave_final;

%% 9) Plot the Results
figure('Color','w');
hold on; grid on;

% Plot the baseline (step-hold) signal in thick blue.
%plot(t_fine*1e3, x1_step, 'LineWidth', 2, 'Color', 'b');

% Plot the composite signal (steps + modified square wave) in thin red.
plot(t_fine*1e3, x1_final, 'LineWidth', 1.5, 'Color', 'r');

xlabel('Time (ms)');
ylabel('Current, x_1 (A)');
title('Composite: Coarse Steps + Fine Tuning with 0-to-5 µA Square Wave');
legend('Step-Hold Only', 'Step + 0-to-5 µA Square', 'Location', 'best');

% Set x and y axis limits (adjust as needed)
xlim([0, t_fine_end*1e3]);
ylim([1.49e-3, 2.01e-3]);
