%##############################################################
%#      MATLAB code to plot SRAM cell Write Margin vs VDD     #
%##############################################################

%load data%
f=load('SRAM_WM_SNM_vs_VDD/out.dat');

%get VDD value%
VDD=f(:,1);

%get WM%
WM=f(:,2);

  
%plot data and format figure%
plot(VDD,WM,'-o','lineWidth',2);
grid on;
xlabel('VDD (V)','fontsize',12);
ylabel('Write Margin via VTC (V)','fontsize',12);
title('Write Margin vs. VDD','fontsize',16);

%get the WM @nominal VDD%
WM_nom = WM(1);
%extract the slope 'k'%
p = polyfit(VDD,WM,1);
k = p(1);
%save the values into a file
fout = fopen('SRAM_WM_SNM_vs_VDD/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [WM_nom k]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'SRAM_WM_SNM_vs_VDD/IMG/SRAM_WM_SNM_vs_VDD.eps');
close(gcf);


