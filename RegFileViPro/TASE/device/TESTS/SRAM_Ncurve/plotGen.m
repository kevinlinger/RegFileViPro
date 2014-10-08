%##############################################################
%#      MATLAB code to plot SRAM cell Read Current	      #
%##############################################################

%load data%
load SRAM_Ncurve/OUT/ncurve.out;

% ncurve matrix format is:
% VDD VINA VINB VINC SVNM SINM WTV WTI

VDD  = ncurve(:,1);
VINA = ncurve(:,2);
VINB = ncurve(:,3);
VINC = ncurve(:,4);
SVNM = ncurve(:,5);
SINM = ncurve(:,6);
WTV  = ncurve(:,7);
WTI  = ncurve(:,8);

%plot data and format figure%
%plot(ncurve(:,1),ncurve(:,2:8))
subplot(211);
plot(VDD,cat(2,SVNM,WTV),'LineWidth',2);
grid on;
legend('SVNM', 'WTV', 'Location','NorthWest');
xlabel('VDD','fontsize',12);
ylabel('V','fontsize',12);
title('6T cell margins','fontsize',16);
subplot(212);
plot(VDD,cat(2,SINM,WTI),'LineWidth',2);
grid on;
legend('SINM', 'WTI', 'Location','NorthWest');
xlabel('VDD','fontsize',12);
ylabel('I (A)','fontsize',12);

%save and close%
print(gcf, '-depsc', 'SRAM_Ncurve/IMG/SRAM_Ncurve.eps');
close(gcf);


