%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
f=load('SRAM_RSNM/monteCarlo/mcdata');

%get VDD value%
VDD=<pvdd>;

%get SNMh, SNMl, and SNM%
SNMh=f(:,1)*1e3;
SNMl=f(:,2)*1e3;
SNM=f(:,3)*1e3;

%get mean and std of SNM
[m1,s1]=normfit(SNMh);
[m2,s2]=normfit(SNMl);
[m,s]=normfit(SNM);

%plot data and format figure%
[n1,d1]=hist(SNMh);
[n2,d2]=hist(SNMl);
[n,d]=hist(SNM);
stairs(d1,n1,'-bo','lineWidth',2);
hold on;
stairs(d2,n2,'-g^','lineWidth',2);
hold on;
stairs(d,n,'-rx','lineWidth',2);
grid on;
strx=sprintf('Read SNM (mV) when VDD=%fV\n(mean=%f; sigma=%f)',VDD,m,s);
xlabel(strx,'fontsize',12);
ylabel('Occurance','fontsize',12);
legend('RNMH','RNML','RNM');
title('SRAM Cell Read SNMH/SNML/SNM Distribution','fontsize',16);

%save the mean and sigma into a file
fout = fopen('SRAM_RSNM/data.txt', 'w');
fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\n', [m1 s1 m2 s2 m s]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'SRAM_RSNM/IMG/SRAM_RSNM.eps');
close(gcf);


