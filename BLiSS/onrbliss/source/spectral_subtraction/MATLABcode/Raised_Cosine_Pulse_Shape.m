% Raised Cosine Transmit Pulse

F = 2e3;
T = 1/F;
t = T:T:1;
% t2 = -.5:T:.5;

x = randi([-1,1], length(t),1);

fo = 4e2;
Beta = .5;
fdelta = Beta/fo;

srrctfs = 2*fo*sin(2*pi*fo*t)./(2*pi*fo*t);
srrctfc = cos(2*pi*fdelta*t)./1-(4*fdelta*t).^2;
pulse = srrctfs.*srrctfc;
pulse = pulse/sqrt(sum(pulse.^2));
% rctf = srrc(10,0,10);

x_mod = conv(x, pulse);

x_filtout = deconv(x_mod, pulse);
% x_mod = filter(pulse, 1, x);
% x_filtout=filter(fliplr(rctf), 1, x_mod);

figure(1)
subplot(3,1,1)
plot(x)
subplot(3,1,2)
plot(abs(fft(x_mod)))
subplot(3,1,3)
plot(x_filtout);
