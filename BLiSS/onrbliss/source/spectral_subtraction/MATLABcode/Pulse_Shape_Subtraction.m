%Spectral Subtraction Implementation Using Pulse Shapes in Frequency Domain

size = 201;

% x is a square root raised cosine pulse in the time domain
samples = 10;
x = 10*srrc((size-1)/(2*samples),1,samples);

% y is a hamming pulse in the time domain
y = 10*hamming(size);

z = x'+y;

m = awgn(z,.001);

precision = 10000;

Y = fft(y,precision);
M = fft(m,precision);

X_SS = M-Y;

x_SS = ifft(X_SS,precision);

figure(1)
subplot(7,1,1)
plot(x)
subplot(7,1,2)
plot(y)
subplot(7,1,3)
plot(z)
subplot(7,1,4)
plot(m)
subplot(7,1,5)
plot(abs(M))
subplot(7,1,6)
plot(abs(X_SS))
subplot(7,1,7)
plot(x_SS(1:size))