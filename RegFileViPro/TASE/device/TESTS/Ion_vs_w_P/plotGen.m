%####################################################
%#      MATLAB code to plot PMOS current vs width   #
%####################################################

%load data%
load Ion_vs_w_P/DAT/dc_wdef.dat;
load Ion_vs_w_P/DAT/dc_P1_PX_d.dat;

%put current data into matrix I%
I=abs(dc_P1_PX_d);

%convert widths into microns%
dc_wdef=dc_wdef*10^6;

%plot data and format figure%
semilogy(dc_wdef,I,'LineWidth',2);
grid on;
xlabel('Channel Width (microns)','fontsize',12);
ylabel('\midDrain Current\mid (mA)','fontsize',12);
title('PMOS Saturation Region Drain Current vs. Channel Width','fontsize',16);

%save and close%
print(gcf, '-depsc', 'Ion_vs_w_P/IMG/Ion_vs_w_P.eps');
close(gcf);
