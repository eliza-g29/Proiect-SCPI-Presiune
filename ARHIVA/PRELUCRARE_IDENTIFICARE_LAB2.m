clear; clc; close all;

out11 = load('GE_out_145.mat');
out12 = load('GE_out_145_2.mat');

out21 = load('GE_out_165.mat');
out22 = load('GE_out_165_2.mat');

% Dimensiunile iesirilor pentru 145
length(out11.out.simout1.Data)
length(out12.out.simout1.Data)

% Dimensiunile iesirilor pentru 165
length(out21.out.simout1.Data)
length(out22.out.simout1.Data)

%%

% Extragerea iesirilor
y11 = out11.out.simout1.Data(:);
y12 = out12.out.simout1.Data(:);

y21 = out21.out.simout1.Data(:);
y22 = out22.out.simout1.Data(:);

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

%%

% Extragerea timpului
t1 = out11.out.simout1.Time;
t2 = out12.out.simout1.Time;

% Determinarea intervalului comun
t_start = max(t1(1),t2(1));
t_final = min(t1(end),t2(end));

% Pasul de esantionare
dt = 0.1;

% Vector comun de timp
t145 = (t_start:dt:t_final)';

% Interpolarea datelor
y145_1 = interp1(t1,y11,t145,'linear');
y145_2 = interp1(t2,y12,t145,'linear');

% Verificarea dimensiunilor
size(y145_1)
size(y145_2)

%%

t1 = out21.out.simout1.Time;
t2 = out22.out.simout1.Time;

t_start = max(t1(1),t2(1));
t_final = min(t1(end),t2(end));

dt = 0.1;

t165 = (t_start:dt:t_final)';

y165_1 = interp1(t1,y21,t165,'linear');
y165_2 = interp1(t2,y22,t165,'linear');

size(y165_1)
size(y165_2)
%%

figure;

subplot(2,1,1);
plot(t145,y145_1,'b');
hold on;
plot(t145,y145_2,'r');
title('Intrare 145 - iesiri aliniate');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizare 1','Realizare 2');
grid on;

subplot(2,1,2);
plot(t165,y165_1,'b');
hold on;
plot(t165,y165_2,'r');
title('Intrare 165 - iesiri aliniate');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizare 1','Realizare 2');
grid on;

%% FILTRAREA DATELOR

% Dimensiunea ferestrei de filtrare
n = 3;

% Filtrare pentru intrarea 145
y145_1f = movmean(y145_1,n);
y145_2f = movmean(y145_2,n);

% Filtrare pentru intrarea 165
y165_1f = movmean(y165_1,n);
y165_2f = movmean(y165_2,n);

%% COMPARAREA DATELOR FILTRATE SI NEFILTRATE

figure;

subplot(2,2,1);
plot(t145,y145_1,'r');
hold on;
plot(t145,y145_1f,'b','LineWidth',1.5);
title('145 - Realizarea 1');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat','Filtrat');
grid on;

subplot(2,2,2);
plot(t145,y145_2,'r');
hold on;
plot(t145,y145_2f,'b','LineWidth',1.5);
title('145 - Realizarea 2');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat','Filtrat');
grid on;

subplot(2,2,3);
plot(t165,y165_1,'r');
hold on;
plot(t165,y165_1f,'b','LineWidth',1.5);
title('165 - Realizarea 1');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat','Filtrat');
grid on;

subplot(2,2,4);
plot(t165,y165_2,'r');
hold on;
plot(t165,y165_2f,'b','LineWidth',1.5);
title('165 - Realizarea 2');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Nefiltrat','Filtrat');
grid on;

%% FUZIUNEA DATELOR

% Media pentru intrarea 145
y145_fuz = (y145_1f + y145_2f)/2;

% Media pentru intrarea 165
y165_fuz = (y165_1f + y165_2f)/2;


figure;

subplot(2,1,1);

plot(t145,y145_1f,'r');
hold on;
plot(t145,y145_2f,'b');
plot(t145,y145_fuz,'k','LineWidth',2);

title('Fuziunea datelor - intrare 145');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizarea 1','Realizarea 2','Media');
grid on;

subplot(2,1,2);

plot(t165,y165_1f,'r');
hold on;
plot(t165,y165_2f,'b');
plot(t165,y165_fuz,'k','LineWidth',2);

title('Fuziunea datelor - intrare 165');
xlabel('Timp [s]');
ylabel('Iesire');
legend('Realizarea 1','Realizarea 2','Media');
grid on;

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