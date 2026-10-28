% Discretizare Hp
s = tf('s');
k = 0.72245;
T = 2.1925;
tau = 0.75;
Te = 0.1;
Hp = k/((T*s+1)*(tau*s+1));
Hp_discretizat = c2d(Hp, Te, 'zoh')
[numP, denP] = tfdata(Hp_discretizat, 'v');
% Forma este: (b1*z^-1 + b2*z^-2) / (1 + a1*z^-1 + a2*z^-2)
b1 = numP(2);
b2 = numP(3);
a1 = denP(2);
a2 = denP(3);
%%
% Discretizare Hr
Hr = (3.4655*s + 1.5806)/(2.1925*s);
Hr_discretizat = c2d(Hr, 0.1, 'tustin')     
%functia Hr[z] = (1.617*z - 1.545)/(z - 1)  =  
%              = (1.617 - 1.545 * z^(-1))/(1 - z^(-1)) = u[k]/e[k]
% Ecuatia finala: u[k] = u[k-1] + 1.617*e[k] - 1.545*e[k-1]
%% Apelarea functiei PIDE1
clear PIDE1;

% Parametrii simulării
Te = 0.1;           % Perioada de eșantionare
t = 0:Te:30;        % Vectorul de timp
N = length(t);      % Numărul de pași
r = 110 * ones(1, N); % Referința (de exemplu, o treaptă de amplitudine 100)

% Vectori pentru stocarea rezultatelor
y = zeros(1, N);    % Ieșirea sistemului
u = zeros(1, N);    % Comanda dată de regulator
e = zeros(1, N);    % Eroarea de reglare

% Bucla de reglare
for k = 1:N
    % Calculul erorii curente
    e(k) = r(k) - y(k);
    
    % APELUL FUNCȚIEI:
    u(k) = PIDE1(e(k));
    
    % Aici se aplică comanda u(k) pe modelul procesului Hp
    % (de exemplu, printr-un model discret Hp_d sau ecuație recurentă)
    if k < N
        if k == 1
            % La primul pas k=1 nu avem esantioane in urma la k-1
            y(k+1) = -a1 * y(k) + b1 * u(k);
        else
            % Pentru procesul de ordinul 2 avem nevoie de ultimele 2 valori
            y(k+1) = -a1 * y(k) - a2 * y(k-1) + b1 * u(k) + b2 * u(k-1);
        end
    end
end

figure;
subplot(2,1,1); 
plot(t, r, '--r', t, y, 'b', 'LineWidth', 1.5); 
grid on;
legend('Referinta', 'Iesire y');
ylabel('Amplitudine');
title('Raspunsul sistemului in bucla inchisa');

subplot(2,1,2); 
plot(t, u, 'k', 'LineWidth', 1.5); 
grid on;
legend('Comanda u');
xlabel('Timp [s]');
ylabel('Comanda');