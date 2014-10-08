%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
f=load('SRAM_RSNM_VTA_rwm/monteCarlo/mcdata');


%get VDD value%
VDD=<pvdd>;
VBL=<bitline>;
VWL=<wlv>;
VSS=<pvss>;
nd=<ldef>;
node=nd*1e9;
temp=<temp>;
pwell=<pvbn>;
nwell=<pvbp>;
VDDa=<pvdda>;
pdvtar=<pdvtar>;
pdvtal=<pdvtal>;
pgvtar=<pgvtar>;
pgvtal=<pgvtal>;
puvtar=<puvtar>;
puvtal=<puvtal>;
mcrunNum=<mcrunNum>;

b=load('SRAM_RSNM_VTA_rwm/DAT/dc_out1.dat');
a=load('SRAM_RSNM_VTA_rwm/DAT/dc_out2.dat');
NA_Bfly=(a(:,1));
NB_Bfly=(b(:,1));

delpdvt=(pdvtar-pdvtal)*1000;
delpgvt=(pgvtar-pgvtal)*1000;
delpuvt=(puvtar-puvtal)*1000;

%get SNMh, SNMl, and SNM%
SNMh=f(:,1)*1e3;
SNMl=f(:,2)*1e3;
SNM=f(:,3)*1e3;
SNMmin=min(f(:,3)*1e3);
SNMwc0=min(f(:,1)*1e3);
SNMwc1=min(f(:,2)*1e3);

%get mean and std of SNM
[m1,s1]=normfit(SNMh);
skh=skewness(SNMh);
[m2,s2]=normfit(SNMl);
skl=skewness(SNMl);
[m,s]=normfit(SNM);
skf=skewness(SNM);
%minx= m-(4*s);
minx=SNMmin;
maxx=m+(4*s);

%plot data and format figure%

nbars=(maxx-minx)/50;
xx=minx:nbars:maxx;
[n,d]=hist(SNM,xx);
[n1,d1]=hist(SNMh,xx);
[n2,d2]=hist(SNMl,xx);

bar(d,n,1,'b');
grid on;

%strx=sprintf('Read SNM (mV) at VDD=%4.1fV VBL=%4.1fV VWL=%4.1fV\n(mean=%6.1f; sigma=%6.1f, wc=%6.1f )',VDD,VBL,VWL,m,s,SNMmin);
strx=sprintf('Read SNM (mV) at VDD=%4.1fV VBL=%4.1fV VWL=%4.1fV and Temp=%3.1fC\n(mean=%6.1fmV, sigma=%6.1fmV, wc=%6.1fmV )',VDD,VBL,VWL,temp,m,s,SNMmin);

xlabel(strx,'fontsize',12);
ylabel('Cases','fontsize',12);

legend('RSNM');
%title('SRAM Cell Read SNMH/SNML/SNM Distribution','fontsize',16);
title('SRAM RSNM dist','fontSize',16);
%save the mean and sigma into a file
fout = fopen('SRAM_RSNM_VTA_rwm/data.txt', 'w');
%fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t5f\t%f\n', [VDD VBL VWL m1 s1 m2 s2 m s SNMmin node temp VSS pwell nwell VDDa]);
fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', [VDD VBL VWL m1 s1 m2 s2 m s SNMmin node temp VSS pwell delpdvt pdvtar delpgvt pgvtar delpuvt puvtar ]);  
 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'SRAM_RSNM_VTA_rwm/IMG/SRAM_RSNMvta.eps');
%print(gcf, '-dtiff','-r300','SRAM_RSNM/IMG/SRAM_RSNM.tif')
close(gcf);



bar(d1,n1,1,'b');
grid on;

strx=sprintf('Read SNM0 (mV) at VDD=%4.1fV VBL=%4.1fV VWL=%4.1fV and Temp=%3.1fC\n(mean=%6.1fmV, sigma=%6.1fmV, wc=%6.1fmV )',VDD,VBL,VWL,temp,m1,s1,SNMwc0);
xlabel(strx,'fontsize',12);
ylabel('Cases','fontsize',12);

legend('RSNM0');

title('SRAM RSNM0 dist','fontSize',16);

print(gcf, '-depsc', 'SRAM_RSNM_VTA_rwm/IMG/SRAM_RSNM0.eps');
close(gcf);


bar(d2,n2,1,'b');
grid on;

strx=sprintf('Read SNM1 (mV) at VDD=%4.1fV VBL=%4.1fV VWL=%4.1fV and Temp=%3.1fC\n(mean=%6.1fmV, sigma=%6.1fmV, wc=%6.1fmV )',VDD,VBL,VWL,temp,m2,s2,SNMwc1);
xlabel(strx,'fontsize',12);
ylabel('Cases','fontsize',12);

legend('RSNM1');

title('SRAM RSNM1 dist','fontSize',16);

print(gcf, '-depsc', 'SRAM_RSNM_VTA_rwm/IMG/SRAM_RSNM1.eps');
close(gcf);