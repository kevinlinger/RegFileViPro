%####################################################
%#      MATLAB code to plot NMOS current vs width   #
%####################################################

%load data%
load Ion_vs_w_N/DAT/dc_wdef.dat;
load Ion_vs_w_N/DAT/dc_N1_NX_d.dat;

%put current data into matrix I%
I=dc_N1_NX_d;

%convert widths into microns%
dc_wdef=dc_wdef*10^6;

%plot data and format figure%
semilogy(dc_wdef,I,'LineWidth',2);
grid on;
xlabel('Channel Width (microns)','fontsize',12);
ylabel('Drain Current (mA)','fontsize',12);
title('NMOS Saturation Region Drain Current vs. Channel Width','fontsize',16);

%save and close%
print(gcf, '-depsc', 'Ion_vs_w_N/IMG/Ion_vs_w_N.eps');
close(gcf);
