r=read_complex_binary('/home/traviscollins/data/post.txt');
s=read_complex_binary('/home/traviscollins/data/pre.txt');

prea=s(10:110);
stem(abs(xcorr(prea,s(1:500))))
figure(2)
stem(abs(xcorr(prea,r(1:500))))


cor=abs(xcorr(r(1:500),prea));
%remove padding
cor=cor(length(r(1:500))-length(prea):end);

%find first preamble
[indexs,~]=find(cor>=max(cor));

first=indexs(1);
start=first-length(prea);
[r(start:start+length(prea)-1) prea];
%offset=first-10;
%[abs(r(10+3:50+3)) prea]

r=r(start:start+length(prea)-1)';
s=prea';

% %equalize
% m=length(r);
% n=9; f=zeros(n,1);           % initialize equalizer at 0
% f(1)=1;
% mu=.02; delta=2;             % stepsize and delay delta
% index=1;
% output=zeros(1,length(r));
% for i=n+1:m                  % iterate
%   rr=r(i:-1:i-n+1)';         % vector of received signal
%   e=s(i-delta)-rr'*f;        % calculate error
%   
%   f=f+mu*e*rr;               % update equalizer coefficients
%   output(index)=f'*rr;
%   index=index+1;
% end
% 
% yt=filter(f,1,r);            % use final filter f to test

%equalizer2
n=9;                               % length of equalizer - 1
delta=0;                           % use delay <=n*length(b)
p=length(r)-delta;
R=toeplitz(r(n+1:p),r(n+1:-1:1));  % build matrix R
S=s(n+1-delta:p-delta)';           % and vector S
f=inv(R'*R)*R'*S                   % calculate equalizer f
Jmin=S'*S-S'*R*inv(R'*R)*R'*S      % Jmin for this f and delta
y=filter(f,1,r);                   % equalizer is a filter



[r' yt' prea abs(yt'-prea)]

break





r=r(1:1000);
s=s(1:1000);

fft_post=fft(r);
fft_pre=fft(s);

H_F=fft_post./fft_pre;

h=ifft(H_F);

estimate=ifft(H_F./fft_post);