%%decoder

%Spectral Subtraction Implementation Using Pulse Shapes in Frequency Domain
%% Todo: 
% Work on receiver
% Move channel to channel.m
%% Bugs
% 

clear all;clc;

%% Generate BPSK Signal
message='The_eagle_has_landed';

% convert to bits
bits=[];
for i=1:length(message)
    bits=[bits dec2bin(double(message(i)))];
end

bits_c=zeros(1,length(bits));
for i=1:length(bits)
    bits_c(i)=str2num(bits(i));
end
bits=bits_c;

% Half the length of the srrc pulse
size = 10;

% amount of information to be sent
dataLength = length(bits);

% the signal to be transmitted
data = bits'*2-1;           % Convert unipolar to bipolar
data2 = randi([-3,3], dataLength,1);

% upsamp_data is the signal after it has ben upsampled by 10
upsamp_data=0;
for i=1:length(bits)
    upsamp_data(1+(i-1)*10:i*10)=data(i);
    %upsamp_bits = upsample(bits,10);
end
upsamp_data=upsamp_data';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_SS_data=upsamp_data;

% Get message
% convert to letteers
character_b=zeros(1,length(data));
for i=1:length(x_SS_data)/10
    bit=mean(x_SS_data(1+(i-1)*10:i*10));
    if bit>0
        character_b(i)=1;
    else
        character_b(i)=0;
    end

end
letter=[];
for i=1:length(character_b)/7
    letter=[letter (char(bin2dec(dec2bin(character_b(1+(i-1)*7:i*7))')))];
end

decoded_message=letter;