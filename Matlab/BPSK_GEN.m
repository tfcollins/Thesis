%% To do:
% fix time interval, aka t, to depend to length of message

%% Generation of BPSK waveforms
%Message->DBPSK_MOD->SRRC->RF_MOD

%% Generate message (string->bits)
clc;clear all;close all;
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
d=bits_c;

%% Create and pulse shape signal
b=2*d-1;              % Convert unipolar to bipolar
fs=6e3;
T=1/fs;
fc=10.2*fs;              % Carrier frequency (Cannot be direct multiple of sampling freq)
Eb=T/2;               % This will result in unit amplitude waveforms
up_sam=10;
t=0:1/fs:(up_sam*length(d)*1/fs-1/fs);
N=length(t);		  % Number of samples
Nsb=N/length(d);	  % Number of samples per bit
dd=repmat(d',1,Nsb);  % replicate each bit Nsb times
bb=repmat(b',1,Nsb);
dw=dd';               % Transpose the rows and columns
dw=dw(:)';            % Convert dw to a column vector (colum by column) and convert to a row vector
bw=bb';
bw=bw(:)';            % Data sequence samples

% square root raised cosine pulse in the time domain
srrc_size = 10;       % Half the length of the srrc pulse*samples+1
samples = 10;         % Number of samples
Beta_rolloff=.5;      % roll off factor for the srrc pulse
gain = 1;
pulse_srrc = gain*srrc(srrc_size,Beta_rolloff,samples);  %create pulse shape
bpsk_BB=conv(bw,pulse_srrc);  %convolve pulse with signal

% modulate
t_mod=0:1/fs:length(bpsk_BB)*1/fs-1/fs;
bpsk_RF=bpsk_BB.*cos(2*pi*fc*t_mod);% Modulate up to RF
bpsk_BB2=bpsk_RF.*cos(2*pi*fc*t_mod);% Modulate up to RF


freqs=[0 1e3/(.5*fs) 1.5e3/(.5*fs) 1];
amps=[1 1 0 0];
fl=400;                                        %filter length
b=firpm(fl,freqs,amps);
bpsk_BB2=filter(b,1,bpsk_BB2);

%% plots
figure;
subplot(4,1,1);
plot(bw);
title('Pre pulse shape filtering');
subplot(4,1,2);
plot(bpsk_BB);
title('Post pulse shape filtering');
subplot(4,1,3);
plot(bpsk_RF);
title('Post Modulation');
subplot(4,1,4);
plot(bpsk_BB2);
title('Post Modulation');




figure;
N=length(bpsk_BB);                               % length of the signal x
t=1/fs*(1:N);                                % define a time vector
ssf=(-N/2:N/2-1)/(1/fs*N);                   % frequency vector
fx=fft(bpsk_BB(1:N));                            % do DFT/FFT
fxs=fftshift(fx);                          % shift it for plotting
subplot(2,1,1);
plot(ssf,abs(fxs))         % plot magnitude spectrum
xlabel('frequency'); ylabel('magnitude')   % label the axes
title('Pre modulation');

N=length(bpsk_RF);                               % length of the signal x
t=1/fc*(1:N);                                % define a time vector
ssf=(-N/2:N/2-1)/(1/fc*N);                   % frequency vector
fx=fft(bpsk_RF(1:N));                            % do DFT/FFT
fxs=fftshift(fx);                          % shift it for plotting
subplot(2,1,2);
%hold on
plot(ssf,abs(fxs),'r')         % plot magnitude spectrum
xlabel('frequency'); ylabel('magnitude')   % label the axes
title('Post modulation');