
fs = Fs;%8000;  %  Sampling Frequency
dur = 20;     %  Sound duration in seconds
ord = 6;
plen = 32;  % PSD segment length
%  Bandlimit on the filter
f1 = [1000];  % lower bandlimit
f2 = [20000]; % corresponding upper bandlimit
% colors for the plots
col = ['g', 'r', 'b', 'k', 'c', 'b'];
no = randn(1,round(fs*dur));  %  Generate noise signal
[b,a] = butter(ord,2*[f1 f2]/fs);  % Generate filter
% perform filter operation to get colored noise
cno = filter(b,a,no);

plotspec(cno,fs);
return



% % Compute the PSD
% [p, fax] = pwelch(cno,hamming(plen),fix(plen/2),2*plen, fs); % Compute PSD of noise 
% figure(1); lh = plot(fax,abs(fs*p/2),col(1)) % Plot PSD
% set(lh,'LineWidth',2)  %  Make line thicker
% hold on
% %  Find filter transfer function
% [h,fq] = freqz(b,a,2*plen,fs);
% plot(fq,abs(h).^2,col(2)) 
% hold off
% % Label figure
% xlabel('Hertz', 'Fontsize', 14)
% ylabel('PSD', 'Fontsize', 14)
% 
% %  Compute autocorrelation of input sequence
% mxlag = fs*.02;  %  Only compute lags up to 20 milliseconds
% [acwno, lagwno] = xcorr(no, mxlag, 'coef');
% %  Plot lags 
% figure(2); plot(1000*lagwno/(fs),acwno)
% xlabel('milliseconds');  ylabel('Correlation coefficient')
% 
% %  Compute autocorrelation of output sequence
% mxlag = fs*.02;  %  Only compute lags up to 20 milliseconds
% [accno, lagcno] = xcorr(cno, mxlag, 'coef');
% %  Plot lags 
% figure(3); plot(1000*lagcno/(fs),accno)
% xlabel('milliseconds');  ylabel('Correlation coefficient')