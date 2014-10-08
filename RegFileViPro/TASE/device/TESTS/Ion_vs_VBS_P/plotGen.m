%####################################################
%#   MATLAB code to plot PMOS current vs body bias  #
%####################################################

%load data%
load Ion_vs_VBS_P/DAT/dc_dc.dat;
load Ion_vs_VBS_P/DAT/dc_P1_PX_d.dat;

%put current data into matrix I and convert to milliamps%
I=abs(dc_P1_PX_d*10^-3);

%plot data and format figure%
semilogy(-1*dc_dc,I,'LineWidth',2);
grid on;
xlabel('-VBS (V)','fontsize',12);
ylabel('/midDrain Current/mid (mA)','fontsize',12);
title('PMOS Saturation Region Drain Current vs. Body Bias','fontsize',16);

%save and close%
print(gcf, '-depsc', 'Ion_vs_VBS_P/IMG/Ion_vs_VBS_P.eps');
close(gcf);
