%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
f=load('SRAM_RSNM_rwm/monteCarlo/mcdata');


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

b=load('SRAM_RSNM_rwm/DAT/dc_out1.dat');
a=load('SRAM_RSNM_rwm/DAT/dc_out2.dat');
NA_Bfly=(a(:,1));
NB_Bfly=(b(:,1));

%get SNMh, SNMl, and SNM%
SNMh=f(:,1)*1e3;
SNMl=f(:,2)*1e3;
SNM=f(:,3)*1e3;
SNMmin=min(f(:,3)*1e3);

%get mean and std of SNM
[m1,s1]=normfit(SNMh);
[m2,s2]=normfit(SNMl);
[m,s]=normfit(SNM);
minx= m-(4*s);
maxx=m+(4*s);

%plot data and format figure%
[n1,d1]=hist(SNMh);
[n2,d2]=hist(SNMl);
nbars=(maxx-minx)/50;
xx=minx:nbars:maxx;
[n,d]=hist(SNM,xx);

bar(d,n,1,'b');
grid on;

strx=sprintf('Read SNM (mV) at VDD=%4.1fV VBL=%4.1fV VWL=%4.1fV\n(mean=%6.1f; sigma=%6.1f, wc=%6.1f )',VDD,VBL,VWL,m,s,SNMmin);
xlabel(strx,'fontsize',12);
ylabel('Cases','fontsize',12);

legend('RSNM');
%title('SRAM Cell Read SNMH/SNML/SNM Distribution','fontsize',16);
title('SRAM RSNM dist','fontSize',16);
%save the mean and sigma into a file
fout = fopen('SRAM_RSNM_rwm/data.txt', 'w');
fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t5f\t%f\n', [VDD VBL VWL m1 s1 m2 s2 m s SNMmin node temp VSS pwell nwell VDDa]); 
 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'SRAM_RSNM_rwm/IMG/SRAM_RSNM.eps');
%print(gcf, '-dtiff','-r300','SRAM_RSNM/IMG/SRAM_RSNM.tif')
close(gcf);


%plot(NA_Bfly,NB_Bfly,'-ok','lineWidth',1,'markerSize',1);
%grid on;
%plot(NB_Bfly,NA_Bfly,'-ok','lineWidth',1,'markerSize',1);
%y1='NB (V)';
%x1='NA (V)';
%xlabel(x1,'fontsize',12);
%ylabel(y1,'fontsize',12);
%title('SRAM B-fly curve','fontsize',16);

%save and close%
%print(gcf, '-depsc', 'SRAM_RSNM/IMG/SRAM_Bfly.eps');
%close(gcf);