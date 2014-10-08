%##############################################################
%#      MATLAB code to plot SRAM cell Leakage Current         #
%##############################################################

%load data%
load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_IOFF0_in.dat;
load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_ILEAK_VDD0_in.dat;
load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_ILEAK_VSS0_in.dat;
load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_VDD0.dat;

load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_IOFF1_in.dat;
load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_ILEAK_VDD1_in.dat;
load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_ILEAK_VSS1_in.dat;
load 5TSRAM_Ioff_Ileak_vs_VDD/DAT/dc_VDD1.dat;

%put all leakage data into matrix I%
I0=cat(2, dc_IOFF0_in, dc_ILEAK_VDD0_in, dc_ILEAK_VSS0_in);
I1=cat(2, dc_IOFF1_in, dc_ILEAK_VDD1_in, dc_ILEAK_VSS1_in);

%plot data and format figure%
semilogy(dc_VDD0,I0,'LineWidth',2);
grid on;
legend('Ioff0', 'Ileak0 (VDD)', 'Ileak0 (VSS)', 'Location','NorthWest');
xlabel('VDD','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Cell Leakage Currents vs. VDD (DC analysis)','fontsize',16);
print(gcf, '-depsc', '5TSRAM_Ioff_Ileak_vs_VDD/IMG/5TSRAM_Ioff_Ileak_vs_VDD0.eps');
close(gcf);

semilogy(dc_VDD1,I1,'LineWidth',2);
grid on;
legend('Ioff1', 'Ileak1 (VDD)', 'Ileak1 (VSS)', 'Location','NorthWest');
xlabel('VDD','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Cell Leakage Currents vs. VDD (DC analysis)','fontsize',16);
print(gcf, '-depsc', '5TSRAM_Ioff_Ileak_vs_VDD/IMG/5TSRAM_Ioff_Ileak_vs_VDD1.eps');
close(gcf);

%print Ioff values to file for model calculations
fout = fopen('5TSRAM_Ioff_Ileak_vs_VDD/modelParams.txt','w');
fprintf(fout,'%e\t%e\t%e\n',dc_IOFF0_in(1,1),dc_ILEAK_VDD0_in(1,1),dc_ILEAK_VSS0_in(1,1));
fprintf(fout,'%e\t%e\t%e\n',dc_IOFF1_in(1,1),dc_ILEAK_VDD1_in(1,1),dc_ILEAK_VSS1_in(1,1));
fclose(fout);
