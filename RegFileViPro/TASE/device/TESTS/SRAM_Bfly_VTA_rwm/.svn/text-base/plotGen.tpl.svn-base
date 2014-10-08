%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
load SRAM_Bfly_VTA_rwm/DAT/dc_pvIn.dat;
load SRAM_Bfly_VTA_rwm/DAT/dc_B.dat;
b=load('SRAM_Bfly_VTA_rwm/DAT/dc_B.dat');
a=load('SRAM_Bfly_VTA_rwm/DAT/dc_A.dat');
c=load('SRAM_Bfly_VTA_rwm/DAT/dc_C.dat');
d=load('SRAM_Bfly_VTA_rwm/DAT/dc_D.dat');
xma=<pvdd>;
xmax=xma+0.1;

%get VDD value%
VDD=dc_pvIn(end);
NA_Bfly=(a(:,1));
NB_Bfly=(b(:,1));
NC_Bfly=(c(:,1));
ND_Bfly=(d(:,1));


plot(NA_Bfly,NB_Bfly,'-ok','lineWidth',2,'markerSize',1);
hold on;
plot(ND_Bfly,NC_Bfly,'-ob','lineWidth',2,'markerSize',1);
grid on;
%strx=sprintf('Read SNM (mV) when VDD=%fV\n(mean=%f; sigma=%f; nominalValue=%f)',VDD,m,s,SNM_nom);
axis=([0 1.2 0 1.2]);
y1='node QB (V)';
x1='node Q (V)';
xlabel(x1,'fontsize',14,'fontweight','bold');
ylabel(y1,'fontsize',14,'fontweight','bold');
%title('SRAM B-fly curve','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_Bfly_VTA_rwm/IMG/SRAM_Bfly_VTA_rwm.eps');
print(gcf, '-dtiff','-r300','SRAM_Bfly_VTA_rwm/IMG/SRAM_Bfly_VTA_rwm.tif');
close(gcf);


