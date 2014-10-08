%##############################################################
%#      MATLAB code to plot SRAM cell Leakage Current         #
%##############################################################

%load data%
load RVP_I_cell/DAT/dc_ION_in.dat;
load RVP_I_cell/DAT/dc_IOFF_in.dat;
load RVP_I_cell/DAT/dc_ILEAK_VDD_in.dat;
load RVP_I_cell/DAT/dc_ILEAK_VSS_in.dat;
load RVP_I_cell/DAT/dc_VDD.dat;

%convert to microamps%
%dc_IcellAh_MT_NX_d=dc_IcellAh_MT_NX_d*10^6;

%put all leakage data into matrix I%
I=cat(2, dc_IOFF_in, dc_ILEAK_VDD_in, dc_ILEAK_VSS_in);
Ileaktot = I(:,1)+I(:,2);

%write Ion value at VDD=nominal VDD to data.txt for model calculations
fout = fopen('RVP_I_cell/data.txt', 'w');
fprintf(fout, '%e', dc_ION_in(1,1));
fclose(fout);

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
%fout = fopen('RVP_I_cell/data.txt', 'w');
%fprintf(fout, '%e\t%e\n', [Ion_nom Ileak_nom]'); 
%fclose(fout);

%save and close%
print(gcf, '-depsc', 'RVP_I_cell/IMG/RVP_I_cell.eps');
close(gcf);


