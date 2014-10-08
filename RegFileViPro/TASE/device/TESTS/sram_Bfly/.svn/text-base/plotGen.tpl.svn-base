%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
load SRAM_Bfly/DAT/dc_pvIn.dat;
load SRAM_Bfly/DAT/dc_B.dat;
%f=load('SRAM_Bfly/monteCarlo/mcdata');
b=load('SRAM_Bfly/DAT/dc_B.dat');
a=load('SRAM_Bfly/DAT/dc_A.dat');
c=load('SRAM_Bfly/DAT/dc_C.dat');
d=load('SRAM_Bfly/DAT/dc_D.dat');
xma=<pvdd>;
xmax=xma+0.1;

%get VDD value%
VDD=dc_pvIn(end);
NA_Bfly=(a(:,1));
NB_Bfly=(b(:,1));
NC_Bfly=(c(:,1));
ND_Bfly=(d(:,1));

%get nominal SNM%
%N=size(dc_pvIn,1);
%SNMh_nom=abs(max(dc_v1mv2h(1:(N+1)/2)))/sqrt(2)*1000;
%SNMl_nom=abs(min(dc_v1mv2h((N+1)/2:end)))/sqrt(2)*1000;
%SNM_nom=min(SNMl_nom,SNMh_nom);

%get SNMh, SNMl, and SNM%
%SNMh=f(:,1);
%SNMl=f(:,2);
%SNM=f(:,3);

%get mean and std of SNM
%[m,s]=normfit(SNM);
%[m1,s1]=normfit(SNMh);

%plot data and format figure%
%[n,d]=hist(SNM);
%[n1,d1]=hist(SNMh);

%bar(d,n);
%bar(d1,n1);
plot(NA_Bfly,NB_Bfly,'-ok','lineWidth',1,'markerSize',1);
hold on;
plot(ND_Bfly,NC_Bfly,'-ob','lineWidth',1,'markerSize',1);
grid on;
%strx=sprintf('Read SNM (mV) when VDD=%fV\n(mean=%f; sigma=%f; nominalValue=%f)',VDD,m,s,SNM_nom);
%%%%%%%%%%%%%%%%%%%%%%%
% I removed the following on 9/24/09
%axis([0,xmax,0,xmax]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y1='node B (V)';
x1='node A (V)';
xlabel(x1,'fontsize',12);
ylabel(y1,'fontsize',12);
%title('SRAM B-fly curve','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_Bfly/IMG/SRAM_Bfly.eps');
print(gcf, '-dtiff','-r300','SRAM_Bfly/IMG/SRAM_Bfly.tif');
close(gcf);


