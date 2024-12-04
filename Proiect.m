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

%% Lab 4
t_s = out.simout.Time;
date_winpim = [t_s y_sis u_sis];
save("DateB30.txt", "date_winpim", "-ascii");