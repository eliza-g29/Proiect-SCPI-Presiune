
clear; clc; close all;
% PRELUCRARE SI IDENTIFICARE

out11 = load('P2_145_11.mat');
out12 = load('P2_145_22.mat');

out21 = load('P2_165_11.mat');
out22 = load('P2_165_22.mat');


%% Afisarea intrarilor si iesirilor ORIGINALE

date = {out11, out12, out21, out22};

valori_u = [145, 145, 165, 165];
masurari = [1, 2, 1, 2];

% Numele semnalelor din fisierele MAT
nume_intrari = {'in145_1', 'in145_1', 'in165', 'in165'};
nume_iesiri = {'out145_1', 'out145_1', 'out165', 'out165'};

for i = 1:4

    % Extragerea datelor originale
    intrare = date{i}.out.(nume_intrari{i});
    iesire = date{i}.out.(nume_iesiri{i});

    t_u = intrare.Time;
    u = intrare.Data;

    t_y = iesire.Time;
    y = iesire.Data;

    figure;

    % Intrarea originala
    subplot(2,1,1);
    plot(t_u, u, 'b');
    grid on;
    title(sprintf('Intrarea u = %d - Masurarea %d', ...
        valori_u(i), masurari(i)));
    xlabel('Timp [s]');
    ylabel('u(t)');

    % Iesirea originala
    subplot(2,1,2);
    plot(t_y, y, 'r');
    grid on;
    title(sprintf('Iesirea - Masurarea %d', masurari(i)));
    xlabel('Timp [s]');
    ylabel('y(t)');

end


%% Dimensiunile iesirilor

% Dimensiunile iesirilor pentru 145
length(out11.out.out145_1.Data)
length(out12.out.out145_1.Data)

% Dimensiunile iesirilor pentru 165
length(out21.out.out165.Data)
length(out22.out.out165.Data)

%% PRELUCRARE

% Extragerea iesirilor
y11 = out11.out.out145_1.Data(:);
y12 = out12.out.out145_1.Data(:);

y21 = out21.out.out165.Data(:);
y22 = out22.out.out165.Data(:);

% Identificarea valorilor eronate
idx11 = isoutlier(y11,'movmedian',11) | ~isfinite(y11);
idx12 = isoutlier(y12,'movmedian',11) | ~isfinite(y12);

idx21 = isoutlier(y21,'movmedian',11) | ~isfinite(y21);
idx22 = isoutlier(y22,'movmedian',11) | ~isfinite(y22);

% Afisarea numarului de valori eronate
sum(idx11)
sum(idx12)
sum(idx21)
sum(idx22)

% Inlocuirea valorilor eronate cu NaN
y11(idx11) = NaN;
y12(idx12) = NaN;

y21(idx21) = NaN;
y22(idx22) = NaN;

% Corectarea prin interpolare liniara
y11 = fillmissing(y11,'linear','EndValues','nearest');
y12 = fillmissing(y12,'linear','EndValues','nearest');

y21 = fillmissing(y21,'linear','EndValues','nearest');
y22 = fillmissing(y22,'linear','EndValues','nearest');

%% ALINIEREA DATELOR - INTRARE 145

% Extragerea timpului
t1 = out11.out.out145_1.Time(:);
t2 = out12.out.out145_1.Time(:);

% Determinarea intervalului comun
t_start = max(t1(1),t2(1));
t_final = min(t1(end),t2(end));

% Perioada de esantionare
Te = 0.1;

% Vector comun de timp
t145 = (t_start:Te:t_final)';

% Interpolarea datelor
y145_1 = interp1(t1,y11,t145,'linear');
y145_2 = interp1(t2,y12,t145,'linear');

% Verificarea dimensiunilor
size(y145_1)
size(y145_2)

%% ALINIEREA DATELOR - INTRARE 165

% Extragerea timpului
t1 = out21.out.out165.Time(:);
t2 = out22.out.out165.Time(:);

% Determinarea intervalului comun
t_start = max(t1(1),t2(1));
t_final = min(t1(end),t2(end));

% Vector comun de timp
t165 = (t_start:Te:t_final)';

% Interpolarea datelor
y165_1 = interp1(t1,y21,t165,'linear');
y165_2 = interp1(t2,y22,t165,'linear');

% Verificarea dimensiunilor
size(y165_1)
size(y165_2)

%% REPREZENTAREA GRAFICA A IESIRILOR ALINIATE

figure('Name','Compararea iesirilor aliniate');

subplot(2,1,1);
plot(t145,y145_1,'b','LineWidth',1.5);
hold on;
plot(t145,y145_2,'r','LineWidth',1.5);
title('Intrare 145 - iesiri aliniate');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizare 1','Realizare 2','Location','best');
grid on;

subplot(2,1,2);
plot(t165,y165_1,'b','LineWidth',1.5);
hold on;
plot(t165,y165_2,'r','LineWidth',1.5);
title('Intrare 165 - iesiri aliniate');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizare 1','Realizare 2','Location','best');
grid on;

sgtitle('Compararea iesirilor dupa prelucrare si aliniere');

%% FILTRAREA DATELOR

% Dimensiunea ferestrei de filtrare
n = 3;

% Filtrare pentru intrarea 145
y145_1f = movmean(y145_1, n);
y145_2f = movmean(y145_2, n);

% Filtrare pentru intrarea 165
y165_1f = movmean(y165_1, n);
y165_2f = movmean(y165_2, n);

%% COMPARAREA DATELOR FILTRATE SI NEFILTRATE

figure('Name', 'Compararea datelor filtrate si nefiltrate');

% Intrare 145 - Realizarea 1
subplot(2,2,1);
plot(t145, y145_1, 'r', 'LineWidth', 1);
hold on;
plot(t145, y145_1f, 'b', 'LineWidth', 1);
title('Intrare 145 - Realizarea 1');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat', 'Filtrat', 'Location', 'best');
grid on;

% Intrare 145 - Realizarea 2
subplot(2,2,2);
plot(t145, y145_2, 'r', 'LineWidth', 1);
hold on;
plot(t145, y145_2f, 'b', 'LineWidth', 1);
title('Intrare 145 - Realizarea 2');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat', 'Filtrat', 'Location', 'best');
grid on;

% Intrare 165 - Realizarea 1
subplot(2,2,3);
plot(t165, y165_1, 'r', 'LineWidth', 1);
hold on;
plot(t165, y165_1f, 'b', 'LineWidth', 1);
title('Intrare 165 - Realizarea 1');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat', 'Filtrat', 'Location', 'best');
grid on;

% Intrare 165 - Realizarea 2
subplot(2,2,4);
plot(t165, y165_2, 'r', 'LineWidth', 1);
hold on;
plot(t165, y165_2f, 'b', 'LineWidth', 1);
title('Intrare 165 - Realizarea 2');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat', 'Filtrat', 'Location', 'best');
grid on;

sgtitle('Compararea iesirilor filtrate si nefiltrate');

%% FUZIUNEA DATELOR

% Media celor doua realizari pentru intrarea 145
y145_fuz = (y145_1f + y145_2f) / 2;

% Media celor doua realizari pentru intrarea 165
y165_fuz = (y165_1f + y165_2f) / 2;

%% REPREZENTAREA GRAFICA A DATELOR FUZIONATE

figure('Name', 'Fuziunea datelor experimentale');

% Intrare 145
subplot(2,1,1);

plot(t145, y145_1f, 'r', 'LineWidth', 1);
hold on;
plot(t145, y145_2f, 'b', 'LineWidth', 1);
plot(t145, y145_fuz, 'k', 'LineWidth', 1);

title('Fuziunea datelor - intrare 145');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizarea 1', 'Realizarea 2', 'Media', ...
       'Location', 'best');
grid on;

% Intrare 165
subplot(2,1,2);

plot(t165, y165_1f, 'r', 'LineWidth', 1);
hold on;
plot(t165, y165_2f, 'b', 'LineWidth', 1);
plot(t165, y165_fuz, 'k', 'LineWidth', 1);

title('Fuziunea datelor - intrare 165');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizarea 1', 'Realizarea 2', 'Media', ...
       'Location', 'best');
grid on;

sgtitle('Fuziunea realizărilor experimentale');

%% IDENTIFICAREA FUNCTIEI DE TRANSFER

% Valoarea stationara - media ultimelor 20 esantioane
ys145 = mean(y145_fuz(end-19:end));
ys165 = mean(y165_fuz(end-19:end));

% Castigul static
K145 = ys145/145;
K165 = ys165/165;

% Afisarea rezultatelor
ys145
ys165

K145
K165

%% DETERMINAREA TIMPULUI MORT

% Prag de 2% din valoarea stationara
prag145 = 0.02*ys145;
prag165 = 0.02*ys165;

% Primul moment cand iesirea depaseste pragul
idx145 = find(y145_fuz >= prag145,1,'first');
idx165 = find(y165_fuz >= prag165,1,'first');

% Timpul mort estimat
L145 = t145(idx145);
L165 = t165(idx165);

L145
L165

%% DETERMINAREA CONSTANTEI DE TIMP

% Banda de stabilizare de +/- 2%
banda145 = 0.02*abs(ys145);
banda165 = 0.02*abs(ys165);

% Ultimul esantion din afara benzii de stabilizare
idx145 = find(abs(y145_fuz-ys145)>banda145,1,'last');
idx165 = find(abs(y165_fuz-ys165)>banda165,1,'last');

% Momentul intrarii definitive in banda
t98_145 = t145(idx145+1);
t98_165 = t165(idx165+1);

% Timpul tranzitoriu calculat dupa timpul mort
tc145 = t98_145-L145;
tc165 = t98_165-L165;

% Constanta de timp
T145 = tc145/3.9;
T165 = tc165/3.9;

% Afisarea rezultatelor
t98_145
t98_165

T145
T165

%% FUNCTIILE DE TRANSFER IDENTIFICATE

% Functia de transfer pentru u = 145
H145 = tf(K145,[T145 1],'InputDelay',L145);

% Functia de transfer pentru u = 165
H165 = tf(K165,[T165 1],'InputDelay',L165);

% Afisare
H145
H165

%% SIMULAREA FUNCTIILOR DE TRANSFER

% Simularea raspunsurilor
ysim145 = step(145*H145,t145);
ysim165 = step(165*H165,t165);

%% COMPARAREA IESIRILOR

figure;

subplot(2,1,1);
plot(t145,y145_fuz,'b','LineWidth',1.5);
hold on;
plot(t145,ysim145,'r--','LineWidth',1.5);
title('Intrare 145 - iesire masurata vs simulata');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Iesire masurata','Iesire simulata');
grid on;

subplot(2,1,2);
plot(t165,y165_fuz,'b','LineWidth',1.5);
hold on;
plot(t165,ysim165,'r--','LineWidth',1.5);
title('Intrare 165 - iesire masurata vs simulata');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Iesire masurata','Iesire simulata');
grid on;

%% FUNCTIA DE TRANSFER A PROCESULUI

% Media dintre cele 2 modele
k_medie = 0.8195;
T_medie = 3.1538;
L_medie = 1.8;
H = tf(k_medie,[T_medie 1],'InputDelay',L_medie);

s = tf('s');
H_pfix = k_medie/(T_medie*s+1);