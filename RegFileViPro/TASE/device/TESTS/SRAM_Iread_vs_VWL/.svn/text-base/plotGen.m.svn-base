%##############################################################
%#      MATLAB code to plot SRAM cell Read Current	      #
%##############################################################

%load data%
load SRAM_Iread_vs_VWL/DAT/dc_IREAD_in.dat;
load SRAM_Iread_vs_VWL/DAT/dc_WL.dat;

%convert to microamps%
%dc_IcellAh_MT_NX_d=dc_IcellAh_MT_NX_d*10^6;

%plot data and format figure%
semilogy(dc_WL,dc_IREAD_in,'LineWidth',2);
grid on;
xlabel('VWL','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Read Current vs. VWL','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_Iread_vs_VWL/IMG/SRAM_Iread_vs_VWL.eps');
close(gcf);


%print Iread value to file for model calculation
fout = fopen('SRAM_Iread_vs_VWL/modelParams.txt','w');
fprintf(fout,'%e\n',dc_IREAD_in(end,1));
fclose(fout);

