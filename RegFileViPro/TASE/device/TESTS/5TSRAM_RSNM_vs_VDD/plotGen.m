%##############################################################
%#      MATLAB code to plot SRAM cell Read SNM vs. VDD        #
%##############################################################

%load data%
f=load('5TSRAM_RSNM_vs_VDD/out.dat');

%get VDD value%
VDD=f(:,1);

%get RSNMh, RSNMl, and RSNM%
RSNMh=f(:,2);
RSNMl=f(:,3);
RSNM=f(:,4);

%plot data and format figure%
plot(VDD,RSNMh,VDD,RSNMl,'-o','lineWidth',2);
grid on;
xlabel('VDD','fontsize',12);
ylabel('Read SNM High/Low','fontsize',12);
title('Read SNM High/Low vs. VDD','fontsize',16);

%get the SNM @nominal VDD%
RSNM_nom = RSNM(1);
%extract the slope 'k'%
p = polyfit(VDD,RSNMh,1);
k = p(1);
%save the values into a file
fout = fopen('5TSRAM_RSNM_vs_VDD/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [RSNM_nom k]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', '5TSRAM_RSNM_vs_VDD/IMG/5TSRAM_RSNM_vs_VDD.eps');
close(gcf);


