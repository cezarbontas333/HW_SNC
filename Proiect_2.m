%% Lab 2
load("RaspIndicial.mat");
comanda_n = (out.comanda / 255) * 100;
presiune_n = (out.simout / 255) * 100;
figure("Name", "Plot comanda si iesire");
plot(comanda_n);
hold on
plot(presiune_n);
hold off
xlabel("Timp (secunde)");
ylabel("Valori intrare comanda si iesire presiune");
legend("u(%)", "y(%)", "location", "SE");

%% Lab 3

N = 9;
p = 2;
Te = 0.4;
tt = 6.3;
tc = 6;

L_spab = p*(2^N - 1);
vec_spab = idinput(L_spab, 'PRBS', [0 1/p], [140 217]);
mv_i = find(vec_spab == 217, 1, "first");
time_u0 = 0 : Te : tt;
step_u0 = repelem(179, length(time_u0));
vec_spab = [vec_spab(mv_i : end); vec_spab(1 : mv_i-1)];
vec_spab = [step_u0'; vec_spab; vec_spab(1 : length(vec_spab))];
vec_spab(0) = 0;
plotFreq(vec_spab, 1/Te);

%% Lab 3.2
load("lab3_pres.mat");
Te = 0.4;
p = 2;
plotFreq(out.simout.Data, 1/Te * p)
y_sis = out.simout.Data;
u_sis = out.comanda.Data;
Date_Exper = iddata(y_sis, u_sis, Te);
save("DateExper.mat", "Date_Exper", "-mat");

%% Lab 4 - 2.Filtrare semnale din experimentul de identificare
load('DateExper.mat');
Te = 0.4;
p = 2;
Fs = 1/Te * p;

% Separarea setului de date in experimentare si validare
eData = iddata(Date_Exper.OutputData(17 : 1038), Date_Exper.InputData(17 : 1038), Te);
vData = iddata(Date_Exper.OutputData(1039 : 1549), Date_Exper.InputData(1039 : 1549), Te);

% eliminarea componentelor constante din eData
trend_eData = getTrend(eData, 0);
eData = detrend(eData, trend_eData);
plotFreq(eData.y, Fs)

% aplicarea unui filtru de tip butter (n = 1, Wn = 0.2)
% pentru eData
[b_f,a_f] = butter(1, 0.2);
eData.y = filter(b_f,a_f,eData.y);
plotFreq(eData.y, Fs)

% eliminarea componentelor constante din vData
trend_vData = getTrend(vData, 0);
vData = detrend(vData, trend_vData);
plotFreq(vData.y, Fs)

% aplicarea unui filtru de tip butter (n = 1, Wn = 0.2)
% pentru vData
vData.y = filter(b_f,a_f,vData.y);
plotFreq(vData.y, Fs)

%% Lab 4 - 3.Separarea datelor de identificare

save('B30_IdentData','eData');
save('B30_ValidationData','vData'); 

%% Lab 4 - 4.Estimarea complexității

%B
nk = delayest(eData);
% 2, unde noi la punctul 1.5 am considerat ca nu avem timp mort
  
%C
na = 1:5;
nb = na;

NN = struc(na, nb, nk);
V = arxstruc(eData, vData, NN);
ordin = selstruc(V,"0");

na = ordin(1);
nb = ordin(2);
nk = ordin(3);
nf = na;

%% Lab 4 - 5.Alegerea unui model de identificare și identificarea parametrilor acestuia

m_ARX = arx(eData, ordin);
m_ARMAX = armax(eData, [na nb 10 nk]);
m_OE = oe(eData, [nb nf nk]);
m_BJ = bj(eData,  [nb 1 1 nf nk]);


%% Lab 4 - 6, 7.Validarea modelelor

for m = [m_ARX, m_ARMAX, m_OE, m_BJ]
    figure;
    e = resid(m,vData);
    plot(e);
    figure;
    compare(vData,m);
    figure;
    resid(m,vData,'corr');
    waitforbuttonpress;
    % o sa afisam 3 grafice pentru fiecare model,
    % pentru a evita aglomerarea ecranului am adaugat waitforbuttonpress,
    % !!! pentru a continua afisarea urmatoarelor 3 grafice, faceti click
    % pe figura cu multiplu de 3, cea cu resid
end

%% Lab 5
t_s = out.simout.Time;
date_winpim = [t_s y_sis u_sis];
save("DateB30.txt", "date_winpim", "-ascii");

figure;
plot(y_real, 'r');  % trasăm valorile reale cu roșu
hold on;
plot(y_pred, 'b');  % trasăm valorile prezise cu albastru
legend('Real', 'Predicted');
title('Valorile reale vs Predicțiile');