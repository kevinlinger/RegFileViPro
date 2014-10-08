%##############################################################
%#      MATLAB code to plot SRAM cell Hold SNM vs Temp  #
%##############################################################

%load data%
%f=load('sram_HSNM/monteCarlo/mcdata');
load sram_HSNM/DAT/Temp1_dc.dat;
load sram_HSNM/DAT/Temp1_pvIn.dat;
load sram_HSNM/DAT/Temp1_v1mv2h.dat;
load sram_HSNM/DAT/Temp2_v1mv2h.dat;
load sram_HSNM/DAT/Temp3_v1mv2h.dat;
load sram_HSNM/DAT/Temp4_v1mv2h.dat;
load sram_HSNM/DAT/Temp5_v1mv2h.dat;
load sram_HSNM/DAT/Temp6_v1mv2h.dat;

hsnm=cat(2,Temp1_v1mv2h,Temp2_v1mv2h,Temp3_v1mv2h,Temp4_v1mv2h,Temp5_v1mv2h,Temp6_v1mv2h);

%get VDD value%
VDD=<pvdd>;

plot(Temp1_dc,hsnm,2,2);

%save the mean and sigma into a file
%fout = fopen('sram_HSNM/data.txt', 'w');
%fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\n', [m1 s1 m2 s2 m s]'); 
%fclose(fout);

%save and close%
print(gcf, '-depsc', 'sram_HSNM/IMG/sram_HSNM_vs_Temp.eps');
close(gcf);


