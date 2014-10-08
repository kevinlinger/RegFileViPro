%####################################################
%#      MATLAB code to plot NMOS logIDVD curves     #
%####################################################

%load data%
load logIDVD_N/DAT/dc_dc.dat;
load logIDVD_N/DAT/dc_N1_NX_d.dat;
load logIDVD_N/DAT/dc_N2_NX_d.dat;
load logIDVD_N/DAT/dc_N3_NX_d.dat;

%calculate VGS values%
VGSvalues = [0,dc_dc(end)/2,dc_dc(end)];
VGS1=strcat('VGS = ',num2str(VGSvalues(1)));
VGS2=strcat('VGS = ',num2str(VGSvalues(2)));
VGS3=strcat('VGS = ',num2str(VGSvalues(3)));

%put all data into matrix I%
I=cat(2,dc_N1_NX_d,dc_N2_NX_d,dc_N3_NX_d);

%plot data and format figure%
semilogy(dc_dc,I,'LineWidth',2);
grid on;
legend(VGS1,VGS2,VGS3,'Location','NorthWest');
xlabel('VDS (V)','fontsize',12);
ylabel('Drain Current (A)','fontsize',12);
title('NMOS Drain Current vs. VDS','fontsize',16);

%save and close%
print(gcf, '-depsc', 'logIDVD_N/IMG/logIDVD_N.eps');
close(gcf);
