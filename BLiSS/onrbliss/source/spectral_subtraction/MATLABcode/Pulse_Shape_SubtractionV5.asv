%Spectral Subtraction Implementation Using Pulse Shapes in Frequency Domain

% Half the length of the srrc pulse
size = 10;

% amount of information to be sent
dataLength = 4000;

% the signal to be transmitted
data = randi([-1,1], dataLength,1);
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

Omega = angle(x_data);

fo1 = 8e4;
Fs = 2e5;
t = 1/Fs:1/Fs:length(x_data)/Fs;
x_Modul = x_data.*cos(2*pi*t*fo1)';

% pulse_hamming is a hamming pulse in the time domain
pulse_hamming = hamming(size*samples*2+1);

% y_data is the interfering signal
y_data = conv(pulse_srrc,upsamp_data2);

fo2 = 8e4-15e3;

y_Modul = y_data.*cos(2*pi*t*fo2)';

% z is the combination of x_data and y_data providing the interference
z = x_Modul+y_Modul;

% Here the noise is added to the signal
m = z;%awgn(z,.01);

NoiseEST = .8*awgn(randi([-1,1], length(x_mod),1),.2)';

NoiseEST_freq = abs(fft(NoiseEST));
x_noise_freq = abs(fft(x_noise));

for i =1:length(NoiseEST_freq)
    if NoiseEST_freq(i) > x_noise_freq(i)
        NoiseEST_freq(i) = x_noise_freq(i);
    elseif x_noise_freq(i)<1000
            NoiseEST_freq(i)=x_noise_freq(i);
    end
end
    
SNR = abs(fft(NoiseEST))./abs(fft(x_noise));

% num_errors = 10e6;
% 
% for AlphaN = 10:100
%     for BetaN = 10:100

AlphaN=.5;
BetaN=.5;

J = 1/(AlphaN+BetaN)-(SNR).^2;

Gainfcn = zeros(1,length(x_noise));

for i=1:length(x_noise)
    if J(i)>=0
        Gainfcn(i) = sqrt(1-AlphaN*(SNR(i))^2);
    else
        Gainfcn(i) = sqrt(BetaN*(SNR(i))^2);
    end
end

M_fft = fft(x_noise).*Gainfcn;


% this defines the precision of the fft
precision = 100000;

% Y and M are the frequency domain information for y_data and m
% respectively

EST_data = upsample(randi([0,1], dataLength,1),10);
EST_y_data = conv(pulse_srrc,EST_data);
EST_y_Modul = EST_y_data.*cos(2*pi*t*fo2)';
EST_y_Subtract = 5*EST_y_Modul;

Y_fft = fft(EST_y_Subtract,precision);
% M_fft = fft(m,precision);

Omega = angle(M_fft);

Y_psd = abs(Y_fft);
M_psd = abs(M_fft);

num_Errors = 2e4;

% for Alpha_MN = 1:1/10:10
%     for Beta_MN = 0:1/10:10
Alpha_MN = 10;
Beta_MN = 0; % 0.05;

X_EST_psd = M_psd - Alpha_MN*Y_psd;

% Here the spectral subtraction takes place

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

% Here X_SS is converted back into the time domain

X_fft = X_EST_psd.*exp(1i*Omega);

x_SS = ifft(X_fft,precision);

% if abs(sum(abs(x_SS(1:40200))-abs(x_Modul)))<num_Errors
%     BestAlpha = Alpha_MN;
%     BestBeta = Beta_MN;
% end
% 
%     end
% end

t2 = 1/Fs:1/Fs:length(x_SS)/Fs;
X_BB = 2*x_SS.*cos(2*pi*t2*fo1)';


fl=600; 
ff=[0 .1 .11 1];  % BPF center frequency at .4
fa=[1 1 0 0];                  % which is twice f_0
h=firpm(fl,ff,fa);                 % BPF design via firpm
X_filt = filter(h,1,X_BB);                  % filter to give preprocessed r
 
% x_SS_data is retrieved signal
x_SS_data = 2*downsample(conv(X_filt, pulse_srrc),10)/100;

% Here the process is plotted
figure(1)
subplot(6,1,1)
plot(upsamp_data)
title('Original Data');
subplot(6,1,2)
plot(abs(fft(z)))
title('Combined Signals');
subplot(6,1,3)
plot(abs(fft(m)))
title('Added Noise');
subplot(6,1,4)
plot(abs(M_fft))
title('Combined Signals with Precision');
subplot(6,1,5)
plot(abs(X_fft))
title('Subtracted result');
subplot(6,1,6)
plot(real(x_SS))
title('Time Domain Data w/ Pulse Shape');

% This figure shows the retrieved signal in blue and the orriginal in red
figure(2)
plot(data,'r.')
hold on
plot(real(x_SS_data(51:dataLength+50)),'.')
