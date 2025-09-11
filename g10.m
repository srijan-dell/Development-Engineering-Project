%% 1) Example step‐hold data (ms & A)
step_time = (0:100)*0.1;                   % 0 → 10 ms in 0.1 ms steps (101 points)
step_x1   = linspace(1.68e-3,1.50e-3,101); % ramp from 1.68 mA down to 1.50 mA

%% 2) Square‐wave parameters
f_sq = 29.1e3;     % 29.1 kHz
A_sq = 5e-6;       % 0 → +5 µA (we’ll only add positive excursions)

%% 3) Build fine time‐base & interpolate
t_fine = linspace(step_time(1), step_time(end), 20000);  % in ms
x_hold = interp1(step_time, step_x1, t_fine, 'previous');

%% 4) Generate square wave and mask out the ramp portion
sq = square(2*pi*f_sq*(t_fine*1e-3));  % ±1 at 29.1 kHz
is_hold = x_hold <= min(step_x1)+1e-12; % “true” only on the final plateau

x_mod       = x_hold;
x_mod(is_hold) = x_hold(is_hold) + (A_sq/2)*(sq(is_hold)+1);
% (sq+1)/2 goes from 0→1, so we add 0→+5 µA

%% 5) Plot the result
figure('Color','w'); hold on;

% — Blue markers at each coarse step
plot(step_time, step_x1, 'sb', ...
     'MarkerFaceColor','b', 'MarkerSize',5, 'LineWidth',1.2);

% — Blue line (with wiggles only on final hold)
plot(t_fine, x_mod, '-b', 'LineWidth',1.2);

% — Red dashed reference at the 1.50 mA hold level
href = min(step_x1);
plot(t_fine, href*ones(size(t_fine)), '--r', 'LineWidth',1.5);

xlabel('Time (ms)');
ylabel('Current, x_1 (A)');
title('Composite: Coarse Steps + Fine Tuning with 0–5 µA Square Wave');
legend('I_{dc} (Step–Hold)','Step + 0–5 µA Sq. Wave','Hold Level (1.50 mA)', ...
       'Location','Best');
grid on;
