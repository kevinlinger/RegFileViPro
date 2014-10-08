%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
load SRAM_RSNM_ST/DAT/dc_pvIn.dat;
load SRAM_RSNM_ST/DAT/dc_v1mv2h.dat;
f=load('SRAM_RSNM_ST/monteCarlo/mcdata');

%get VDD value%
VDD=dc_pvIn(end);

%get nominal SNM%
N=size(dc_pvIn,1);
SNMh_nom=abs(max(dc_v1mv2h(1:(N+1)/2)))/sqrt(2)*1000;
SNMl_nom=abs(min(dc_v1mv2h((N+1)/2:end)))/sqrt(2)*1000;
SNM_nom=min(SNMl_nom,SNMh_nom);

%get SNMh, SNMl, and SNM%
SNMh=f(:,1);
SNMl=f(:,2);
SNM=f(:,3);

%get mean and std of SNM
[m,s]=normfit(SNM);
[m1,s1]=normfit(SNMh);

%plot data and format figure%
[n,d]=hist(SNM);
[n1,d1]=hist(SNMh);

bar(d,n);
bar(d1,n1);
grid on;
strx=sprintf('Read SNM (mV) when VDD=%fV\n(mean=%f; sigma=%f; nominalValue=%f)',VDD,m,s,SNM_nom);
xlabel(strx,'fontsize',12);
ylabel('Occurance','fontsize',12);
title('SRAM Cell Read SNM Distribution','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_RSNM_ST/IMG/SRAM_RSNM.eps');
close(gcf);


