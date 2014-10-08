%####################################################
%#      MATLAB code to plot NMOS IDVD curves        #
%####################################################

%load data%
load IDVD_PG/DAT/dc_dc.dat;
load IDVD_PG/DAT/dc_N1_NX_d.dat;
load IDVD_PG/DAT/dc_N2_NX_d.dat;
load IDVD_PG/DAT/dc_N3_NX_d.dat;
load IDVD_PG/DAT/dc_N4_NX_d.dat;
load IDVD_PG/DAT/dc_N5_NX_d.dat;
load IDVD_PG/DAT/dc_N5_NX_g.dat;

%calculate VGS values%
VGSvalues = dc_dc(end)/5:dc_dc(end)/5:dc_dc(end);
VGS1=strcat('VGS = ',num2str(VGSvalues(1)));
VGS2=strcat('VGS = ',num2str(VGSvalues(2)));
VGS3=strcat('VGS = ',num2str(VGSvalues(3)));
VGS4=strcat('VGS = ',num2str(VGSvalues(4)));
VGS5=strcat('VGS = ',num2str(VGSvalues(5)));

%put all data into matrix I and convert to uA/um%
I=cat(2,dc_N1_NX_d,dc_N2_NX_d,dc_N3_NX_d,dc_N4_NX_d,dc_N5_NX_d);
%simulate Ion with width 0.6um%
W=<wdef>;
Leff=<leff>;
I=I*1e6/(W*1e6);  %I in the unit of uA/um

%plot data and format figure%
plot(dc_dc,I,'LineWidth',2);
grid on;
legend(VGS1,VGS2,VGS3,VGS4,VGS5,'Location','NorthWest');
xlabel('VDS (V)','fontsize',12);
ylabel('Drain Current (uA/um)','fontsize',12);
title('NMOS Drain Current vs. VDS','fontsize',16);

%get Ion in unit uA/um%
Ion=I(end,5);
%get Ion in unit uA/um for VDS = 0, VDD/2, VDD, required for Req calculations in SRAM model
I1 = abs(I(ceil(end/2),5)); I2 = abs(I(end,5));
%get Ig in unit pA/um2%
Ig=abs(dc_N5_NX_g(1))*1e12/(W*1e6)/(Leff*1e6);
%save the Ion/Ig values into a file
fout = fopen('IDVD_PG/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [Ion Ig]'); 
fclose(fout);
%save I1,I2 values into a file
fout = fopen('IDVD_PG/modelParams.txt','w');
fprintf(fout,' %e\t%e\n',I1,I2);
fclose(fout);


%print Ion & Ig%
s=sprintf('Ion=%g (uA/um)\nIg=%g (pA/um2)',Ion,Ig);
ht=text(dc_dc(end)/2,Ion/2,s,'fontSize',14);


%save and close%
print(gcf, '-depsc', 'IDVD_PG/IMG/IDVD_PG.eps');
close(gcf);

