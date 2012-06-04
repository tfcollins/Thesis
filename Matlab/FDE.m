

SP.FFTsize=512; 
%The size of the FFT and IFFT.
SP.CPsize=20; 
%CP length.
SP.SNR=[0:2:30];
%Simulated SNR range is from 0 dBto 30 dB.
SP.numRun=10^4; %



%Generate random data block.
errCount=0;
n=10;
SP.equalizerType='MMSE';
numSymbols=SP.FFTsize;
SP.channel=[1 2 1 1 0 3 4 ones(1,23)];
H_channel=fft(SP.channel,SP.FFTsize);
tmp=round(rand(2,numSymbols));
tmp=tmp*2 - 1;
inputSymbols=(tmp(1,:)+i*tmp(2,:))/sqrt(2);
%Add CP.
TxSymbols=[inputSymbols(numSymbols-SP.CPsize+1:numSymbols) inputSymbols];
%Propagate through multi-path channel.
RxSymbols=filter(SP.channel, 1, TxSymbols);
%Generate AWGN with appropriate noise power.
tmp=randn(2, numSymbols+SP.CPsize);
complexNoise=(tmp(1,:)+i*tmp(2,:))/sqrt(2);
noisePower=10^(-SP.SNR(n)/10);
%Add AWGN to the transmitted signal.
RxSymbols=RxSymbols+sqrt(noisePower)*complexNoise;
%Remove CP.
EstSymbols=RxSymbols(SP.CPsize+1:numSymbols+SP.CPsize);
%Convert the received signal into frequency domain.
Y=fft(EstSymbols, SP.FFTsize);


%Perform channel equalization in thefrequency domain.
if SP.equalizerType=='ZERO'
    Y=Y./Hchannel;
elseif SP.equalizerType=='MMSE'
    C=conj(H_channel)./(conj(H_channel).*H_channel+10^(-SP.SNR(n)/10));
    Y=Y.*C;
end
%Convert the signal back to time domain.
EstSymbols=ifft(Y);
%Perform hard decision detection.
EstSymbols=sign(real(EstSymbols))+i*sign(imag(EstSymbols));
EstSymbols=EstSymbols/sqrt(2);
%Check whether there is error.
I=find((inputSymbols-EstSymbols)==0);
%Count the number of errors.
errCount=errCount+(numSymbols-length(I));