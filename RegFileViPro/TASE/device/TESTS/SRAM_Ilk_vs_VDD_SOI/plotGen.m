%##################################################################
%#   MATLAB code to plot SRAM Cell Leakage Current vs. VDD	  #
%#                                                                #
%# Created by jw4pg@virginia.edu & modified by rwm                #
%##################################################################


%load data%
VDD=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_pvdd.dat');

Is1=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellLh_MP_PX_s.dat');
Is2=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellRh_MN_NX_s.dat');
Is3=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellLh_MT_NX_s.dat');

%Ij1=load('SRAM_Ileak_vs_VDD/DAT/dc_ICell_ICellLh_MT_NX_b.dat');
%Ij2=load('SRAM_Ileak_vs_VDD/DAT/dc_ICell_ICellLh_MP_PX_b.dat');
%Ij3=load('SRAM_Ileak_vs_VDD/DAT/dc_ICell_ICellRh_MN_NX_b.dat');
%Ij4=load('SRAM_Ileak_vs_VDD/DAT/dc_ICell_ICellRh_MT_NX_b.dat');

Ig1=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellLh_MT_NX_g.dat');
Ig2=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellLh_MP_PX_g.dat');
Ig3=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellLh_MN_NX_g.dat');
Ig4=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellRh_MT_NX_g.dat');
Ig5=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellRh_MP_PX_g.dat');
Ig6=load('SRAM_Ilk_vs_VDD_SOI/DAT/dc_ICell_ICellRh_MN_NX_g.dat');

%get Ileak, unit pA%
Is1=abs(Is1)*1e12;
Is2=abs(Is2)*1e12;
Is3=abs(Is3)*1e12;

%Ij1=abs(Ij1)*1e12;
%Ij2=abs(Ij2)*1e12;
%Ij3=abs(Ij3)*1e12;
%Ij4=abs(Ij4)*1e12;

Ig1=abs(Ig1)*1e12;
Ig2=abs(Ig2)*1e12;
Ig3=abs(Ig3)*1e12;
Ig4=abs(Ig4)*1e12;
Ig5=abs(Ig5)*1e12;
Ig6=abs(Ig6)*1e12;

Isub=[Is1 Is2 Is3];
%Ij=[Ij1 Ij2 Ij3 Ij4];
Ig=[Ig1 Ig2 Ig3 Ig4 Ig5 Ig6];

%%Total subthreshold leakage current%%
Isub_tot=sum(Isub,2);

%%Total junction/GIDL leakage current%%
%Ij_tot=sum(Ij,2);

%%Total gate leakage current%%
Ig_tot=sum(Ig,2);

%%Total leakage current%%
Ilk_tot=Isub_tot + Ig_tot;


%plot data and format figure%
semilogy(VDD,Ilk_tot,'-ro','lineWidth',2,'markerSize',4);
hold on;
semilogy(VDD,Isub_tot,'--bx','lineWidth',2,'markerSize',4);
semilogy(VDD,Ig_tot,'--m^','lineWidth',2,'markerSize',4);
%semilogy(VDD,Ij_tot,'--cv','lineWidth',2,'markerSize',4);
legend('Ilk_{total}','Isub','Igate','location','southEast');
grid on;
yl='Cell Leakage Current (pA)';
ylabel(yl,'fontsize',12);
xlabel('VDD (V)','fontsize',12);
title('6T Cell Ileak vs. VDD','fontsize',16);
%axis([.4,1.2,.01,50]);

%save and close%
print(gcf, '-depsc', 'SRAM_Ilk_vs_VDD_SOI/IMG/SRAM_Ilk_vs_VDD_SOI.eps');
close(gcf);


%plot data and format figure%
semilogy(VDD,Ilk_tot*1024*1e-12,'-ro','lineWidth',2,'markerSize',4);
hold on;
%semilogy(VDD,Isub_tot,'--bx','lineWidth',2,'markerSize',4);
%semilogy(VDD,Ig_tot,'--m^','lineWidth',2,'markerSize',4);
%semilogy(VDD,Ij_tot,'--cv','lineWidth',2,'markerSize',4);
legend('ALM-6T_{total}','location','southEast');
grid on;
yl='Array Leakage Current (A)';
ylabel(yl,'fontsize',12);
xlabel('VDD (V)','fontsize',12);
title('6T Array Ileak vs. VDD','fontsize',16);
%axis([.4,1.2,.01,50]);

%save and close%
print(gcf, '-depsc', 'SRAM_Ilk_vs_VDD_SOI/IMG/SRAM_arrayLkg_vs_VDD_SOI.eps');
close(gcf);



%save data
fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Itot.txt','w');
fprintf(fout, '%f\n',[ Ilk_tot]);
fclose(fout);
fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Isub.txt','w');
fprintf(fout, '%f\n',[ Isub_tot]);
fclose(fout);
%fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Igidl.txt','w');
%fprintf(fout, '%f\n',[ Ij_tot]);
%fclose(fout);
fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Igate.txt','w');
fprintf(fout, '%f\n',[ Ig_tot]);
fclose(fout);

%save data
fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Itot.dat','w');
fprintf(fout, '%f\n',[ Ilk_tot]);
fclose(fout);
fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Isub.dat','w');
fprintf(fout, '%f\n',[ Isub_tot]);
fclose(fout);
%fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Igidl.dat','w');
%fprintf(fout, '%f\n',[ Ij_tot]);
%fclose(fout);
fout = fopen('SRAM_Ilk_vs_VDD_SOI/DAT/Igate.dat','w');
fprintf(fout, '%f\n',[ Ig_tot]);
fclose(fout);

