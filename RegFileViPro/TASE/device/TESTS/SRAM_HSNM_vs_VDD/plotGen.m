%##############################################################
%#      MATLAB code to plot SRAM cell Hold SNM vs. VDD        #
%##############################################################

%load data%
f=load('SRAM_HSNM_vs_VDD/out.dat');

%get VDD value%
VDD=f(:,1);

%get SNMh, SNMl, and SNM%
SNMh=f(:,2);
SNMl=f(:,3);
SNM=f(:,4);

%plot data and format figure%
plot(VDD,[SNMh SNMl],'-o','lineWidth',2);
grid on;
xlabel('VDD','fontsize',12);
ylabel('SNM High/Low','fontsize',12);
title('SNM High/Low vs. VDD','fontsize',16);

%get the SNM @nominal VDD%
SNM_nom = SNM(1);
%extract the slope 'k'%
p = polyfit(VDD,SNMh,1);
k = p(1);
%save the values into a file
fout = fopen('SRAM_HSNM_vs_VDD/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [SNM_nom k]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'SRAM_HSNM_vs_VDD/IMG/SRAM_HSNM_vs_VDD.eps');
close(gcf);


