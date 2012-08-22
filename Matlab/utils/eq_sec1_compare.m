%equalizer2
%r=[1+6i,2+7*1i,3+8*1i,4+9*1i,5+0*1i,0,0];
%s=[1,2,0,4,0,0,0];
r=1:7;
r=r+r*1i;
r=[r 8 9 10];
s=1:7;
s=[s 0 0 0];

n=3;                               % length of equalizer - 1
%n=50;
delta=0;                           % use delay <=n*length(b)
p=length(r)-delta;
R=toeplitz(r(n+1:p),r(n+1:-1:1));  % build matrix R
S=s(n+1-delta:p-delta)';           % and vector S
f=inv(R'*R)*R'*S                   % calculate equalizer f

