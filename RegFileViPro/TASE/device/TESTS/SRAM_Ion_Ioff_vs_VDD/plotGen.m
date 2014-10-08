%##############################################################
%#      MATLAB code to plot SRAM cell Leakage Current         #
%##############################################################

%load data%
load SRAM_Ion_Ioff_vs_VDD/DAT/dc_ION_in.dat;
load SRAM_Ion_Ioff_vs_VDD/DAT/dc_IOFF_in.dat;
load SRAM_Ion_Ioff_vs_VDD/DAT/dc_ILEAK_VDD_in.dat;
load SRAM_Ion_Ioff_vs_VDD/DAT/dc_ILEAK_VSS_in.dat;
load SRAM_Ion_Ioff_vs_VDD/DAT/dc_VDD.dat;

%convert to microamps%
%dc_IcellAh_MT_NX_d=dc_IcellAh_MT_NX_d*10^6;

%put all leakage data into matrix I%
I=cat(2, dc_IOFF_in, dc_ILEAK_VDD_in, dc_ILEAK_VSS_in);
Ileaktot = I(:,1)+I(:,2);

%plot data and format figure%
semilogy(dc_VDD,[dc_ION_in I Ileaktot],'LineWidth',2);
grid on;
legend('Ion', 'Ioff(BL)', 'Ileak (VDD)', 'Ileak (VSS)','Ileak_{total}','Location','NorthWest');
title('Cell currents vs. VDD (DC analysis)','fontsize',16);
xlabel('VDD','fontsize',12);
ylabel('log Current (A)','fontsize',12);


%Print the Ion/Ileak @nominal VDD%
Ion_nom = dc_ION_in(1);
Ileak_nom = Ileaktot(1);
%save the Ion/Ig values into a file
fout = fopen('SRAM_Ion_Ioff_vs_VDD/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [Ion_nom Ileak_nom]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'SRAM_Ion_Ioff_vs_VDD/IMG/SRAM_Ion_Ioff_vs_VDD.eps');
close(gcf);


