%##############################################################
%#      MATLAB code to plot SRAM cell Leakage Current         #
%##############################################################

%load data%
load SRAM_Ioff_Ileak_vs_lpg/DAT/dc_IOFF_in.dat;
load SRAM_Ioff_Ileak_vs_lpg/DAT/dc_ILEAK_VDD_in.dat;
load SRAM_Ioff_Ileak_vs_lpg/DAT/dc_ILEAK_VSS_in.dat;
load SRAM_Ioff_Ileak_vs_lpg/DAT/dc_lpg.dat;

%convert to microamps%
%dc_IcellAh_MT_NX_d=dc_IcellAh_MT_NX_d*10^6;

%put all leakage data into matrix I%
I=cat(2, dc_IOFF_in, dc_ILEAK_VDD_in, dc_ILEAK_VSS_in);

%convert lengths into microns%
dc_lpg=dc_lpg*10^6;

%plot data and format figure%
semilogy(dc_lpg,I,'LineWidth',2);
grid on;
legend('Ioff', 'Ileak (VDD)', 'Ileak (VSS)', 'Location','NorthWest');
xlabel('Channel length of pass gate (microns)','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Cell Leakage Currents vs. lpg (DC analysis)','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_Ioff_Ileak_vs_lpg/IMG/SRAM_Ioff_Ileak_vs_lpg.eps');
close(gcf);


