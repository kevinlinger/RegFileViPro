%################################################################
%#      MATLAB code to plot SRAM cell Read SNM distribution     #
%################################################################

%load data%
load RSTSRAM_RSNM/DAT/dc_pvIn.dat;
load RSTSRAM_RSNM/DAT/dc_v1mv2h.dat;
f=load('RSTSRAM_RSNM/monteCarlo/mcdata');

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

%plot data and format figure%
[n,d]=hist(SNM);
bar(d,n);
grid on;
strx=sprintf('Read SNM (mV) when VDD=%fV\n(mean=%f; sigma=%f; nominalValue=%f)',VDD,m,s,SNM_nom);
xlabel(strx,'fontsize',12);
ylabel('Occurance','fontsize',12);
title('SRAM Cell Read SNM Distribution','fontsize',16);

%save and close%
print(gcf, '-depsc', 'RSTSRAM_RSNM/IMG/RSTSRAM_RSNM.eps');
close(gcf);
