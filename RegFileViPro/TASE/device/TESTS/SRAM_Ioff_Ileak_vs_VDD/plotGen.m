%##############################################################
%#      MATLAB code to plot SRAM cell Leakage Current         #
%##############################################################

%load data%
load SRAM_Ioff_Ileak_vs_VDD/DAT/dc_IOFF_in.dat;
load SRAM_Ioff_Ileak_vs_VDD/DAT/dc_ILEAK_VDD_in.dat;
load SRAM_Ioff_Ileak_vs_VDD/DAT/dc_ILEAK_VSS_in.dat;
load SRAM_Ioff_Ileak_vs_VDD/DAT/dc_VDD.dat;

%convert to microamps%
%dc_IcellAh_MT_NX_d=dc_IcellAh_MT_NX_d*10^6;

%put all leakage data into matrix I%
I=cat(2, dc_IOFF_in, dc_ILEAK_VDD_in, dc_ILEAK_VSS_in);

%plot data and format figure%
semilogy(dc_VDD,I,'LineWidth',2);
grid on;
legend('Ioff', 'Ileak (VDD)', 'Ileak (VSS)', 'Location','NorthWest');
xlabel('VDD','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Cell Leakage Currents vs. VDD (DC analysis)','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_Ioff_Ileak_vs_VDD/IMG/SRAM_Ioff_Ileak_vs_VDD.eps');
close(gcf);

%print Ioff values to file for model calculations
fout = fopen('SRAM_Ioff_Ileak_vs_VDD/modelParams.txt','w');
fprintf(fout,'%e\t%e\t%e\n',dc_IOFF_in(1,1),dc_ILEAK_VDD_in(1,1),dc_ILEAK_VSS_in(1,1));
fclose(fout);
