%find limits
SNR=0:.01:10;
freq_offset=0:100:1e6;
error=zeros(length(freq_offset),length(SNR));

for j=1:length(freq_offset)
for i=1:length(SNR)
    error(i,j)=find_limits(SNR(i),freq_offset(j));
end
freq_offset
end
break;
plot(SNR,error);
xlabel('SNR dB');
ylabel('BER');