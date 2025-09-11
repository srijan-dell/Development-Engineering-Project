clear; clc; close all;

%% 1. Generate the CSAC Signals
Fs       = 1e6;          % Sampling frequency: 1 MHz
Tend     = 1e-3;         % End time = 1 ms
t        = 0:1/Fs:Tend;  % Time vector

f_square = 9.7e3;        % Square wave frequency = 9.7 kHz
Iac_amp  = 5e-6;         % Square wave amplitude = 5 µA
Idc_off  = 2e-3;         % DC offset = 2 mA

% Generate square wave (from 0 to 5 µA)
sq_raw   = square(2*pi*f_square*t);  % -1 to +1
sq_shift = (sq_raw + 1)/2;           % shift to 0..1
Iac      = Iac_amp * sq_shift;       % 0..5 µA
Idc      = Idc_off + Iac;           % total current

% Compute Ipd and V_out
Ipd_func = @(I) 5*(I - 1.5e-3).^2;
Ipd = Ipd_func(Idc);
V_out = 2000 * Ipd;

%% 2. Create 4 Subplots: (Idc, Ipd, V_out vs time) + (Ipd vs Idc)
figure('Color','w','Position',[50 50 1200 800]);

subplot(2,2,1);
plot(t*1e3, Idc*1e3, 'LineWidth',1.2);
xlabel('Time (ms)'); ylabel('I_{dc} (mA)');
title('Photodiode Current (I_{dc}) vs. Time');
grid on;

subplot(2,2,2);
plot(t*1e3, Ipd*1e3, 'LineWidth',1.2, 'Color',[0.8500 0.3250 0.0980]);
xlabel('Time (ms)'); ylabel('I_{pd} (mA)');
title('I_{pd} = 5*(I_{dc} - 1.5 mA)^2 vs. Time');
grid on;

subplot(2,2,3);
plot(t*1e3, V_out, 'LineWidth',1.2, 'Color',[0.4660 0.6740 0.1880]);
xlabel('Time (ms)'); ylabel('V_{out} (V)');
title('Output Voltage (V_{out}) vs. Time');
grid on;

subplot(2,2,4);
Idc_range = linspace(0,2e-3,1000);
Ipd_range = Ipd_func(Idc_range);
plot(Idc_range*1e3, Ipd_range, 'b','LineWidth',1.5); hold on;
plot(0,0,'ro','MarkerSize',8,'MarkerFaceColor','r');  % placeholder
xlabel('I_{dc} (mA)'); ylabel('I_{pd} (A)');
title('I_{pd} vs. I_{dc} (Parabolic Response)');
grid on;

sgtitle('CSAC Signal Analysis and Parabolic Response');

%% 3. Coarse Tuning (Two-Point Method)
x1_initial   = 1.9e-3;          % from square wave
x2_initial   = 1.9e-3 + 5e-6;   % 5 µA higher
coarse_step  = 12e-6;         % 12 µA step
x1 = x1_initial;
x2 = x2_initial;

y1 = Ipd_func(x1);
y2 = Ipd_func(x2);

% Determine which side based on ordering
if y1 > y2
    side = 'left';   % on left side => need to shift right
else
    side = 'right';  % on right side => shift left
end

fprintf('--- Coarse Tuning Start ---\n');
fprintf('Initial: x1=%.6e A, x2=%.6e A, y1=%.3e, y2=%.3e, side=%s\n',...
    x1, x2, y1, y2, side);

% Store iteration history for x1, x2, y1, y2
history_x1_coarse = [];
history_x2_coarse = [];
history_y1_coarse = [];
history_y2_coarse = [];

% Record the initial state
history_x1_coarse(end+1) = x1;
history_x2_coarse(end+1) = x2;
history_y1_coarse(end+1) = y1;
history_y2_coarse(end+1) = y2;

% Animation
figure('Color','w','Position',[100 100 900 600]);
hCurve = plot(Idc_range*1e3, Ipd_range, 'b', 'LineWidth',1.5); hold on;
hCoarsePts = plot([x1,x2]*1e3, [y1,y2], 'ro','MarkerSize',8,'MarkerFaceColor','r');
xlabel('I_{dc} (mA)'); ylabel('I_{pd} (A)');
title('Coarse Tuning on Parabolic Response');
legend('Ipd = 5*(I_{dc}-1.5e^{-3})^2','Operating Points','Location','NorthWest');
grid on;

iter = 0; 
max_iter = 1000;
pause_duration = 0.1;

while iter < max_iter
    if strcmp(side,'left') && (y1 > y2)
        x1 = x1 + coarse_step;
        x2 = x2 + coarse_step;
    elseif strcmp(side,'right') && (y1 < y2)
        x1 = x1 - coarse_step;
        x2 = x2 - coarse_step;
    else
        % The ordering reversed => done
        break;
    end
    
    y1 = Ipd_func(x1);
    y2 = Ipd_func(x2);
    iter = iter + 1;
    
    % Record iteration
    history_x1_coarse(end+1) = x1;
    history_x2_coarse(end+1) = x2;
    history_y1_coarse(end+1) = y1;
    history_y2_coarse(end+1) = y2;
    
    fprintf('Coarse Iter %d: x1=%.6e, x2=%.6e, y1=%.3e, y2=%.3e\n',...
        iter, x1, x2, y1, y2);
    
    set(hCoarsePts, 'XData', [x1, x2]*1e3, 'YData', [y1, y2]);
    drawnow; pause(pause_duration);
end

fprintf('Final Coarse Operating Point:\n');
fprintf('x1=%.6e A, x2=%.6e A, y1=%.3e, y2=%.3e\n\n', x1, x2, y1, y2);

%% 4. Fine Tuning (Two-Point Method)
fine_step = 100e-9;
if strcmp(side,'left')
    x2_fine = x1 + fine_step;   % shift right if on left side
else
    x2_fine = x1 - fine_step;   % shift left if on right side
end

y1 = Ipd_func(x1);
y2 = Ipd_func(x2_fine);

fprintf('--- Fine Tuning Start ---\n');
fprintf('Initial Fine: x1=%.6e, x2=%.6e, y1=%.3e, y2=%.3e, side=%s\n',...
    x1, x2_fine, y1, y2, side);

% Store iteration history for x1, x2, y1, y2 in fine stage
history_x1_fine = [];
history_x2_fine = [];
history_y1_fine = [];
history_y2_fine = [];

% Record initial fine iteration
history_x1_fine(end+1) = x1;
history_x2_fine(end+1) = x2_fine;
history_y1_fine(end+1) = y1;
history_y2_fine(end+1) = y2;

initialSign = sign(y1 - y2);

figure('Color','w','Position',[200 200 900 600]);
hCurveFine = plot(Idc_range*1e3, Ipd_range, 'b','LineWidth',1.5); hold on;
hFinePts = plot([x1,x2_fine]*1e3, [y1,y2], 'ro','MarkerSize',10,'MarkerFaceColor','r');
xlabel('I_{dc} (mA)'); ylabel('I_{pd} (A)');
title('Fine Tuning on Parabolic Response (Zoomed)');
grid on;
xlim([1.49e-3*1e3, 1.51e-3*1e3]);
ylim([-1e-10, 1e-9]);

fine_iter = 0; 
max_fine_iter = 1000;
fine_pause = 0.05;

while fine_iter < max_fine_iter
    if strcmp(side,'left')
        x1 = x1 - fine_step;    % shifting further right on the parabola
        x2_fine = x2_fine - fine_step;
    else
        x1 = x1 + fine_step;
        x2_fine = x2_fine + fine_step;
    end
    
    y1 = Ipd_func(x1);
    y2 = Ipd_func(x2_fine);
    newSign = sign(y1 - y2);
    
    fine_iter = fine_iter + 1;
    
    % Record iteration
    history_x1_fine(end+1) = x1;
    history_x2_fine(end+1) = x2_fine;
    history_y1_fine(end+1) = y1;
    history_y2_fine(end+1) = y2;
    
    fprintf('Fine Iter %d: x1=%.6e, x2=%.6e, y1=%.3e, y2=%.3e\n',...
        fine_iter, x1, x2_fine, y1, y2);
    
    set(hFinePts, 'XData', [x1, x2_fine]*1e3, 'YData', [y1, y2]);
    drawnow; pause(fine_pause);
    
    if newSign ~= 0 && newSign ~= initialSign
        break;
    end
end

fprintf('Final Fine-Tuned Points:\n');
fprintf('x1=%.6e, x2=%.6e, y1=%.3e, y2=%.3e\n\n', x1, x2_fine, y1, y2);

%% 5. Combine Coarse + Fine Histories, Then Skip Every Other Iteration
% Merge both histories into single arrays for x1, x2:
history_x1 = [history_x1_coarse, history_x1_fine];
history_x2 = [history_x2_coarse, history_x2_fine];
history_y1 = [history_y1_coarse, history_y1_fine];
history_y2 = [history_y2_coarse, history_y2_fine];

% Let's define iteration index for the entire sequence as 1..N
N = length(history_x1);

% We want to skip every other iteration: i.e. keep i=1,3,5,...
skip_idx = 1:2:N;  % all odd indices

% For each kept iteration i, we will plot [ x1(i), x2(i) ] vs. a single time stamp
% so each iteration i contributes TWO points in the final plot.
num_kept = length(skip_idx);

% Define T from the square wave frequency
% After coarse and fine tuning, you have:
% history_x1 = [ ... ]; % length N
% Let's define iteration_t(i) = i*(T/2)
T = 1/f_square;
N = length(history_x1);
iteration_t = (1:N)*(T/2);

% Build step arrays
step_time = zeros(1, 2*N - 1);
step_x1   = zeros(1, 2*N - 1);

% First step
step_time(1) = iteration_t(1);
step_x1(1)   = history_x1(1);

for i = 2:N
    step_time(2*i - 2) = iteration_t(i);
    step_x1(2*i - 2)   = history_x1(i-1);

    step_time(2*i - 1) = iteration_t(i);
    step_x1(2*i - 1)   = history_x1(i);
end

% Plot
figure('Color','w');
plot(step_time*1e3, step_x1, '-o','LineWidth',1.5);
xlabel('Time (ms)');
ylabel('I_{dc} (A)');
title('Step-Hold Plot of x_1 vs. Time (Coarse + Fine Tuning)');
grid on;
