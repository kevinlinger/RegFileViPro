%####################################################
%#      MATLAB code to plot Qcrit        #
%####################################################

%load data%

load SRAM_Qcrit/DAT/tran_NA.dat;
load SRAM_Qcrit/OUT/;


%# not sure how to proceed below#######%

%calculate VGS values%
VGSvalues = dc_dc(end)/5:dc_dc(end)/5:dc_dc(end);
%VGS1=strcat('VGS = ',num2str(VGSvalues(1)));
%VGS2=strcat('VGS = ',num2str(VGSvalues(2)));
%VGS3=strcat('VGS = ',num2str(VGSvalues(3)));
%VGS4=strcat('VGS = ',num2str(VGSvalues(4)));
VGS5=strcat('VGS = ',num2str(VGSvalues(5)));

%put all data into matrix I and convert to uA/um%
I=dc_I5_MPD_NX_d*1e6;


V=dc_QN;

%plot data and format figure%
plot(dc_dc,I,'LineWidth',2);
grid on;
legend(VGS5,'Location','NorthWest');
xlabel('WL (V)','fontsize',12);
ylabel('Iread (uA)','fontsize',12);
title('Iread vs. VWL','fontsize',16);

%print Ion & Ig%
s=sprintf('Iread=%g ',I(end));
ht=text(dc_dc(end)/2,I(end)/2,s,'fontSize',14);

%save and close%
print(gcf, '-depsc', 'SRAM_PD_PG_series/IMG/IreadvsWLV.eps');
close(gcf);


plot(dc_dc,V,'LineWidth',2);
grid on;
legend(VGS5,'Location','NorthWest');
xlabel('WLV (V)','fontsize',12);
ylabel('Int node voltage (V)','fontsize',12);
title('Int node voltage vs. WLV','fontsize',16);


%save and close%
print(gcf, '-depsc', 'SRAM_PD_PG_series/IMG/IntNodeV.eps');
close(gcf);
