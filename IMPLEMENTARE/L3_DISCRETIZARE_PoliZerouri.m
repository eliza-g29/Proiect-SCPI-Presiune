%% Discretizare Hp

s = tf('s');

K = 0.72245;
T = 2.1925;
tau = 0.75;
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

%% Discretizare Hr

% Regulator PI obtinut prin metoda poli-zerouri
Kp = 1.3;
Ti = 2.1925;

Hr = Kp*(Ti*s+1)/(Ti*s);

% Discretizare cu metoda Tustin
Hr_discretizat = c2d(Hr, Te, 'tustin')

% Extragerea coeficientilor regulatorului
[numR, denR] = tfdata(Hr_discretizat, 'v');

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

%% Compararea regulatorului continuu si discret

t = 0:Te:100;

figure('Name', 'Regulatorul Hr');

% Regulator continuu
subplot(2,1,1);
step(Hr, t);
grid on;
title('Raspunsul la treapta - Regulator PI continuu');
xlabel('Timp [s]');
ylabel('Comanda u(t)');

% Regulator discret
subplot(2,1,2);
step(Hr_discretizat, t);
grid on;
title('Raspunsul la treapta - Regulator PI discret');
xlabel('Timp [s]');
ylabel('Comanda u[k]');

sgtitle('Compararea regulatorului PI continuu si discret');