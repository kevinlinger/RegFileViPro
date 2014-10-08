%####################################################
%#      MATLAB code to plot   write time            #
%####################################################

%load data%


VDD=<pvdd>;
VDDa=<pvdda>;
VWL=<wlv>;
VSS=<pvss>;
VBL=<bitline>;
LBL=<lbl>;
nd=<ldef>;
node=nd*1e9;
temp=<temp>;
pwell=<pvbn>;
nwell=<pvbp>;
blcap=<blcap>;

a=load('sram_Read_delay/tread_out.txt');

rtime=(a(1,2));

fout=fopen('sram_Read_delay/data.dat','w');
fprintf(fout,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',[node rtime VDDa VDD VBL VWL LBL VSS pwell nwell temp blcap]);
fclose(fout);