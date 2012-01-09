% Spectral Subtraction Test

% This program is a simple example of how to use Spectral Subtraction in
% order to remove a signal from the frequency domain

F1 = 100;     %Frequency for the desired signal
T = 1/F1;      %period
t = -10:T:10;   %time

% x1 is the desired signal
x1 = 30*sinc(2*pi*t);

% x2 is the interferance
x2 = 30*sinc(2*pi*t).*cos(t*35);

% y is the sum of all the signals
sum = x1+x2;

% Added white gausian noise
y = awgn(sum,.2);

omega = unwrap(angle(fft(y)));

% Here the signal, the interfering signal and sum of them are all plotted
% in the frequency domain

% figure(1),subplot(3,1,1),plot(abs(fft(x1)));
% title('Innitial Signal');
% figure(1),subplot(3,1,2),plot(abs(fft(x2)));
% title('Interferance');
% figure(1),subplot(3,1,3),plot(abs(fft(y)));
% title('Combination');

% Spectral Subtraction
% 
% Py=y.^2;        %Py is the Power Spectral density of the "recieved" signal
% Px2=x2.^2;      %Px2 is the PSD of the interfering signal
% 
% Pz=Py-Px2;      %Subtracting the PSD of the interfering signal leaves the
%                 %PSD of the extimted orriginal signal
% 
% z=sqrt(Pz);
% %%% avgpower(%%%
% Yfft = abs(fft(y));
% X2fft = abs(fft(x2));
% 
% psdY = dspdata.psd(Yfft(1:length(Yfft)));
% psdX2 = dspdata.psd(X2fft(1:length(X2fft)));
% psdZ = psdY-psdX2;
% 
% psdY = psd(y);
% psdX2 = psd(x2);
% 
% figure(2), subplot(2,1,1), plot(psdY);
% figure(2), subplot(2,1,2), plot(psdX2);

psdY = pwelch(y,[],[],[],F1,'twosided');;
psdX2 = pwelch(x2,[],[],[],F1,'twosided');;

psdZ = psdY-psdX2;

x1rec = ifft(sqrt(psdZ))*exp(j*omega);

% figure(2),subplot(2,1,1),plot(t,z);
% title('Innitial Signal Time Domain');
% figure(2),subplot(2,1,2),plot(abs(fft(z)));
% title('Innitial Signal Frequency Domain');

% This graph provides a representation of the orriginal signal and the
% result of the subtraction

% figure(3)
% plot(abs(fft(x1rec)),'b');
% hold on
% plot(abs(fft(x1)),'r');
% plot(abs(fft(y)),'g');
% title('Plot of the Subtracted Signal Compared to the Original');

psdXorg = pwelch(x1,[],[],[],F1,'twosided');
x1org = ifft(sqrt(psdXorg));%*abs(exp(1i*omega));

figure(4)
% subplot(2,1,1),
% plot(psdZ,'b');
% hold on
% plot(psdXorg,'r');
% title('Power Spectral Density');
% subplot(2,1,2),
plot(abs(fft(x1rec)),'b');
hold on
plot(abs(fft(x1org)),'r');
plot(abs(sqrt(psdY)),'g');
title('Frequency Plot');