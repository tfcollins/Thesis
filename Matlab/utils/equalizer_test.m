
r=read_complex_binary('/home/traviscollins/data/post.txt');
s=read_complex_binary('/home/traviscollins/data/pre.txt');
r=r';
%rough equalize
% LMSequalizer.m find a LMS equalizer f for the channel b
%b=[0.5 1 -0.6];              % define channel
%m=1000; s=pam(m,2,1);        % binary source of length m
m=length(r);
%r=filter(b,1,s);             % output of channel
n=4; f=zeros(n,1);           % initialize equalizer at 0
mu=.01; delta=2;             % stepsize and delay delta
for i=n+1:m                  % iterate
  rr=r(i:-1:i-n+1)';         % vector of received signal
  e=s(i-delta)-rr'*f;        % calculate error
  f=f+mu*e*rr;               % update equalizer coefficients
end


% EqualizerTest.m test routine
% First run  LMSequalizer.m to set channel b
% and equalizer f
finaleq=f;                   % test final filter f
%m=1000;                      % new data points
%s=pam(m,2,1);                % new binary source of length m
%r=filter(b,1,s);             % output of channel
yt=filter(f,1,r);            % use final filter f to test
%dec=sign(real(yt));          % quantization
break
for sh=0:n                   % if equalizer is working, one
  err(sh+1)=0.5*sum(abs(dec(sh+1:m)-s(1:m-sh)));
end                          % of these delays has zero error


err

[hb,w]=freqz(b,1);
[hf,w]=freqz(f,1);
[hc,w]=freqz(conv(b,f),1);
semilogy(w,abs(hb))
hold on
semilogy(w,abs(hf),'r')
semilogy(w,abs(hc),'g')
semilogy(w,abs(hb).*abs(hf),'k')
hold off