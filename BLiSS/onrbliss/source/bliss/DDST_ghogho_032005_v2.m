clc;
clear; close all;

% L - channel order
% N - size of the block before adding cyclic-prefix
% M - size of the block after adding cyclic-prefix
% P - period of the superimposed training vector (has to be equal to L)
% c - training vector
L=8; N=64; M=N+L; 
P=L; Q=N/P; 
c_P=[1:P]./P;%-j*[P:-1:1]./P;
c=kron(ones(Q,1),c_P.');
c=c/sqrt(c'*c);

SNR=0:2:30;
SNR_lin=10.^(SNR./10);

% power allocation to data and training
pow_c=0.5;pow_w=0.5;

%precoder matrix
J=kron((1/Q)*ones(Q),eye(P));


numIter=1e3;
for ii=1:length(SNR_lin)
    % Averaging over several realizations of simulated channels 
    % is performed by increasing the number of iterations below
    for jj=1:numIter
        % w - data vector
        w=2*randint(N,1)-1;        
        
        % transmitted vector obtained by adding training and data with
        % appropriate powers 
        s = sqrt(pow_w*SNR_lin(ii))*(eye(N)-J)*w + sqrt(pow_c*SNR_lin(ii))*c;
        v=randn(N,1); v=v-mean(v); v=v/std(v);
        
        
        %%% The following piece of code was originally outside of the loops
        % h - (unknown) channel vector
        % H - (unknown) channel matrix obtained by employing commutativity
        h(jj,:)=0.5*randn(1,L);%+j*0.5*randn(1,L); 
        h(jj,:)=h(jj,:)-mean(h(jj,:)); h(jj,:)=h(jj,:)/std(h(jj,:));
        H=toeplitz([h(jj,:) zeros(1,N-L)].',[h(jj,1) zeros(1,N-L) h(jj,end:-1:2)]);
        x=H*s+v;

        % F - DFT matrix
        F=(1/sqrt(N))*dftmtx(N);
        x_hat=F*x;
        c_hat=F*sqrt(pow_c*SNR_lin(ii))*c;

        d=[x_hat(1:Q:end)./c_hat(1:Q:end)];
        F_P=(1/P)*dftmtx(P);
        
        % estimated channel
        h_hat(jj,:)=F_P'*d;   
        
        %squared error 
        err_h(jj,:)=h(jj,:)-h_hat(jj,:);
        err_h_sq(jj,:)=err_h(jj,:)*err_h(jj,:)';
    end
    %mean squared error 
    mse_h(ii)=sum(err_h_sq)/numIter;    
end

% % frequency domain representation of true and estimated channels 
% [magH_f1, f]=plotspectrum([h zeros(1,N-L)],1e3,N);
% [magH_f2, f]=plotspectrum([h_hat.' zeros(1,N-L)],1e3,N);

%f=[-N/2:N/2-1]*(2*1e3/N);

% figure;
% plot(f,20*log10(magH_f1));
% hold on;
% plot(f,20*log10(magH_f2),'r.');
% xlabel('frequency, MHz');
% ylabel('power spectral density');
% axis([-1e3/2 1e3/2 -50 30]);

figure;
semilogy(SNR,mse_h,'*-');
grid on;
xlabel('SNR (in dB)');
ylabel('mse of the channel estimates');