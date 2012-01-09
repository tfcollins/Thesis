clc; clear; close all;

% L - channel order
% N - size of the block before adding cyclic-prefix
% M - size of the block after adding cyclic-prefix
% P - period of the superimposed training vector (has to be equal to L)
% c - training vector
% fs - sampling frequency

L=3;
N=10*L;
M=N+L; 
P=L;
Q=N/P; 

c_P=complex([1:P]./P,-[P:-1:1]./P);
c=kron(ones(Q,1),c_P.');
c=c/sqrt(c'*c);

fs=1e3;
f=[-N/2:N/2-1]*(fs/N);

% h - (unknown) channel vector
% H - (unknown) channel matrix obtained by employing commutativity
h=0.5*randn(1,L)+j*0.5*randn(1,L);
h=h-mean(h);
h=h/std(h);
H=toeplitz([h zeros(1,N-L)].',[h(1) zeros(1,N-L) h(end:-1:2)]);

SNR=0:3:30;
SNR_lin=10.^(SNR./10);

% power allocation to training and data (must add to 1)
pow_c=0.5;
pow_w=0.5;

for ii=1:length(SNR_lin)
    % w - data vector
    w=2*randint(N,1)-1;
    
    J=kron((1/Q)*ones(Q),eye(P));
    
    % s - data + training (at appropriate powers and SNR)
    s = sqrt(pow_w*SNR_lin(ii))*(eye(N)-J)*w + sqrt(pow_c*SNR_lin(ii))*c;
    
    % v - random noise
    v=randn(N,1);
    v=v-mean(v);
    v=v/std(v);
    
    % x - transmitted signal
    x=H*s+v;
    
    % F - DFT matrix
    F=(1/sqrt(N))*dftmtx(N);
    x_hat=F*x;
    c_hat=F*sqrt(pow_c*SNR_lin(ii))*c;
    
    d=[x_hat(1:Q:end)./c_hat(1:Q:end)];
    F_P=(1/P)*dftmtx(P);
    
    % estimated channel
    h_hat=F_P'*d;
    
    % frequency domain representation of true and estimated channels
    magH_f1=abs(fft([h zeros(1,N-L)],N));
    magH_f2=abs(fft([h_hat.' zeros(1,N-L)],N));
    
    figure
    plot(f,20*log10(magH_f1))
    hold on
    plot(f,20*log10(magH_f2),'r.')
    xlabel('frequency [MHz]')
    ylabel('power spectral density')
    title(sprintf('SNR=%i',SNR(ii)))
    axis([-fs/2 fs/2 -50 30])
    legend('actual channel','estimated channel')
    grid on
    
end
