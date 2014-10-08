%####################################################
%#    MATLAB code to generate NMOS IDVG temp plot   #
%####################################################

%load data%
load logidvg_n_rwm/DAT/Temp1_dc.dat;
load logidvg_n_rwm/DAT/Temp1_N1_NX_d.dat;
load logidvg_n_rwm/DAT/Temp2_N1_NX_d.dat;
load logidvg_n_rwm/DAT/Temp3_N1_NX_d.dat;
load logidvg_n_rwm/DAT/Temp4_N1_NX_d.dat;
load logidvg_n_rwm/DAT/Temp5_N1_NX_d.dat;
load logidvg_n_rwm/DAT/Temp6_N1_NX_d.dat;
load logidvg_n_rwm/DAT/Temp7_N1_NX_d.dat;
load logidvg_n_rwm/DAT/Temp8_N1_NX_d.dat;

load logidvg_n_rwm/DAT/Temp1_N2_NX_d.dat;
load logidvg_n_rwm/DAT/Temp2_N2_NX_d.dat;
load logidvg_n_rwm/DAT/Temp3_N2_NX_d.dat;
load logidvg_n_rwm/DAT/Temp4_N2_NX_d.dat;
load logidvg_n_rwm/DAT/Temp5_N2_NX_d.dat;
load logidvg_n_rwm/DAT/Temp6_N2_NX_d.dat;
load logidvg_n_rwm/DAT/Temp7_N2_NX_d.dat;
load logidvg_n_rwm/DAT/Temp8_N2_NX_d.dat;

load logidvg_n_rwm/DAT/Temp1_N3_NX_d.dat;
load logidvg_n_rwm/DAT/Temp2_N3_NX_d.dat;
load logidvg_n_rwm/DAT/Temp3_N3_NX_d.dat;
load logidvg_n_rwm/DAT/Temp4_N3_NX_d.dat;
load logidvg_n_rwm/DAT/Temp5_N3_NX_d.dat;
load logidvg_n_rwm/DAT/Temp6_N3_NX_d.dat;
load logidvg_n_rwm/DAT/Temp7_N3_NX_d.dat;
load logidvg_n_rwm/DAT/Temp8_N3_NX_d.dat;

%put data into I%
I=cat(2,Temp1_N1_NX_d,Temp2_N1_NX_d,Temp3_N1_NX_d,Temp4_N1_NX_d,Temp5_N1_NX_d,Temp6_N1_NX_d,Temp7_N1_NX_d,Temp8_N1_NX_d);
Ipd=cat(2,Temp1_N2_NX_d,Temp2_N2_NX_d,Temp3_N2_NX_d,Temp4_N2_NX_d,Temp5_N2_NX_d,Temp6_N2_NX_d,Temp7_N2_NX_d,Temp8_N2_NX_d);
Ipg=cat(2,Temp1_N3_NX_d,Temp2_N3_NX_d,Temp3_N3_NX_d,Temp4_N3_NX_d,Temp5_N3_NX_d,Temp6_N3_NX_d,Temp7_N3_NX_d,Temp8_N3_NX_d);

%plot data and format figure%
semilogy(Temp1_dc,I,'LineWidth',2);
grid on;
ylabel('Drain Current (A)','fontsize',12);
xlabel('VGS (V)','fontsize',12);
%title('NMOS Drain Current vs. VGS with T=-50 to 125C by 25C','fontsize',16);
title('NMOS Drain Current vs. VGS (-35 to 175C by 35C)','fontsize',16);
%save and close%
print(gcf, '-depsc', 'logidvg_n_rwm/IMG/logidvg_n_rwm.eps');
print(gcf, '-dtiff','-r300','logidvg_n_rwm/IMG/logidvg_n_rwm.tif')
close(gcf);

%plot data and format figure%
semilogy(Temp1_dc,Ipd,'LineWidth',2);
grid on;
ylabel('Drain Current (A)','fontsize',12);
xlabel('VGS (V)','fontsize',12);

title('SRAM PD Drain Current vs. VGS (-35 to 175C by 35C)','fontsize',16);
%save and close%
print(gcf, '-depsc', 'logidvg_n_rwm/IMG/logidvg_pd.eps');
print(gcf, '-dtiff','-r300','logidvg_n_rwm/IMG/logidvg_pd.tif')
close(gcf);

%plot data and format figure%
semilogy(Temp1_dc,Ipg,'LineWidth',2);
grid on;
ylabel('Drain Current (A)','fontsize',12);
xlabel('VGS (V)','fontsize',12);

title('SRAM PG Drain Current vs. VGS (-35 to 175C by 35C)','fontsize',16);
%save and close%
print(gcf, '-depsc', 'logidvg_n_rwm/IMG/logidvg_pg.eps');
print(gcf, '-dtiff','-r300','logidvg_n_rwm/IMG/logidvg_pg.tif')
close(gcf);