Te = 0.1; % Perioada de esantionare [s]

%% IN90

S90 = load('IN90.mat');
rez90 = S90.out;

u90 = rez90.in2;
y90 = rez90.out2;

% Vector de timp comun, cu Te = 0.1 s
t90 = (ceil(max(u90.Time(1), y90.Time(1))/Te)*Te : Te : ...
       floor(min(u90.Time(end), y90.Time(end))/Te)*Te)';

% Esantionarea semnalelor la Te = 0.1 s
u90_data = interp1(u90.Time, u90.Data(:), t90, 'previous');
y90_data = interp1(y90.Time, y90.Data(:), t90, 'linear');

% Reprezentare grafica
figure('Name', 'IN90');

subplot(2,1,1);
plot(t90, u90_data, 'b', 'LineWidth', 1.5);
grid on;
title('Intrarea u(t) - IN90');
xlabel('Timp [s]');
ylabel('u(t)');

subplot(2,1,2);
plot(t90, y90_data, 'r', 'LineWidth', 1.5);
grid on;
title('Iesirea y(t) - IN90');
xlabel('Timp [s]');
ylabel('y(t)');

sgtitle('Intrarea si iesirea pentru IN90');

%% IN110

S110 = load('IN110.mat');
rez110 = S110.out;

u110 = rez110.in1;
y110 = rez110.out1;

% Vector de timp comun, cu Te = 0.1 s
t110 = (ceil(max(u110.Time(1), y110.Time(1))/Te)*Te : Te : ...
        floor(min(u110.Time(end), y110.Time(end))/Te)*Te)';

% Esantionarea semnalelor la Te = 0.1 s
u110_data = interp1(u110.Time, u110.Data(:), t110, 'previous');
y110_data = interp1(y110.Time, y110.Data(:), t110, 'linear');

% Reprezentare grafica
figure('Name', 'IN110');

subplot(2,1,1);
plot(t110, u110_data, 'b', 'LineWidth', 1.5);
grid on;
title('Intrarea u(t) - IN110');
xlabel('Timp [s]');
ylabel('u(t)');

subplot(2,1,2);
plot(t110, y110_data, 'r', 'LineWidth', 1.5);
grid on;
title('Iesirea y(t) - IN110');
xlabel('Timp [s]');
ylabel('y(t)');

sgtitle('Intrarea si iesirea pentru IN110');