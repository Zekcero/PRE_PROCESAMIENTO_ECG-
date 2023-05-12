


clc; clear; close all;

%% load ecg
load('ecg.mat');
Fs = 250;
G = 2000;

ecg = ecg/G;
ecg = (ecg - mean(ecg))/std(ecg);
t = (1:1:length(ecg))*(1/Fs);

figure;
plot(t,ecg)
xlim([0 4])
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
title('ECG Dominio del Tiempo')
%FFT

F = fft(ecg);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);

L = length(F);

f = (1:1:L)*((Fs/2)/L);
figure;
plot(f,F)
xlabel('Frecuencia (Hz)');
ylabel('Mgnitud Normalizada');
title('ECG en Frecuencia');
%% Filtrado FIR

% Caracteristicas del filtro
orden = 200;
limi = 59;
lims = 61;

% Normalizar
limi_n = limi/(Fs/2);
lims_n = lims/(Fs/2);

% Crear filtro
a = 1;
b = fir1(orden,[limi_n lims_n],'stop');

% Filtrar señal
ecg_limpio = filtfilt(b,a,ecg);
figure;
% Graficar Dominio del tiempo --------------------------

% Graficar el ECG sin filtrar
subplot(2,2,1);
plot(t,ecg);
xlim([0 4])
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
title('ECG SIN filtro')

% Graficar el ECG filtrado
subplot(2,2,3);
plot(t,ecg_limpio);
xlim([0 4])
xlabel('Tiempo (s)')
ylabel('Amplitud (mV)')
title('ECG CON filtro FIR')

% Graficar Dominio de la frecuencia  --------------------
% Graficar el ECG sin filtrar

F = fft(ecg);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);

subplot(2,2,2);
plot(f,F)
xlabel('Frecuencia (Hz)');
ylabel('Magnitud Normalizada');
title('ECG en Frecuencia SIN filtro');


% Graficar el ECG filtrado

F = fft(ecg_limpio);
F = abs(F);
F = F(1:ceil(end/2));
F = F/max(F);

subplot(2,2,4);
plot(f,F)
xlabel('Frecuencia (Hz)');
ylabel('Magnitud Normalizada CON filtro FIR');
title('ECG en Frecuencia');

%Extraccion de caracateristicas
ecg=ecg_limpio ;
figure;
hold on ;
plot (t,ecg);
xlabel ('Tiempo (s)')
ylabel('Magnitud (mv)')
xlim([0 4])
umbral_y=6*mean(abs(ecg));
umbral_x=0.3*Fs;
%findpeaks
[pks, locs ]=findpeaks (ecg,'MinpeakHeight',umbral_y,'MinPeakDistance',umbral_x);
scatter (t(locs),pks);
%Variabilidad de Frecencia Cardiaca 
HRV=diff(t(locs));

figure;
stem(HRV);
%interpolacion
new_t=downsample(t,125);
HRV_f= interp1 (t(locs(1:end-1)),HRV,new_t);
BPM=(1./HRV_f)*60;
BPM1=BPM(~isnan(BPM));
new_t1=new_t( ~isnan(BPM));

figure;
hold on;
subplot(2,1,1);
plot(new_t1,BPM1,'r')
xlim([85 95])
xlabel('Tiempo (s)')
ylabel ('BPM')
title('HRV')

subplot (2,1,2);
plot(t,ecg)
xlim([85 95])
xlabel('Tiempo');
ylabel ('Amplitud (mV)')
title ('ECG')
