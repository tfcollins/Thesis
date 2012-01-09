% Raised Cosine Transmit Pulse

F = 2e3;
T = 1/F;
t = T:T:1;
% t2 = -.5:T:.5;

x = randi([-1,1], length(t),1);

x_int = randi([1,2], length(t),1);

fo = 4e2;
Beta = .5;
fdelta = Beta/fo;

srrctfs = 2*fo*sin(2*pi*fo*t)./(2*pi*fo*t);
srrctfc = cos(2*pi*fdelta*t)./1-(4*fdelta*t).^2;
pulse = srrctfs.*srrctfc;
pulse = pulse/sqrt(sum(pulse.^2));
% rctf = srrc(10,0,10);

fo2=2.5e2;
srrctfs2 = 2*fo2*sin(2*pi*fo2*t)./(2*pi*fo2*t);
pulse2 = srrctfs2.*srrctfc;
pulse2 = pulse2/sqrt(sum(pulse2.^2));

x_mod = 100*conv(x, pulse);
x_int_mod = 100*conv(x, pulse2);

x_combined = x_mod + x_int_mod;

Omega = unwrap(angle(fft(x_mod)));

psd_x_int = abs(fft(x_int_mod)).^2;
psd_x_combined = abs(fft(x_combined)).^2;

psd_x_retrieved = psd_x_combined - psd_x_int;

x_retrieved = ifft(sqrt(psd_x_retrieved)).*exp(1i*Omega);

x_filtout = deconv(x_retrieved, pulse);
% x_mod = filter(pulse, 1, x);
% x_filtout=filter(fliplr(rctf), 1, x_mod);

figure(1)
subplot(6,1,1)
plot(x)
subplot(6,1,2)
plot(abs(fft(x_mod)))
subplot(6,1,3)
plot(abs(fft(x_combined)));
subplot(6,1,4)
plot(real(fft(psd_x_retrieved)));
subplot(6,1,5)
plot(abs(fft(x_retrieved)))
subplot(6,1,6)
plot(real(x_filtout));