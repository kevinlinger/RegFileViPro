%######################################################
%#      MATLAB code to generate PMOS logIDVD curves   #
%######################################################

%load data%
load logIDVD_P/DAT/dc_dc.dat;
load logIDVD_P/DAT/dc_P1_PX_d.dat;
load logIDVD_P/DAT/dc_P2_PX_d.dat;
load logIDVD_P/DAT/dc_P3_PX_d.dat;

%calculate VGS values%
VGSvalues = [0,dc_dc(end)/2,dc_dc(end)];
VGS1=strcat('\midVGS\mid = ',num2str(abs(VGSvalues(1))));
VGS2=strcat('\midVGS\mid = ',num2str(abs(VGSvalues(2))));
VGS3=strcat('\midVGS\mid = ',num2str(abs(VGSvalues(3))));

%put all data into matrix I%
I=cat(2,dc_P1_PX_d,dc_P2_PX_d,dc_P3_PX_d);

%plot data and format figure%
semilogy(abs(dc_dc),abs(I),'LineWidth',2);
grid on;
legend(VGS1,VGS2,VGS3,'Location','SouthEast');
xlabel('\midVDS\mid (V)','fontsize',12);
ylabel('\midDrain Current\mid (A)','fontsize',12);
title('PMOS Drain Current vs. VDS','fontsize',16);

%save and close%
print(gcf, '-depsc', 'logIDVD_P/IMG/logIDVD_P.eps');
close(gcf);
