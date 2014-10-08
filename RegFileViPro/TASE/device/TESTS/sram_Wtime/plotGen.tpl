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

a=load('SRAM_Wtime/twrite_out.txt');

wtime=(a(1,2));

fout=fopen('SRAM_Wtime/data.dat','w');
fprintf(fout,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',[node wtime VDDa VDD VBL VWL LBL VSS pwell nwell temp]);
fclose(fout);