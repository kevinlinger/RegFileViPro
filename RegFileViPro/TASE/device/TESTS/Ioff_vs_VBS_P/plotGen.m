%####################################################
%#   MATLAB code to plot PMOS current vs body bias  #
%####################################################

%load data%
load Ioff_vs_VBS_P/DAT/dc_dc.dat;
load Ioff_vs_VBS_P/DAT/dc_P1_PX_d.dat;

%put current data into matrix I and convert to milliamps%
I=abs(dc_P1_PX_d*10^-3);

%plot data and format figure%
semilogy(-1*dc_dc,I,'LineWidth',2);
grid on;
xlabel('-VBS (V)','fontsize',12);
ylabel('/midDrain Current/mid (mA)','fontsize',12);
title('PMOS Leakage Current vs. Body Bias','fontsize',16);

%save and close%
print(gcf, '-depsc', 'Ioff_vs_VBS_P/IMG/Ioff_vs_VBS_P.eps');
close(gcf);
