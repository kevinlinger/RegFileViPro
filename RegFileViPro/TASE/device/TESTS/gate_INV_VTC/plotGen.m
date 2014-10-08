%####################################################
%#      MATLAB code to plot inverter VTC            #
%####################################################

%load data%
load gate_INV_VTC/DAT/dc_IN.dat;
load gate_INV_VTC/DAT/dc_OUT.dat;

%plot data and format figure%
plot(dc_IN,dc_OUT,'LineWidth',2);
grid on;
xlabel('VIN (V)','fontsize',12);
ylabel('VOUT (V)','fontsize',12);
title('Inverter VTC','fontsize',16);

%save and close%
print(gcf, '-depsc', 'gate_INV_VTC/IMG/gate_INV_VTC.eps');
close(gcf);

