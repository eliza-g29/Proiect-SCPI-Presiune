%% PROIECTAREA REGULATORULUI PI - metoda Predictor Smith

k_medie = 0.72245;
T_medie = 2.1925
L_medie = 0.75;

% Constanta de timp dorita
T0= 2;

% Parametrii regulatorului
Kp = T_medie/(k_medie*T0);
Ti = T_medie;
Ki = Kp/Ti;

% Regulatorul PI
C = pid(Kp,Ki);

Kp
Ti
Ki
C