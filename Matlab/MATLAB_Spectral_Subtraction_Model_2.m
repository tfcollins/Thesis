%Spectral Subtraction Implementation Using Pulse Shapes in Frequency Domain
%TFC
% Half the length of the srrc pulse
size_d = 10;

% amount of information to be sent
dataLength = 4e3;

% the signal to be transmitted
data = 2*randint(dataLength,1)-1;

%Insert Training sequence
preamble=[1 1 1 1 -1 -1 1 1 1 1];
data_temp=[];
for i=1:length(data)
    if mod(i,100)==0
        data_temp=[data_temp preamble];
    end
    data_temp=[data_temp data(i)];
end
data=data_temp';
dataLength=length(data);


%Dummy data
data2 = randi([-3,3], dataLength,1);

% upsamp_data is the signal after it has ben upsampled by 10
upsamp_data = upsample(data,10);
upsamp_data2 = upsample(data2,10);

% square root raised cosine pulse in the time domain
samples = 10;   % Number of samples
Beta_rolloff=.5;    % roll off factor for the srrc pulse

% pulse_srrc is the srrc pulse
pulse_srrc = 10*srrc(size_d,Beta_rolloff,samples);

% x_data is the signal convolved with the pulse shape
x_data = conv(pulse_srrc,upsamp_data);

% Carrier frequency and modulation information
fo1 = 8e4;
Fs = 2e5;
t = 1/Fs:1/Fs:length(x_data)/Fs;
x_Modul = x_data.*cos(2*pi*t*fo1)';

% pulse_hamming is a hamming pulse in the time domain
pulse_hamming = hamming(size_d*samples*2+1);

% y_data is the interfering signal
y_data = conv(pulse_srrc,upsamp_data2);

% Carrier frequency for interfering signal
fo2 = 8e4-1e3;

y_Modul = 1.5*y_data.*cos(2*pi*t*fo2)';

% z is the combination of x_data and y_data providing the interference
z = x_Modul+y_Modul;

% Here the noise is added to the signal
m = awgn(z,.1);

% this defines the precision of the fft
precision = 20*dataLength;

% here the estimate of the desired signal is given
EST_data = upsample(randi([0,1], dataLength,1),10);
EST_y_data = conv(pulse_srrc,EST_data);
EST_y_Modul = EST_y_data.*cos(2*pi*t*fo2)';
EST_y_Subtract = 1.5*EST_y_Modul;

% Y_fft and M_fft are the fourier transforms of the estimated singal and
% combined signal
Y_fft = fft(EST_y_Subtract,precision);
M_fft = fft(m,precision);

% Omega is the Phase of the desired signal
Omega = angle(fft(x_Modul,precision));

% The signals are converted into PSD
Y_psd = abs(Y_fft);
M_psd = abs(M_fft);

%plot(Y_psd.*conj(Y_psd)/precision);
% figure(4)
% plot(abs(fft(y_Modul)));
% hold on;
% plot(abs(fft(EST_y_Modul*power)),'r');
% hold off;
% figure(5)

% M=11;%Taps
% y=zeros(1,length(l));
% for i=(M-1)/2+1:length(l)-(M-1)/2
%     y(i)=0;
%     for k=-(M-1)/2:(M-1)/2
%         y(i)=y(i)+l(i+k);
%     end
%     y(i)=y(i)/M;
% end
% M=11;%Taps
% y2=zeros(1,length(l));
% for i=(M-1)/2+1:length(l)-(M-1)/2
%     y2(i)=0;
%     for k=-(M-1)/2:(M-1)/2
%         y2(i)=y(i)+l2(i+k);
%     end
%     y2(i)=y(i)/M;
% end


% Alpha and Beta are the values for the musical noise
Alpha_MN = 12;  % values > 10
Beta_MN = 0.2; % values betweeen 0.05 and 0.2;

% Here the spectral subtraction takes place
X_EST_psd = M_psd - Alpha_MN*Y_psd;
%X_EST_psd = abs(fft(y_Modul,precision))-Alpha_MN*Y_psd;
X_EST_psd_save=X_EST_psd;

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

%Plots
% power=4;
% figure(3)
% subplot(4,1,1)
% plot(abs(fft(EST_y_Modul*power)));
% ylim([0 10000]);
% subplot(4,1,2)
% plot(abs(fft(y_Modul)));
% ylim([0 10000]);
% subplot(4,1,3)
% plot(abs(fft(y_Modul))-abs(fft(EST_y_Modul*power)),'r');
% ylim([0 10000]);
% subplot(4,1,4)
% plot(X_EST_psd);
% ylim([0 10000]);


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


% %Equalize
% % output o f channel
% n=30;
% % length of equalizer -�� 1
% delta=30;
% % u s e d e l a y <=n * l e n g t h ( b )
% p=length ( data )- delta ;
% R=toeplitz(x_SS_data(n+1:p),x_SS_data(n+1:-1:1));
% % b u i l d m a tr i x R
% data=data';
% S=data( n+1-delta:p-delta)' ;
% % and v e c t o r S
% f=inv(R'*R)*R'* S;
% % calculate equalizer f
% Jmin=S'*S-S'*R*inv(R'*R)*R'*S;
% % Jmin f o r t h i s f and d e l t a
% %x_SS_data=filter(f,1,x_SS_data) ;


%% Equalize
%x_SS_fft=fft(x_SS_data);
% x_SS_data=2*(x_SS_data>0)-1;
% pres=xcorr(x_SS_data,preamble);
% stem(pres);
% break;

%locate error
eq_size=10;
f=zeros(eq_size,1);
mu_lms=0.01;%step size
delay=0;%delay
for i=1:length(x_SS_data)
    if mod(i,100)==0
        pre=x_SS_data(i:i+9);
        pre=data(i:i+9);%test
        
        for j=1:length(preamble)%eq_size
            pre=pre(end:-1:1);pre=pre(:);
            error=preamble(j-delay)-pre'*f;  %calculate error
            f=f+mu_lms*error*pre;  %update equalizer coeff 
        end
        
        output=filter(real(f),1,x_SS_data(i:i+109));
        output=filter(real(f),1,data(i:i+109));%test
        output=2*(output>0)-1;%quantize
        
        %slide and check
        err=zeros(1,eq_size);
        for k=1:eq_size
            err(k)=sum(abs(output(k:k+9)-preamble'));
        end
        break
    end
    

    
end


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

BitError = numErrors/length(data)


% Here the process is plotted
figure(1),
subplot(5,2,1:2),
plot(upsamp_data),
title('Original Data');
subplot(5,2,3:4),
plot(abs(fft(x_Modul,precision))),
title('Desired Signal');
subplot(5,2,5),
plot(M_psd),
title('Combined Signals');
subplot(5,2,6),
hold on
plot(M_psd)
plot(abs(fft(y_Modul,precision)),'r');
%ylim([0 3000]);
hold off
subplot(5,2,7:8),
plot(X_EST_psd),%abs(X_fft)
title('Subtracted result');
ylim([0 4000]);
subplot(5,2,9:10),
hold on;
plot(abs(fft(x_Modul,precision)));
plot(X_EST_psd,'r');
plot(abs(abs(fft(x_Modul,precision))-X_EST_psd),'g');
ylim([0 4000]);
hold off;
title('Original vs Subtracted');

% This figure shows the retrieved signal in blue and the orriginal in red
figure(2)
plot(data,'r*')
hold on
plot(real(x_SS_data(51:dataLength+50)),'.')
title('Comparison of Original and Retrieved Data');
