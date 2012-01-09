%Spectral Subtraction Implementation Using Pulse Shapes in Frequency Domain

% Half the length of the srrc pulse
size = 10;

% amount of information to be sent
dataLength = 4000;

% the signal to be transmitted
data = randi([-1,1], dataLength,1);

% upsamp_data is the signal after it has ben upsampled by 10
upsamp_data = upsample(data,10);

% square root raised cosine pulse in the time domain
samples = 10;   % Number of samples
Beta_rolloff=.5;    % roll off factor for the srrc pulse

% pulse_srrc is the srrc pulse
pulse_srrc = 10*srrc(size,Beta_rolloff,samples);

% x_data is the signal convolved with the pulse shape
x_data = conv(pulse_srrc,upsamp_data);

% pulse_hamming is a hamming pulse in the time domain
pulse_hamming = 10*hamming(size*samples*2+1);

% y_data is the interfering signal
y_data = conv(pulse_hamming,upsamp_data);

% z is the combination of x_data and y_data providing the interference
z = x_data+y_data;

% Here the noise is added to the signal
m = awgn(z,4);

% this defines the precision of the fft
precision = 100000;

% Y and M are the frequency domain information for y_data and m
% respectively
Y = fft(y_data,precision);
M = fft(m,precision);

% Here the spectral subtraction takes place
X_SS = M-Y;

% Here X_SS is converted back into the time domain
x_SS = ifft(X_SS,precision);

% x_SS_data is retrieved signal
x_SS_data = downsample(conv(x_SS, pulse_srrc),10)/100;

% Here the process is plotted
figure(1)
subplot(6,1,1)
plot(upsamp_data)
subplot(6,1,2)
plot(abs(fft(z)))
subplot(6,1,3)
plot(abs(fft(m)))
subplot(6,1,4)
plot(abs(M))
subplot(6,1,5)
plot(abs(X_SS))
subplot(6,1,6)
plot(x_SS)

% This figure shows the retrieved signal in blue and the orriginal in red
figure(2)
plot(x_SS_data(21:4020))
hold on
plot(data,'r')
