%####################################################
%#    MATLAB code to generate NMOS IDVG temp plot   #
%####################################################

%load data%
load logIDVG_N/DAT/Temp1_dc.dat;
load logIDVG_N/DAT/Temp1_N1_NX_d.dat;
load logIDVG_N/DAT/Temp2_N1_NX_d.dat;
load logIDVG_N/DAT/Temp3_N1_NX_d.dat;
load logIDVG_N/DAT/Temp4_N1_NX_d.dat;
load logIDVG_N/DAT/Temp5_N1_NX_d.dat;
load logIDVG_N/DAT/Temp6_N1_NX_d.dat;
load logIDVG_N/DAT/Temp7_N1_NX_d.dat;
load logIDVG_N/DAT/Temp8_N1_NX_d.dat;

%put data into I%
I=cat(2,Temp1_N1_NX_d,Temp2_N1_NX_d,Temp3_N1_NX_d,Temp4_N1_NX_d,Temp5_N1_NX_d,Temp6_N1_NX_d,Temp7_N1_NX_d,Temp8_N1_NX_d);

%plot data and format figure%
semilogy(Temp1_dc,I,'LineWidth',2);
grid on;
ylabel('Drain Current (A)','fontsize',12);
xlabel('VGS (V)','fontsize',12);
title('NMOS Drain Current vs. VGS with T=-50 to 125C by 25C','fontsize',16);

%save and close%
print(gcf, '-depsc', 'logIDVG_N/IMG/logIDVG_N.eps');
close(gcf);

