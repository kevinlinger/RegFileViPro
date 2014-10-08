%####################################################
%#      MATLAB code to plot NMOS IDVD curves        #
%####################################################

%load data%
load IDVD_P/DAT/dc_dc.dat;
load IDVD_P/DAT/dc_P1_PX_d.dat;
load IDVD_P/DAT/dc_P2_PX_d.dat;
load IDVD_P/DAT/dc_P3_PX_d.dat;
load IDVD_P/DAT/dc_P4_PX_d.dat;
load IDVD_P/DAT/dc_P5_PX_d.dat;
load IDVD_P/DAT/dc_P5_PX_g.dat;

%calculate VGS values%
VGSvalues = dc_dc(end)/5:dc_dc(end)/5:dc_dc(end);
VGS1=strcat('VGS = ',num2str(VGSvalues(1)));
VGS2=strcat('VGS = ',num2str(VGSvalues(2)));
VGS3=strcat('VGS = ',num2str(VGSvalues(3)));
VGS4=strcat('VGS = ',num2str(VGSvalues(4)));
VGS5=strcat('VGS = ',num2str(VGSvalues(5)));

%put all data into matrix I and convert to uA/um%
I=cat(2,dc_P1_PX_d,dc_P2_PX_d,dc_P3_PX_d,dc_P4_PX_d,dc_P5_PX_d);

%simulate Ion with width 0.6um, wdef should be 0.6u%
W=<wdef>
Leff=<leff>;
I=abs(I)*1e6/(W*1e6);

%plot data and format figure%
plot(abs(dc_dc),I,'LineWidth',2);
grid on;
legend(VGS1,VGS2,VGS3,VGS4,VGS5,'Location','NorthWest');
xlabel('VDS (V)','fontsize',12);
ylabel('Drain Current (uA/um)','fontsize',12);
title('PMOS Drain Current vs. VDS','fontsize',16);

%get Ion in unit uA/um%
Ion=abs(I(end,5));
%get Ion in unit uA/um for VDS = 0, VDD/2, VDD, required for Req calculations in SRAM model
I1 = abs(I(ceil(end/2),5)); I2 = abs(I(end,5));
%get Ig in unit pA/um2%
Ig=abs(dc_P5_PX_g(1))*1e12/(W*1e6)/(Leff*1e6);
%save the Ion/Ig values into a file
fout = fopen('IDVD_P/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [Ion Ig]'); 
fclose(fout);
%save I1,I2 values into a file
fout = fopen('IDVD_P/modelParams.txt','w');
fprintf(fout,' %e\t%e\n',I1,I2);
fclose(fout);

%print Ion & Ig%
s=sprintf('Ion=%g (uA/um)\nIg=%g (pA/um2)',Ion,Ig);
ht=text(abs(dc_dc(end))/2,Ion/2,s,'fontSize',14);

%save and close%
print(gcf, '-depsc', 'IDVD_P/IMG/IDVD_P.eps');
close(gcf);

