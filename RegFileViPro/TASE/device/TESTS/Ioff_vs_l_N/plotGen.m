%####################################################
%#      MATLAB code to plot NMOS current vs length  #
%####################################################

%load data%
load Ioff_vs_l_N/DAT/dc_ldef.dat;
load Ioff_vs_l_N/DAT/dc_N1_NX_d.dat;

%put current data into matrix I%
I=dc_N1_NX_d;

%convert lengths into microns%
dc_ldef=dc_ldef*10^6;

%plot data and format figure%
semilogy(dc_ldef,I,'LineWidth',2);
grid on;
xlabel('Channel Length (microns)','fontsize',12);
ylabel('Drain Current (mA)','fontsize',12);
title('NMOS Leakage Current vs. Channel Length','fontsize',16);

%save and close%
print(gcf, '-depsc', 'Ioff_vs_l_N/IMG/Ioff_vs_l_N.eps');
close(gcf);
