%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
f=load('SRAM_RSNM_VWL/monteCarlo/mcdata');

%get VDD value%
VDD=<pvdd>;
VBL=<bitline>;
VWL=<wlv>;

%get SNMh, SNMl, and SNM%
SNMh=f(:,1)*1e3;
SNMl=f(:,2)*1e3;
SNM=f(:,3)*1e3;
SNMmin=min(f(:,3)*1e3);

%get mean and std of SNM
[m1,s1]=normfit(SNMh);
[m2,s2]=normfit(SNMl);
[m,s]=normfit(SNM);

%plot data and format figure%
[n1,d1]=hist(SNMh);
[n2,d2]=hist(SNMl);
[n,d]=hist(SNM);
%bar(d1,n1,1);
%hold on;
%bar(d2,n2,1);
%hold on;
bar(d,n,1);
grid on;
%axis([0,500,0,40]);
strx=sprintf('Read SNM (mV) at VDD=%fV VWL=%fV \n(mean=%f; sigma=%f, wc=%f )',VDD,VWL,m,s,SNMmin);
xlabel(strx,'fontsize',12);
ylabel('Cases','fontsize',12);
%legend('RNMH','RNML','RNM');
legend('RSNM');
%title('SRAM Cell Read SNMH/SNML/SNM Distribution','fontsize',16);
title('SRAM RSNM dist','fontSize',16);
%save the mean and sigma into a file
fout = fopen('SRAM_RSNM/data.txt', 'w');
fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', [VDD VBL VWL m1 s1 m2 s2 m s SNMmin]'); 
%fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\t%f\n', [ m1 s1 m2 s2 m s SNMmin]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'SRAM_RSNM/IMG/SRAM_RSNM_WLV.eps');
close(gcf);


