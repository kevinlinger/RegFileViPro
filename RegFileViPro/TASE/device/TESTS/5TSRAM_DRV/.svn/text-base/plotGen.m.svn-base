%##############################################################
%#      MATLAB code to plot SRAM DRV distribution	      #
%# Created by svn2u                                           #
%# Modified by jw4pg                                          #
%##############################################################


%load data%
f0=load('5TSRAM_DRV/OUT/DRV0/monteCarlo/mcdata');
f1=load('5TSRAM_DRV/OUT/DRV1/monteCarlo/mcdata');

%get DRV%
DRV0=f0(:,1);
DRV1=f1(:,1);
DRV=max(DRV0,DRV1);

%get mean and std
[m,s]=normfit(DRV);

%plot data and format figure%
[n,d]=hist(DRV);
bar(d,n);
grid on;
strx=sprintf('Dynamic Retention Voltage (mV)\n(mean=%f; sigma=%f)',m,s);
xlabel(strx,'fontsize',12);
ylabel('Occurance','fontsize',12);
title('DRV Distribution','fontsize',16);

%save and close%
print(gcf, '-depsc', '5TSRAM_DRV/IMG/5TSRAM_DRV.eps');
close(gcf);
