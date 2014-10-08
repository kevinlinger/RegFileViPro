%####################################################
%#   MATLAB code to generate PMOS IDVG temp plot    #
%####################################################

%load data%
load logIDVG_P/DAT/Temp1_dc.dat;
load logIDVG_P/DAT/Temp1_P1_PX_d.dat;
load logIDVG_P/DAT/Temp2_P1_PX_d.dat;
load logIDVG_P/DAT/Temp3_P1_PX_d.dat;
load logIDVG_P/DAT/Temp4_P1_PX_d.dat;
load logIDVG_P/DAT/Temp5_P1_PX_d.dat;
load logIDVG_P/DAT/Temp6_P1_PX_d.dat;
load logIDVG_P/DAT/Temp7_P1_PX_d.dat;
load logIDVG_P/DAT/Temp8_P1_PX_d.dat;

%put data into I%
I=cat(2,Temp1_P1_PX_d,Temp2_P1_PX_d,Temp3_P1_PX_d,Temp4_P1_PX_d,Temp5_P1_PX_d,Temp6_P1_PX_d,Temp7_P1_PX_d,Temp8_P1_PX_d);

%plot data and format figure%
semilogy(Temp1_dc*-1,abs(I),'LineWidth',2);
grid on;
ylabel('\midDrain Current\mid (A)','fontsize',12);
xlabel('-VGS (V)','fontsize',12);
title('PMOS Drain Current vs. VGS (-50 to 125C by 25C)','fontsize',16);

%save and close%
print(gcf, '-depsc', 'logIDVG_P/IMG/logIDVG_P.eps');
close(gcf);
