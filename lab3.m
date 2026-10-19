
% Dimensiunile iesirilor pentru 145
length(out11.out.simout1.Data)
length(out12.out.simout1.Data)

% Dimensiunile iesirilor pentru 165
length(out21.out.simout1.Data)
length(out22.out.simout1.Data)

%%

% Extragerea datelor pentru 145
t1 = out11.out.simout1.Time;
y1 = out11.out.simout1.Data;

t2 = out12.out.simout1.Time;
y2 = out12.out.simout1.Data;

% Determinarea intervalului comun
t_start = max(t1(1),t2(1));
t_final = min(t1(end),t2(end));

% Pasul de esantionare
dt = 0.1;

% Vector comun de timp
t145 = (t_start:dt:t_final)';

% Interpolarea datelor
y145_1 = interp1(t1,y1,t145,'linear');
y145_2 = interp1(t2,y2,t145,'linear');

% Verificarea dimensiunilor
size(y145_1)
size(y145_2)
%%

t1 = out21.out.simout1.Time;
y1 = out21.out.simout1.Data;

t2 = out22.out.simout1.Time;
y2 = out22.out.simout1.Data;

t_start = max(t1(1),t2(1));
t_final = min(t1(end),t2(end));

dt = 0.1;

t165 = (t_start:dt:t_final)';

y165_1 = interp1(t1,y1,t165,'linear');
y165_2 = interp1(t2,y2,t165,'linear');

size(y165_1)
size(y165_2)
%%

figure;

subplot(2,1,1);
plot(t145,y145_1,'b');
hold on;
plot(t145,y145_2,'r');
title('Intrare 145 - iesiri aliniate');
legend('Realizare 1','Realizare 2');
grid on;

subplot(2,1,2);
plot(t165,y165_1,'b');
hold on;
plot(t165,y165_2,'r');
title('Intrare 165 - iesiri aliniate');
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

%%

figure;

subplot(2,2,1);
plot(t145,y145_1,'r');
hold on;
plot(t145,y145_1f,'b','LineWidth',1.5);
title('145 - Realizarea 1');
legend('Nefiltrat','Filtrat');
grid on;

subplot(2,2,2);
plot(t145,y145_2,'r');
hold on;
plot(t145,y145_2f,'b','LineWidth',1.5);
title('145 - Realizarea 2');
legend('Nefiltrat','Filtrat');
grid on;

subplot(2,2,3);
plot(t165,y165_1,'r');
hold on;
plot(t165,y165_1f,'b','LineWidth',1.5);
title('165 - Realizarea 1');
legend('Nefiltrat','Filtrat');
grid on;

subplot(2,2,4);
plot(t165,y165_2,'r');
hold on;
plot(t165,y165_2f,'b','LineWidth',1.5);
title('165 - Realizarea 2');
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


%% COMPARAREA IESIRILOR FINALE

figure;

plot(t145,y145_fuz,'b','LineWidth',2);
hold on;

plot(t165,y165_fuz,'r','LineWidth',2);

title('Compararea iesirilor fuzionate');
xlabel('Timp [s]');
ylabel('Iesire');

legend('Intrare 145','Intrare 165');
grid on;

%%


%% IDENTIFICARE fct transf

timpi = {t145, t165};
iesiri = {y145_fuz, y165_fuz};
intrari = [145, 165];

H = cell(1,2);

for i = 1:2

    t = timpi{i}(:);
    y = iesiri{i}(:);
    u = intrari(i);

    % Presupunem treapta aplicata la t = t(1)
    tr = t-t(1);

    % Valoarea initiala
    y0 = median(y(1:5));

    % Valoarea stationara
    ys = median(y(end-19:end));

    % Variatia iesirii
    dy = ys-y0;

    % Castigul static
    K = dy/u;

    % Estimarea timpului mort (prag 2%)
    idxL = find(y >= y0+0.02*dy,1,'first');
    L = tr(idxL);

    % Banda de stabilizare +/- 2%
    toleranta = 0.02*abs(dy);

    % Verificam daca iesirea este in banda
    in_banda = abs(y-ys) <= toleranta;

    % Ultimul esantion in afara benzii
    idx = find(~in_banda,1,'last');

    % Primul moment de stabilizare
    idx_stab = idx+1;

    if idx_stab > length(t)
        error('Iesirea nu s-a stabilizat.');
    end

    t_stab = tr(idx_stab);

    % Durata regimului tranzitoriu
    tc = t_stab-L;

    % Constanta de timp
    T = tc/3.9;

    % Functia de transfer
    H{i} = tf(K,[T 1],'InputDelay',L);

    fprintf('\n--- INTRARE %d ---\n',u);
    fprintf('K = %.4f\n',K);
    fprintf('Timp mort L = %.4f s\n',L);
    fprintf('Timp tranzitoriu tc = %.4f s\n',tc);
    fprintf('Constanta de timp T = %.4f s\n',T);

    disp(H{i});

end

%%

figure;

for i = 1:2

    t = timpi{i}(:);
    y = iesiri{i}(:);
    u = intrari(i);

    tr = t-t(1);
    y0 = median(y(1:5));

    % Raspunsul la treapta de amplitudine u
    y_sim = y0 + u*step(H{i},tr);

    subplot(2,1,i);

    plot(t,y,'b','LineWidth',1.5);
    hold on;
    plot(t,y_sim,'r--','LineWidth',2);

    title(['Identificare - intrare ',num2str(u)]);
    xlabel('Timp [s]');
    ylabel('Iesire');

    legend('Masurat','Identificat cu STEP');
    grid on;

end
