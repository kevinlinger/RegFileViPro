%##############################################################
%#      MATLAB code to plot SRAM Write Margin by Ncurve       #
%##############################################################

f0 = [];
f1 = [];

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('SRAM_WM_Ncurve/OUT/DAT0','dir')  
  %load data%
  f0=load('SRAM_WM_Ncurve/OUT/DAT0/monteCarlo/mcdata');
  %save write margin data in a file%
  fout1 = fopen('SRAM_WM_Ncurve/OUT/ncurve_d0.out', 'w');
  fprintf(fout1, '%f\t%f\t%f\t%f\t%e\t%f\t%e\n', [f0(:,1:7)]');
  fclose(fout1);
  %save vth data in a file%
  fout2 = fopen('SRAM_WM_Ncurve/OUT/ncurve_d0.vt', 'w');
  fprintf(fout2, '%f\t%f\t%f\t%f\t%f\t%f\n', [f0(:,8:13)]');
  fclose(fout2);
  %get WriteMargin WTV%
  WTV0=f0(:,6)*1e3; % in mV
  WTI0=f0(:,7)*1e6; % in uA
  %plot data and format figure%
  [n,d]=hist(WTV0);
  bar(d,n);
  grid on;
  %get mean and std
  [m,s]=normfit(WTV0);
  strx=sprintf('Ncurve WTV (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-0) (WTV criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_Ncurve/IMG/SRAM_WM0_WTV.eps');
  close(gcf);
  %plot data and format figure%
  [n,d]=hist(WTI0);
  bar(d,n);
  grid on;
  %get mean and std
  [m,s]=normfit(WTI0);
  strx=sprintf('Ncurve WTI (uA)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-0) (WTI criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_Ncurve/IMG/SRAM_WM0_WTI.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('SRAM_WM_Ncurve/OUT/DAT1','dir')  
  %load data%
  f1=load('SRAM_WM_Ncurve/OUT/DAT1/monteCarlo/mcdata');
  %save write margin data in a file%
  fout1 = fopen('SRAM_WM_Ncurve/OUT/ncurve_d1.out', 'w');
  fprintf(fout1, '%f\t%f\t%f\t%f\t%e\t%f\t%e\n', [f1(:,1:7)]');
  fclose(fout1);
  %save vth data in a file%
  fout2 = fopen('SRAM_WM_Ncurve/OUT/ncurve_d1.vt', 'w');
  fprintf(fout2, '%f\t%f\t%f\t%f\t%f\t%f\n', [f1(:,8:13)]');
  fclose(fout2);
  %get WriteMargin WTV%
  WTV1=f1(:,6)*1e3; % in mV
  WTI1=f1(:,7)*1e6; % in uA
  %plot data and format figure%
  [n,d]=hist(WTV1);
  bar(d,n);
  grid on;
  %get mean and std
  [m,s]=normfit(WTV1);
  strx=sprintf('Ncurve WTV (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-1) (WTV criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_Ncurve/IMG/SRAM_WM1_WTV.eps');
  close(gcf);
  %plot data and format figure%
  [n,d]=hist(WTI1);
  bar(d,n);
  grid on;
  %get mean and std
  [m,s]=normfit(WTI1);
  strx=sprintf('Ncurve WTI (uA)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-1) (WTI criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_Ncurve/IMG/SRAM_WM1_WTI.eps');
  close(gcf);
end

%%%%%%%%%% get the min(WM0,WM1) as the final writeMargin %%%%%%%%%%%%
if (size(f0,1)>0 & size(f1,1)>0)
  %%%%%%%%%%%%%%%%%%%%%%%% WTV %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  WTV=max(WTV0,WTV1);
  [m,s]=normfit(WTV);
  %plot data and format figure%
  [n,d]=hist(WTV);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin by WTV (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Margin (WTV criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_Ncurve/IMG/SRAM_WM_WTV.eps');
  close(gcf);
  %%%%%%%%%%%%%%%%%%%%%%%% WTI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  WTI=max(WTI0,WTI1);
  [m,s]=normfit(WTI);
  %plot data and format figure%
  [n,d]=hist(WTI);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin by WTI (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Margin (WTI criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_Ncurve/IMG/SRAM_WM_WTI.eps');
  close(gcf);
end


