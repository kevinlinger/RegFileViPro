%##############################################################
%#      MATLAB code to plot SRAM Write SNM distribution       #
%##############################################################


f1 = [];
f2 = [];
f3 = [];
f4 = [];
f5 = [];
f6 = [];
x = [ -0.2 -0.18 -.16 -.14 -.12 -.1 -.08 -.06 -.04 -.02 0 .02 .04 .06 .08 .1 .12 .14 .16 .18 .2];

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('SRAM_WM_SNM_pvta/WM_SNM1.txt')   
  %load data%
  f1=load('SRAM_WM_SNM_pvta/WM_SNM1.txt');
  f2=load('SRAM_WM_SNM_pvta/WM_SNM2.txt');
  f3=load('SRAM_WM_SNM_pvta/WM_SNM3.txt');
  f4=load('SRAM_WM_SNM_pvta/WM_SNM4.txt');
  f5=load('SRAM_WM_SNM_pvta/WM_SNM5.txt');
  f6=load('SRAM_WM_SNM_pvta/WM_SNM6.txt'); 

  WM1 = f1(:,3)*1e3; % in mV
  WM2 = f2(:,3)*1e3; % in mV
  WM3 = f3(:,3)*1e3; % in mV
  WM4 = f4(:,3)*1e3; % in mV
  WM5 = f5(:,3)*1e3; % in mV
  WM6 = f6(:,3)*1e3; % in mV
 
  plot(x,WM1);
  grid on;
  xlabel('VT Shift','fontsize',12);
  ylabel('Tcrit (ps)','fontsize',12);
  title('Write Margin vs VT Shift\nPU Left (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM_pvta/IMG/SRAM_PUL_SNM.eps');
  close(gcf);
  
  plot(x,WM2);
  grid on;
  xlabel('VT Shift','fontsize',12);
  ylabel('Tcrit (ps)','fontsize',12);
  title('Write Margin vs VT Shift\nPD Left (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM_pvta/IMG/SRAM_PDL_SNM.eps');
  close(gcf);

  plot(x,WM3);
  grid on;
  xlabel('VT Shift','fontsize',12);
  ylabel('Tcrit (ps)','fontsize',12);
  title('Write Margin vs VT Shift\nPG Left (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM_pvta/IMG/SRAM_PGL_SNM.eps');
  close(gcf);

  plot(x,WM4);
  grid on;
  xlabel('VT Shift','fontsize',12);
  ylabel('Tcrit (ps)','fontsize',12);
  title('Write Margin vs VT Shift\nPU Right (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM_pvta/IMG/SRAM_PUR_SNM.eps');
  close(gcf);

  plot(x,WM5);
  grid on;
  xlabel('VT Shift','fontsize',12);
  ylabel('Tcrit (ps)','fontsize',12);
  title('Write Margin vs VT Shift\nPD Right (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM_pvta/IMG/SRAM_PDR_SNM.eps');
  close(gcf);

  plot(x,WM6);
  grid on;
  xlabel('VT Shift','fontsize',12);
  ylabel('Tcrit (ps)','fontsize',12);
  title('Write Margin vs VT Shift\nPG Right (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM_pvta/IMG/SRAM_PGR_SNM.eps');
  close(gcf);

end

