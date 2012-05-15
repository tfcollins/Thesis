%Spectral Subtraction Implementation Using Pulse Shapes in Frequency Domain
%% Todo: 
% Add repetition coding
% Add more signals
%% Bugs
% 

clear all;clc;

%% Generate BPSK Signal
message='I grabbed a pile of dust, and holding it up, foolishly asked for as many birthdays as the grains of dust, I forgot to ask that they be years of youth.';

% convert to bits
bits=[];
for i=1:length(message)
    bits=[bits dec2bin(double(message(i)))];
end

bits_c=zeros(1,length(bits));
for i=1:length(bits)
    bits_c(i)=str2num(bits(i));
end
bits=bits_c;

% Half the length of the srrc pulse
size = 10;

% amount of information to be sent
dataLength = length(bits);

% the signal to be transmitted
data = bits'*2-1;           % Convert unipolar to bipolar
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% pulse_hamming is a hamming pulse in the time domain
pulse_hamming = hamming(size*samples*2+1);

% y_data is the interfering signal
y_data = conv(pulse_srrc,upsamp_data2);

% Carrier frequency for interfering signal
fo2 = 8e4-1e3;

y_Modul = y_data.*cos(2*pi*t*fo2)';

% z is the combination of x_data and y_data providing the interference
z = x_Modul+y_Modul;

% Here the noise is added to the signal
m = awgn(z,30,'measured');%SNR in dB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
X_fft = fft(x_Modul,precision);

% Omega is the Phase of the desired signal
Omega = angle(fft(x_Modul,precision));
% Add noise to estimate
Omega_Org=Omega;
Omega = awgn(Omega,.1,'measured');

% The signals are converted into PSD
Y_psd = abs(Y_fft);
M_psd = abs(M_fft);
X_psd = abs(X_fft);






X_fft = (X_psd).*exp(1i*Omega);
x_SS = ifft(X_fft,precision);

x_SS.*abs(x_SS)/max(abs(x_SS));
%remove noise from calculation


% The signal is modulated back down to base band
t2 = 1/Fs:1/Fs:length(x_SS)/Fs;
X_BB = 2*x_SS.*cos(2*pi*t2*fo1)';

% A filter is applied to remove any unwanted information outside the
% desired signal

if (1)
fl=600; 
ff=[0 .1 .11 1];
fa=[1 1 0 0];
h=firpm(fl,ff,fa);
X_filt = filter(h,1,X_BB);
end

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
disp(['Bit Error=',num2str(BitError)]);


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
title('Combined Signals');
subplot(5,1,4),
plot(abs(X_fft)),
title('Subtracted result');
subplot(5,1,5),
plot(real(x_SS_data(51:dataLength+50))),
title('Time Domain Data w/ Pulse Shape');

figure(3),
hold on;
plot(abs(fft(x_Modul)));
plot(abs(fft(y_Modul)),'r');
hold off;

% This figure shows the retrieved signal in blue and the orriginal in red
figure(2)
plot(data,'r.')
hold on
plot(real(x_SS_data(51:dataLength+50)),'.')
title('Comparison of Original and Retrieved Data');
