clear
C1N0=10;

C1C2=linspace(-20,20,500);
 for i=1:length(C1C2), 
     C2N0=C1N0/(10^(C1C2(1,i)*0.1));
     if C1N0>C2N0
        Cmax=C1N0;
    else
        Cmax=C2N0;
    end
   EGC(1,i)=0.5*C1N0+0.5*C2N0+(sqrt(C1N0)*sqrt(C2N0));
   EGCdB(1,i)=10*log10(EGC(1,i)/Cmax);
   MGC(1,i)=C1N0+C2N0;
   MGCdB(1,i)=10*log10(MGC(1,i)/Cmax);
   SDdB(1,i)=10*log10(1+0.5);
   MGC_EGC(1,i)=MGC(1,i)/EGC(1,i);
   MGC_EGCdB(1,i)=10*log10(MGC_EGC(1,i));
end 

figure(1)
plot(C1C2,EGCdB);
title('Plot of Improvement of all three techniques. (B-Equal Gain, R-Maximal Ratio, M-Selection Diversity)')
ylabel('Improvement(dB)');
xlabel('C1/C2(dB)');
grid on;
hold on;
plot(C1C2,MGCdB,'r');
plot(C1C2,SDdB,'m');
hold off;

figure(2);
subplot(111)
plot(C1C2,EGCdB);
title('Equal Gain Combining Improvement')
YLABEL('Improvement(dB)');
XLABEL('C1/C2(dB)');
grid on;

subplot(112)
plot(C1C2,MGCdB,'r');
title('Maximal Ratio Combining Improvement')
YLABEL('Improvement(dB)');
XLABEL('C1/C2(dB)');
grid on;