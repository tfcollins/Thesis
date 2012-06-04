%Spectral Subtraction Implementation Using Pulse Shapes in Frequency Domain

% Half the length of the srrc pulse
size = 10;

% amount of information to be sent
dataLength = 4e3;

% the signal to be transmitted
data = 2*randint(dataLength,1)-1;
data2 = randi([-3,3], dataLength,1);

% upsamp_data is the signal after it has ben upsampled by 10
upsamp_data = upsample(data,10);
upsamp_data2 = upsample(data2,10);
% square root raised cosine pulse in the time domain
samples = 10;   % Number of samples
Beta_rolloff=.5;    % roll off factor for the srrc pulse

% pulse_srrc is the srrc pulse
pulse_srrc = 10*srrc(size,Beta_rolloff,samples);

% x_data is the signal convolved with the pulse shape
x_data = conv(pulse_srrc,upsamp_data);

% Carrier frequency and modulation information
fo1 = 8e4;
Fs = 2e5;
t = 1/Fs:1/Fs:length(x_data)/Fs;
x_Modul = x_data.*cos(2*pi*t*fo1)';

% pulse_hamming is a hamming pulse in the time domain
pulse_hamming = hamming(size*samples*2+1);

% y_data is the interfering signal
y_data = conv(pulse_srrc,upsamp_data2);

% Carrier frequency for interfering signal
fo2 = 8e4-0e3;

y_Modul = 2*y_data.*cos(2*pi*t*fo2)';

% z is the combination of x_data and y_data providing the interference
z = x_Modul+y_Modul;

% Here the noise is added to the signal
m = awgn(z,10,'measured');

% this defines the precision of the fft
precision = 20*dataLength;

% here the estimate of the desired signal is given
EST_data = upsample(randi([0,1], dataLength,1),10);
EST_y_data = conv(pulse_srrc,EST_data);
EST_y_Modul = EST_y_data.*cos(2*pi*t*fo2)';
EST_y_Subtract = 5*EST_y_Modul;

% Y_fft and M_fft are the fourier transforms of the estimated singal and
% combined signal
Y_fft = fft(EST_y_Subtract,precision);
M_fft = fft(m,precision);

% Omega is the Phase of the desired signal
Omega = angle(fft(x_Modul,precision));

% The signals are converted into PSD
Y_psd = abs(Y_fft);
M_psd = abs(M_fft);

% Alpha and Beta are the values for the musical noise
Alpha_MN = 30;  % values > 10
Beta_MN = 0.2; % values betweeen 0.05 and 0.2;

% Here the spectral subtraction takes place
X_EST_psd = M_psd - Alpha_MN*Y_psd;

% These loops reduce the impact of musical noise on the signal
for i = 1:length(X_EST_psd)
    if X_EST_psd(i)<0
        X_EST_psd(i) = 0;
    end
end

for i = 1:length(X_EST_psd)
    if X_EST_psd(i) < Beta_MN*Y_psd(i)
        X_EST_psd(i) = Beta_MN*Y_psd(i);
    end
end

% Here X_SS is converted back into the frequency domain and time domain
X_fft = (X_EST_psd).*exp(1i*Omega);
x_SS = ifft(X_fft,precision);

% The signal is modulated back down to base band
t2 = 1/Fs:1/Fs:length(x_SS)/Fs;
X_BB = 2*x_SS.*cos(2*pi*t2*fo1)';

% A filter is applied to remove any unwanted information outside the
% desired signal

fl=600; 
ff=[0 .1 .11 1];
fa=[1 1 0 0];
h=firpm(fl,ff,fa);
X_filt = filter(h,1,X_BB);

% x_SS_data is retrieved signal
x_SS_data = 2*downsample(conv(X_filt, pulse_srrc),10)/100;

numErrors = 0;

for i=51:length(data)+50
    if x_SS_data(i)>0
        x_SS_data(i) = 1;
    else
        x_SS_data(i) = -1;
    end
    if x_SS_data(i)~=data(i-50)
        numErrors=numErrors+1;
    end
end

BitError = numErrors/length(data);


% Here the process is plotted
figure(1),
subplot(5,1,1),
plot(upsamp_data),
title('Original Data');
subplot(5,1,2),
plot(abs(fft(x_Modul))),
title('Desired Signal');
subplot(5,1,3),
plot(abs(M_fft)),
hold on
plot(abs(fft(y_Modul)),'r')
hold off;
title('Combined Signals');
subplot(5,1,4),
plot(abs(X_fft)),
title('Subtracted result');
subplot(5,1,5),
plot(real(x_SS_data(51:dataLength+50))),
title('Time Domain Data w/ Pulse Shape');

% This figure shows the retrieved signal in blue and the orriginal in red
figure(2)
plot(data,'r.')
hold on
plot(real(x_SS_data(51:dataLength+50)),'.')
title('Comparison of Original and Retrieved Data');
