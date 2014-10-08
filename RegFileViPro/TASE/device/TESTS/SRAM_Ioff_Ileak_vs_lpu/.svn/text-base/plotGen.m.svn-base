%##############################################################
%#      MATLAB code to plot SRAM cell Leakage Current         #
%##############################################################

%load data%
load SRAM_Ioff_Ileak_vs_lpu/DAT/dc_IOFF_in.dat;
load SRAM_Ioff_Ileak_vs_lpu/DAT/dc_ILEAK_VDD_in.dat;
load SRAM_Ioff_Ileak_vs_lpu/DAT/dc_ILEAK_VSS_in.dat;
load SRAM_Ioff_Ileak_vs_lpu/DAT/dc_lpu.dat;

%put all leakage data into matrix I%
I=cat(2, dc_IOFF_in, dc_ILEAK_VDD_in, dc_ILEAK_VSS_in);

%convert to microns
dc_lpu = dc_lpu * 10^6;

%plot data and format figure%
semilogy(dc_lpu,I,'LineWidth',2);
grid on;
legend('Ioff', 'Ileak (VDD)', 'Ileak (VSS)', 'Location','NorthWest');
xlabel('lpu (microns)','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Cell Leakage Currents vs. lpu','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_Ioff_Ileak_vs_lpu/IMG/SRAM_Ioff_Ileak_vs_lpu.eps');
close(gcf);


