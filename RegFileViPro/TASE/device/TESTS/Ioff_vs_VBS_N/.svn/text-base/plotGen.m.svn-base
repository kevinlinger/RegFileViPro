%####################################################
%#   MATLAB code to plot NMOS current vs body bias  #
%####################################################

%load data%
load Ioff_vs_VBS_N/DAT/dc_dc.dat;
load Ioff_vs_VBS_N/DAT/dc_N1_NX_d.dat;

%put current data into matrix I and convert to milliamps%
I=dc_N1_NX_d*10^-3;

%plot data and format figure%
semilogy(dc_dc,I,'LineWidth',2);
grid on;
xlabel('VBS (V)','fontsize',12);
ylabel('Drain Current (mA)','fontsize',12);
title('NMOS Leakage Current vs. Body Bias','fontsize',16);

%save and close%
print(gcf, '-depsc', 'Ioff_vs_VBS_N/IMG/Ioff_vs_VBS_N.eps');
close(gcf);
