
Fs = 4000;
t = 0:1/Fs:1;

x = sin(2*pi*100*t).*exp(-2*pi*t);

Omega = unwrap(angle(x));

figure(1),
subplot(2,1,1),
plot(x),
subplot(2,1,2),
plot(abs(fft(x)));

PSDx1 = (abs(fft(x))).^2;

x_1 = ifft(sqrt(PSDx1)).*exp(j*2*pi*Omega);

PSDx2 = fft(xcorr(x,x,2000));

x_2 = ifft(sqrt(PSDx2)).*exp(j*2*pi*Omega);

figure(2),
subplot(3,1,1)
plot(x)
hold on
plot(real(x_1),'r')
plot(real(x_2),'g')

subplot(3,1,2)
hold on
plot(real(PSDx1),'r')
plot(real(PSDx2),'g')

subplot(3,1,3)
plot(abs(fft(x)))
hold on
plot(abs(fft(x_1)),'r');
plot(abs(fft(x_2)),'g');