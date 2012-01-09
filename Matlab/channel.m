%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Channel

%Add interfering signals
RF_fq_KND_1=2.6e9;
RF_fq_KND_2=2.2e9;

KND_1=generate_random_signal(RF_fq_KND_1,length(bits),fs);
KND_2=generate_random_signal(RF_fq_KND_2,length(bits),fs);

%Add signals together
z=bpsk_RF+KND_1'+KND_2';
plotspec(z,1/fs);

%% Add large amount of signals
num_signals=4;  %Number of signals to add
low_cf=fc-2e3;     %Low range of signal spread
high_cf=fc+2e3;    %High range of signal spread
cf_array=linspace(low_cf,high_cf,num_signals);  %Evenly space carriers among desired range
KND=zeros(length(bpsk_RF),num_signals);
for i=1:num_signals
    KND(:,i)=generate_random_signal(cf_array(i),length(bits),fs);
end


%Add signals together
%view signals as they are added
temp_KND=zeros(1,length(bpsk_RF));
for i=1:num_signals
    temp_KND=temp_KND+KND(:,i)';
    plotspec(bpsk_RF+temp_KND,1/high_cf);
    pause
end

z=bpsk_RF+sum(KND,2)';

% add noise to all signals
m = awgn(z,.01);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%