%% Goals: 
% 1.) Generate BPSK Signal
% 2.) Modulate and add pulse shape to signal
%       Upsample signal
%       SRRC
% 3.) 
clear all;clc;

%% Generate BPSK Signal
message='The eagle has landed';

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


%% Modulate
% upsample
upsamp_bits = upsample(bits,10);

% square root raised cosine pulse in the time domain
samples = 10;   % Number of samples
Beta_rolloff=.5;    % roll off factor for the srrc pulse

% Half the length of the srrc pulse
srrc_size = 10;

% pulse_srrc is the srrc pulse
pulse_srrc = 10*srrc(srrc_size,Beta_rolloff,samples);

% x_data is the signal convolved with the pulse shape
bits_shaped = conv(pulse_srrc,upsamp_bits);

% bpsk modulate
fs=12e9;
RF_fq=2.4e9;
gain=2;
time=0:1/fs:length(bits_shaped)*1/fs-1/fs;
bpsk=gain*cos(2*pi*RF_fq*time+(bits_shaped-1)*pi);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Channel

%Add interfering signals
RF_fq_KND_1=2.6e9;
RF_fq_KND_2=2.2e9;

KND_1=generate_random_signal(RF_fq_KND_1,length(bits),fs);
KND_2=generate_random_signal(RF_fq_KND_2,length(bits),fs);

%Add signals together
z=bpsk+KND_1'+KND_2';
plotspec(z,1/fs);
% add noise to signal
m = awgn(z,.01);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Receiver

% this defines the precision of the fft (Longer the better)
precision = 20*length(bits);


%find other signals
%###DO LATER

% generate estimate of known signals
EST_data = upsample(randi([0,1], length(bits),1),10);
EST_y_data = conv(pulse_srrc,EST_data);
EST_1_Modul = EST_y_data.*cos(2*pi*t*RF_fq_KND_1)';
EST_2_Modul = EST_y_data.*cos(2*pi*t*RF_fq_KND_1)';
EST_Subtract = 5*(EST_1_Modul+EST_2_Modul);

% Y_fft and M_fft are the fourier transforms of the estimated singal and
% received/combined signal
Y_fft = fft(EST_Subtract,precision);
M_fft = fft(m,precision);  %received

% Omega is the Phase of the desired signal
Omega = angle(fft(bpsk,precision));

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
t2 = 1/fs:1/fs:length(x_SS)/fs;

X_BB=gain*cos(2*pi*RF_fq*t2+(x_SS-1)*pi);
%X_BB = 2*x_SS.*cos(2*pi*t2*fo1)';


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

