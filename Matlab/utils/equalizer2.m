% LSequalizer.m find a LS equalizer f for the channel b
b=[0.5 1 -0.6];                    % define channel
m=1000; s=round(rand(1,m));        % binary source of length m
r=filter(b,1,s);                   % output of channel
%r=read_complex_binary('/home/traviscollins/data/post.txt');
%s=read_complex_binary('/home/traviscollins/data/pre.txt');
%r=r';
%s=s';

n=9;                               % length of equalizer - 1
delta=7;                           % use delay <=n*length(b)
p=length(r)-delta;
R=toeplitz(r(n+1:p),r(n+1:-1:1));  % build matrix R
S=s(n+1-delta:p-delta)';           % and vector S
f=inv(R'*R)*R'*S                   % calculate equalizer f
Jmin=S'*S-S'*R*inv(R'*R)*R'*S      % Jmin for this f and delta
y=filter(f,1,r);                   % equalizer is a filter
dec=round(y);                       % quantize and find errors
s2=sign(s);
err=0.5*sum(abs(dec(delta+1:m)-s2(1:m-delta)))