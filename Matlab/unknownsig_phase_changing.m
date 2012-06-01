phase=0:pi/32:2*pi;
error=zeros(1,length(phase));
for i=1:length(phase)
    
error(i)=find_phase_lim(phase(i),1000);
    
    
end
plot(phase,error);