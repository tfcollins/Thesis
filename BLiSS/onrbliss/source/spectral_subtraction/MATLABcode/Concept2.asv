% Fs = 3e5;
% 
% t = 1/Fs:1/Fs:2;
% 
% fo = 8e2;
% x = sin(2*pi*fo*t);
% Xf = fft(x,1e6);
% x_psd = abs(Xf.^2);
% 
% x_time = 
% 
% Omega = unwrap(angle(x));
% 
% 
% 
% freqs = [0 .125 .126 .874 .875 1];
% amps = [1 1 0 0 1 1];
% LPF = firpm(100, freqs, amps);
% rFS = filter(LPF, 1, w2);
% 
size = 10;
Beta_rolloff = .5;
samples = 10;

pulse_srrc = 10*srrc(size,Beta_rolloff,samples);

w = pulse_srrc;
Omega = angle(w);
Wp = fft(w.^2);
w2 = -ifft(sqrt(Wp)).*exp(1i*Omega);

freqs = [0 .325 .326 .674 .675 1];
amps = [1 1 0 0 1 1];
BPF = firpm(500, freqs, amps);
w_filt = 2*filter(LPF, 1, w2);

figure(1)
plot(real(w_filt),'g')
hold on
plot(real(w2),'r')
plot(w)

figure(2)
plot(abs(fft(w)));
hold on
plot(real(fft(w2)),'r');
plot(real(fft(w_filt)),'g')

figure(3)
plot(abs(X_EST_psd),'r')
hold on
plot(abs(M_psd),'g')
plot(abs(fft(x_Modul.^2,precision)))
plot(abs(Y_psd),'y')

% plot(abs(Mf))
% hold on
% plot(abs(Yf),'r')
% plot(abs(Mf)-abs(Yf),'g')
% plot(Xf_EST,'y')
% plot(x