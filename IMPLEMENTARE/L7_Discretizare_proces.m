%% Discretizare Hp

s = tf('s');

K = 0.8195;
T = 3.1538;
tau = 1.8;
Te = 0.1;

% Functia de transfer a procesului
Hp = K/((T*s+1)*(tau*s+1));

% Discretizare cu metoda ZOH
Hp_discretizat = c2d(Hp, Te, 'zoh')

% Extragerea coeficientilor
[numP, denP] = tfdata(Hp_discretizat, 'v');

% Forma:
% (b1*z^-1 + b2*z^-2) /
% (1 + a1*z^-1 + a2*z^-2)

b1 = numP(2);
b2 = numP(3);
a1 = denP(2);
a2 = denP(3);

%% Compararea procesului continuu si discret

t = 0:Te:20;

figure('Name', 'Procesul Hp');

% Proces continuu
subplot(2,1,1);
step(Hp, t);
grid on;
title('Raspunsul la treapta - Proces continuu');
xlabel('Timp [s]');
ylabel('Iesire y(t)');

% Proces discret
subplot(2,1,2);
step(Hp_discretizat, t);
grid on;
title('Raspunsul la treapta - Proces discret');
xlabel('Timp [s]');
ylabel('Iesire y[k]');

sgtitle('Compararea procesului continuu si discret');