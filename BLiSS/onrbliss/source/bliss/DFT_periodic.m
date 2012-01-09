clc; clear; close all;

N=512; P=32; Q=N/P;
%c_P=cos(2*pi*0.7.*[0:P-1])+j*sin(2*pi*1.3.*[0:P-1]);
c_P=complex([1:P]./P,-[P:-1:1]./P);
%c_P=0.85.^([0:P-1])./P-j*0.85.^([P-1:-1:0])./P;
%c_P=0.8.^([1:P])./P-j*sin(2*pi*0.3.*[0:P-1]);
c=kron(ones(1,Q),c_P);
c=c/sqrt(c*c');

F=dftmtx(N);
c_hat=F*c.';
figure(1);
subplot(3,1,1);
stem(0:N-1,real(c));
subplot(3,1,2);
stem(0:N-1,imag(c));
subplot(3,1,3);
stem(0:N-1,abs(c_hat));