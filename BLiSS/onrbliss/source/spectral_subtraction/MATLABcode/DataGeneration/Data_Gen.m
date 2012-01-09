clc; clear; close all;

% This is a data generation method for performing operations in C++ on data
% generatated by matlab

% This code is designed to practice data manipulation 
% It contains code from Software Reciever Design: Build o you own digital
% communications System in five easy steps

data_size = 1e5;

data_desired = 2*randint(data_size,1)-1; 
data_interfering = randi([-3,3], data_size,1);

samples = 10;

upsamp_data_des = upsample(data_desired,samples);
upsamp_data_int = upsample(data_interfering,samples);

pulse_size = 10;
Beta_rolloff = .5;

pulse_srrc = 10*srrc(pulse_size,Beta_rolloff,samples);

x_pulse = conv(pulse_srrc, upsamp_data_des);
y_pulse = conv(pulse_srrc, upsamp_data_int);

fo1 = 8e4;
fo2 = fo1-15e3;
Fs = 2e5;
t = 1/Fs:1/Fs:length(x_pulse)/Fs;

x_Modul = x_pulse.*cos(2*pi*t*fo1)';
y_Modul = y_pulse.*cos(2*pi*t*fo2)';

SigRec = x_Modul+y_Modul;

Phase = angle(x_Modul);


data1=fopen('RecSig_data.txt','w');
fprintf(data1,'%f\n%f\n%f\n',SigRec, y_Modul, Phase);
fclose(data1);
% 
% data2=fopen('IntSig_data.txt','w');
% fprintf(data2,'%f\n',y_Modul);
% fclose(data2);
% 
% data3=fopen('Phase_data.txt','w');
% fprintf(data3,'%f\n',Phase);
% fclose(data3);
