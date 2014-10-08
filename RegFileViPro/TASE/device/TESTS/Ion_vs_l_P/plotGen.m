%####################################################
%#      MATLAB code to plot PMOS current vs length  #
%####################################################

%load data%
load Ion_vs_l_P/DAT/dc_ldef.dat;
load Ion_vs_l_P/DAT/dc_P1_PX_d.dat;

%put current data into matrix I%
I=abs(dc_P1_PX_d);

%convert lengths into microns%
dc_ldef=dc_ldef*10^6;

%plot data and format figure%
semilogy(dc_ldef,I,'LineWidth',2);
grid on;
xlabel('Channel Length (microns)','fontsize',12);
ylabel('\midDrain Current\mid (mA)','fontsize',12);
title('PMOS Saturation Region Drain Current vs. Channel Length','fontsize',16);

%save and close%
print(gcf, '-depsc', 'Ion_vs_l_P/IMG/Ion_vs_l_P.eps');
close(gcf);
