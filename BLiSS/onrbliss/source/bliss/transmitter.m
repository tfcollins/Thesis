%% BLISS Matlab/C++ simulator
%  USNA/WPI BLISS project
%  July 2011
%  Srikanth Pagadarai, Ryan Dobbins

%  'bliss.cpp' must be in same folder
%  Set variables and run this script

clc; clear; close all;

%% Set these variables

% Set this flag to 1 to plot the channel estimates for each SNR value
PLOT_ESTIMATES = 1;

% L - channel order
% N - size of the block before cyclic-prefix (must be multiple of L)
% SNR - range of SNR values to simulate
% fs - sampling frequency (used for plots)
% numIter - iterations for each SNR value
L=8;
N=64;
SNR=0:3:30;
fs=1e3;
numIter=1;

%% Create training, channel, data

% M - size of block after cyclic-prefix
% P - period of training vector (must be equal to L)
M=N+L; 
P=L;
Q=N/P;

% c - training vector
c_P=complex([1:P]./P,-[P:-1:1]./P);
c=kron(ones(Q,1),c_P.');
c=c/sqrt(c'*c);

% h - (unknown) channel vector
% H - (unknown) channel matrix obtained by employing commutativity
h=0.5*randn(1,L)+1i*0.5*randn(1,L);
h=h-mean(h);
h=h/std(h);
H=toeplitz([h zeros(1,N-L)].',[h(1) zeros(1,N-L) h(end:-1:2)]);

% power allocation to training and data (must add to 1)
pow_c=0.5;
pow_w=0.5;

% w - data vector
% randomly generated for purposes of simulation
w=2*randint(N,1)-1;

% J - precoder matrix
J=kron((1/Q)*ones(Q),eye(P));

% v - random noise
v=randn(N,1);
v=v-mean(v);
v=v/std(v);

%SNR_lin=10.^(SNR./10);
SNR_lin=10.^(SNR./10);


% w - data vector
w=2*randint(N,1)-1;

for ii=1:length(SNR_lin)
    for jj=1:numIter
    
        % transmitted signal obtained by adding training and data with appropriate powers
        s = sqrt(pow_w*SNR_lin(ii))*(eye(N)-J)*w + sqrt(pow_c*SNR_lin(ii))*c;
        
        % "transmit" the data by multiplying with channel and adding noise
        x=H*s+v;
        
        %% Write data to text files ("transmitter")
        % complex values must be split into real and imaginary parts
        % otherwise the imaginary part is dropped if written as complex value
    
        data=fopen('data.txt','w');
        fprintf(data,'%i\n%i\n%i\n%f\n%f\n%f\n',L,N,pow_c,SNR_lin(ii),real(x),imag(x));
        fclose(data);

        dft=fopen('dftmtx.txt','w');
        fprintf(dft,'%f\n%f\n%f\n%f\n',real(dftmtx(N)),imag(dftmtx(N)),real(dftmtx(P)),imag(dftmtx(P)));
        fclose(dft);

        chan=fopen('channel.txt','w');
        fprintf(chan,'%f\n%f\n',real(h),imag(h));
        fclose(chan);
        
        %% Matlab channel estimation
    
        % F - NxN DFT matrix
        F=(1/sqrt(N))*dftmtx(N);
        
        % frequency domain signal and training vectors
        x_hat=F*x;%received
        c_hat=F*sqrt(pow_c*SNR_lin(ii))*c;%training
        
        % dividing out training from signal to get data
        d=[x_hat(1:Q:end)./c_hat(1:Q:end)];
        
        % F_P - PxP DFT matrix
        F_P=(1/P)*dftmtx(P);
    
        % estimated channel
        h_hat=F_P'*d;%convert training symbols to time domain

        %% C++ channel estimation
        % change these commands for other systems or compilers

        !g++ bliss.cpp
        !./a.out

        %% Read in C++ estimate

        chanest=importdata('chanest.txt');
        
        % create complex channel estimate from real and imag parts
        for i=1:1:L
            h_hat_c(i)=complex(chanest(i),chanest(i+L));
        end

        %% Errors
        
        % squared error of matlab estimate
        err_h=h-h_hat.';
        err_h_sq(jj)=err_h*err_h';
        
        % squared error of C++ estimate
        err_h_sq_c(jj)=chanest(2*L+1);
        
    end

    %% Plot channel and estimates

    if PLOT_ESTIMATES==1
        % frequency domain representation of true and estimated channels
        magH_f1=abs(fft([h zeros(1,N-L)],N));
        magH_f2=abs(fft([h_hat.' zeros(1,N-L)],N));
        magH_f3=abs(fft([h_hat_c zeros(1,N-L)],N));
        
        % create x-axis based on sampling frequency
        f=[-N/2:N/2-1]*(fs/N);

        figure
        plot(f,20*log10(magH_f1))
        hold on
        plot(f,20*log10(magH_f2),'r.')
        plot(f,20*log10(magH_f3),'m.')
        xlabel('frequency [MHz]')
        ylabel('power spectral density')
        axis([-fs/2 fs/2 -40 40])
        legend('actual channel','matlab estimate','c++ estimate')
        title(sprintf('SNR=%i',SNR(ii)))
        grid on
    
    end
    
    %% Mean squared error
    mse_h(ii)=sum(err_h_sq)/numIter;
    mse_h_c(ii)=sum(err_h_sq_c)/numIter;
    
end

%% Plot mean squared error

figure
semilogy(SNR,mse_h,'r*-')
hold on
semilogy(SNR,mse_h_c,'m*-')
grid on
xlabel('SNR (in dB)')
ylabel('MSE of channel estimates')
legend('matlab estimate','c++ estimate')
