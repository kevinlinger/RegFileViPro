%##############################################################
%#      MATLAB code to plot SRAM cell Leakage Current         #
%##############################################################

%load data%
load SRAM_Ioff_Ileak_vs_lpd/DAT/dc_IOFF_in.dat;
load SRAM_Ioff_Ileak_vs_lpd/DAT/dc_ILEAK_VDD_in.dat;
load SRAM_Ioff_Ileak_vs_lpd/DAT/dc_ILEAK_VSS_in.dat;
load SRAM_Ioff_Ileak_vs_lpd/DAT/dc_lpd.dat;

%put all leakage data into matrix I%
I=cat(2, dc_IOFF_in, dc_ILEAK_VDD_in, dc_ILEAK_VSS_in);

%convert to microns
dc_lpd = dc_lpd * 10^6;

%plot data and format figure%
semilogy(dc_lpd,I,'LineWidth',2);
grid on;
legend('Ioff', 'Ileak (VDD)', 'Ileak (VSS)', 'Location','NorthWest');
xlabel('lpd (microns)','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Cell Leakage Currents vs. lpd','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_Ioff_Ileak_vs_lpd/IMG/SRAM_Ioff_Ileak_vs_lpd.eps');
close(gcf);


