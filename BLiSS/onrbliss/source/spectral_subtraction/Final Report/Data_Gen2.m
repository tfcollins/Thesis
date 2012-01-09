clc; clear; close all;

% This is a data generation method for performing operations in C++ on data
% generatated by matlab

% This code is designed to practice data manipulation 
% It contains code from Software Reciever Design: Build o you own digital
% communications System in five easy steps

% For this demonstration a single signal will be transmitted and overlayed
% with an interfering signal
data_desired = 1;
data_interfering = 1;

samples = 16;   % This value and the pulse size will determine 
                % the size of Sig Rec

% Here the signal is upsampled so that it is more interporable
upsamp_data_des = upsample(data_desired,samples);
upsamp_data_int = upsample(data_interfering,samples);

pulse_size = samples;   % The size of the pulse shape should be equal to 
                        % the number of samples of one bit
Beta_rolloff = .5;  % This is the rolloff value for the Square Root Riased
                    % Cosine pulse

% pulse_srrc is the pulse shape formed by the function srrc() that has been
% borrowed from the textbook Software Receiver Design
pulse_srrc = 10*srrc(pulse_size/2,Beta_rolloff,4);

% Here the data is comvolved with the pulse shape
x_pulse = conv(pulse_srrc, upsamp_data_des);
y_pulse = conv(pulse_srrc, upsamp_data_int);

% These variables determine the carrier frequency and modulation of the
% singal
fo1 = 8e4;
fo2 = fo1-50e3;
Fs = 2e5;
t = 1/Fs:1/Fs:length(x_pulse)/Fs;

% x_Modul is the desired signal and y_Modul is the interfering one
x_Modul = x_pulse.*cos(2*pi*t*fo1);
y_Modul = y_pulse.*cos(2*pi*t*fo2);

% SigRec is the combination of the desired and interfering signals 
SigRec = x_Modul+y_Modul;

% Phase is the phase of the desired signal
Phase = angle(fft(x_Modul));

% Here the fft matrix and ifft matrix are defined
FFT_matrix = dftmtx(length(SigRec));
IFFT_matrix = FFT_matrix'/length(SigRec);

% This plot displays the frequency responces of the desired signal, the
% interfering signal, and the combination of the two
figure(1)
plot(abs(fft((x_Modul))))
hold on
plot(abs(fft((y_Modul))),'r')
plot(abs(fft((SigRec))),'g')

% This plot displays the time domain version of the desired and combined
% signals
figure(2)
plot(SigRec);
hold on
plot(x_Modul,'r');

% Here the data for use in C++ is written into text files
data1=fopen('Sig_data.txt','w');
fprintf(data1,'%f\n%f\n%f\n',SigRec, y_Modul, Phase);
fclose(data1);

data2=fopen('FFT_file.txt','w');
fprintf(data2,'%f\n%f\n%f\n%f\n',real(FFT_matrix),imag(FFT_matrix),real(IFFT_matrix),imag(IFFT_matrix));
fclose(data2);

data3=fopen('DesSig.txt','w');
fprintf(data3,'%f\n',x_Modul);
fclose(data3);