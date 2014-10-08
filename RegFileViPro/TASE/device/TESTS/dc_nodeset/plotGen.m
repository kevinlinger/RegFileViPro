%##############################################################
%#      MATLAB code to plot SRAM cell Read Current	      #
%##############################################################

%load data%
load dc_nodeset/DAT/dc_VDD.dat;
load dc_nodeset/DAT/dc_V1.dat;

%convert to microamps%
%dc_IcellAh_MT_NX_d=dc_IcellAh_MT_NX_d*10^6;

%plot data and format figure%
plot(dc_VDD,dc_V1,'LineWidth',2);
grid on;
xlabel('VDD','fontsize',12);
ylabel('V1','fontsize',12);
title('Testing Nodeset on DC analysis','fontsize',16);

%save and close%
print(gcf, '-depsc', 'dc_nodeset/IMG/dc_nodeset.eps');
close(gcf);


