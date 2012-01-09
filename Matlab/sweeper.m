% Overall
Ts=1/Fs;            % sampling interval
time=2;  % total time
t=Ts:Ts:time;   
x=[];
for f=1000:100:15000
x=[x sin(f.*t)];
end