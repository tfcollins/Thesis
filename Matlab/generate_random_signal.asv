function [ x_Modul ] = generate_random_signal( fo1,dataLength ,fs)

%Generate random signal which will be subtracted (PAM Signals)

% Half the length of the srrc pulse
size = 10;

% the signal to be transmitted
data = 2*randint(dataLength,1)-1;

% upsamp_data is the signal after it has ben upsampled by 10
upsamp_data = upsample(data,10);

% square root raised cosine pulse in the time domain
samples = 10;   % Number of samples
Beta_rolloff=.5;    % roll off factor for the srrc pulse

% pulse_srrc is the srrc pulse
pulse_srrc = 10*srrc(size,Beta_rolloff,samples);

% x_data is the signal convolved with the pulse shape
x_data = conv(pulse_srrc,upsamp_data);

% Carrier frequency and modulation information
Fs = fs;
t = 1/Fs:1/Fs:length(x_data)/Fs;
x_Modul = x_data.*cos(2*pi*t*fo1)';

end

