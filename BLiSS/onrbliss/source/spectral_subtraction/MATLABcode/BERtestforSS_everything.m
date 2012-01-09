% More Complicated Spectral Subtraction Test for Bit Error Rate

Fs = 3000;
Ts = 1/Fs;
t = 0:Ts:1;

% Signal to transmit
n = randi([-1 1],length(t),1);
for s=1:length(t)
    if n(s)==0
        n(s)=1;
    end
end
x1 = n';    %.*cos(2*pi*2000*t);
x2 = x1.*cos(2*pi*30*t);

y = x1+x2;  % awgn(x1+x2, .1);

omega = unwrap(angle(fft(y)));
omega2 = unwrap(angle(fft(x2)));

figure(1),
subplot(2,1,1),
plot(x1)
title('Orriginal Modulated Signal');
subplot(2,1,2),
plot(abs(fft(x1)));

figure(2),
subplot(2,1,1),
plot(y)
title('Interfering Signal');
subplot(2,1,2),
plot(abs(fft(y)));

% Sx1=ones(1,length(t));
% Sx2=ones(1,length(t));
% Sy=ones(1,length(t));
% 
% IntS1=ones(1,length(t));
% IntS2=ones(1,length(t));
% IntSy=ones(1,length(t));
% 
% x = 1:length(t);    %time Tau you are integrating over
% for f=1:length(t)
%     for tau = 1:length(t)
%         IntS1(tau) = x1(tau)*exp(1i*2*pi*tau*f);
%         IntS2(tau) = x2(tau)*exp(1i*2*pi*tau*f);
%         IntSy(tau) = y(tau)*exp(1i*2*pi*tau*f);
%     end
%     Sx1(f) = trapz(IntS1,x);    %PSD for x1 at frequency f
%     Sx2(f) = trapz(IntS2,x);    %PSD for x2
%     Sy(f) = trapz(IntSy,x);     %PSD for y
% end

Sy = (fft(y).*exp(-1i*omega)).^2;
Sx2 = (fft(x2).*exp(-1i*omega2)).^2;

figure(8)
subplot(2,1,1)
plot(abs(Sy))
subplot(2,1,2)
plot(dspdata.psd(y))


% Perform Spectral Subtraction
Sx1_subd = Sy-Sx2;

figure(7),
subplot(2,1,1),
plot(abs(ifft(Sx1_subd)))
title('Subtracted Signal')
subplot(2,1,2),
plot(abs(Sx1_subd));

x1_subd = ifft(sqrt(Sx1_subd).*exp(1i*omega));

figure(3),
subplot(2,1,1),
plot(abs(x1_subd))
title('Subtracted Signal')
subplot(2,1,2),
plot(abs(fft(x1_subd)));

% x1_subd_BB = x1_subd.*cos(2*pi*2500*t);
% 
% figure(4),
% subplot(2,1,1),
% plot(x1_subd_BB)
% title('Signal at Base Band');
% subplot(2,1,2),
% plot(abs(fft(x1_subd_BB)));

fl=100; 
ff=[0 .1 .2 1];                 % BPF center frequency at .4
fa=[1 1 0 0];                   % which is twice f_0
h=firpm(fl,ff,fa);              % BPF design via firpm
n_subd=filter(h,1,x1_subd_BB);  % filter to give preprocessed r

figure(5),
subplot(2,1,1),
plot(n_subd)
title('Signal Filtered');
subplot(2,1,2),
plot(abs(fft(n_subd)));

for s=1:length(n)
    if n_subd(s)>0
        n_subd(s)=1;
    else
        n_subd(s)=-1;
    end
end

numError=0;
for s=1:length(n)
    if n_subd(s) ~= n(s)
        numError = numError+1;
    end
end

numError

%Sx2(s)=quad(y(x)*exp(1i*2*pi*x),1,length(t))^(s);

