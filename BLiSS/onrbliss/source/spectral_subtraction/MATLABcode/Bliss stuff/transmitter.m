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

% h - (unknown) channel vector
% H - (unknown) channel matrix obtained by employing commutativity
h=0.5*randn(1,L)+1i*0.5*randn(1,L);
h=h-mean(h);
h=h/std(h);
H=toeplitz([h zeros(1,N-L)].',[h(1) zeros(1,N-L) h(end:-1:2)]);

SNR=0:3:30;
SNR_lin=10.^(SNR./10);

% power allocation to training and data (must add to 1)
pow_c=0.5;
pow_w=0.5;

% w - data vector
w=2*randint(N,1)-1;        
        
J=kron((1/Q)*ones(Q),eye(P));

for ii=1:length(SNR_lin)
        
        % s - data + training
        s = sqrt(pow_w*SNR_lin(ii))*(eye(N)-J)*w + sqrt(pow_c*SNR_lin(ii))*c;
        
        % v - noise
        v=randn(N,1); v=v-mean(v); v=v/std(v);
        
        % x - signal s transmitted through channel H with noise v
        x(:,ii)=H*s+v;
end

data=fopen('data.txt','w');
fprintf(data,'%i\n%i\n%i\n%f\n%f\n',L,N,length(SNR),real(x),imag(x));
fclose(data);