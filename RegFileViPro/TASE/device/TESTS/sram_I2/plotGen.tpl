%################################################################
%#      MATLAB code to plot SRAM cell Read  distribution     #
%################################################################

%load data%
%load SRAM_I2/DAT/dc_VVGS.dat;
load SRAM_I2/DAT/dc_N2_NX_d.dat;
f=load('SRAM_I2/monteCarlo/mcdata');

%get VDD value%
%VDD=dc_VVGS(end);
Ire=dc_N2_NX_d(end);
Iread=Ire*1e6;
VBL=<bitline>;
VDD=<pvdd>;
VDDa=<pvdda>;
VSS=<pvss>;
pwell=<pvbn>;
nwell=<pvbp>;
WLV=<wlv>;
Nd=<ldef>;
Node=Nd*1e9;

Ir_dist=f(:,2)*1e6;
Ir_wc=min(f(:,2))*1e6;

%get mean and std of SNM
[m,s]=normfit(Ir_dist);

minx=0;
minxx=0;
maxx=m+(4*s);
nbars=(maxx-minx)/50;
%xx=minx:0.5:maxx;
xx=minxx:nbars:maxx;
%plot data and format figure%
[n,d]=hist(Ir_dist,xx);


bar(d,n,1,'b');

grid on;
%strx=sprintf('I read (uA) when VDD=%4.1fV VBL=%4.1fV VWL=%4.1fV\n(mean=%f; sigma=%f; nominalValue=%f)',VDD,VBL,VWL,m,s,Iread);


strx=sprintf('I read (uA) \n(mean=%2.2f; sigma=%2.2f;  nominal Iread=%2.2f; wc=%2.2f )',m,s,Iread,Ir_wc);
xlabel(strx,'fontsize',12);
ylabel('Cases','fontsize',12);
title('SRAM Cell Iread Distribution','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_I2/IMG/SRAM_Iread_dist.eps');
print(gcf, '-dtiff','-r300','SRAM_I2/IMG/SRAM_Iread_dist.tif');
close(gcf);

fout = fopen('SRAM_I2/data.txt', 'w');
fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', [VDD VBL WLV Iread m s Ir_wc Node VSS nwell pwell ]);
%fprintf(fout, '%f\t%f\t%f\n', [ Iread m s ]); 
fclose (fout);