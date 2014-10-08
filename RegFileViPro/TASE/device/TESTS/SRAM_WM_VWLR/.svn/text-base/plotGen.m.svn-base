%##############################################################
%#      MATLAB code to plot SRAM Write Margin (WL criterion)   #
%##############################################################

f0 = [];
f1 = [];

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('SRAM_WM_VWLR/OUT/DAT0','dir')   
  %load data%
  f0=load('SRAM_WM_VWLR/OUT/vwl_d0.out');
  %get WriteMargin%
  VOL0=f0(:,1);
  VM0=f0(:,2);
  WM0=f0(:,3)*1e3; % in mV
  %get mean and std
  [m,s]=normfit(WM0);
  %plot data and format figure%
  [n,d]=hist(WM0);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-0) by VWLR (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-0) (VWLR criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_VWLR/IMG/SRAM_WM0_VWLR.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('SRAM_WM_VWLR/OUT/DAT1','dir')   
  %load data%
  f1=load('SRAM_WM_VWLR/OUT/vwl_d1.out');
  %get WriteMargin%
  VOL1=f1(:,1);
  VM1=f1(:,2);
  WM1=f1(:,3)*1e3; % in mV
  %get mean and std
  [m,s]=normfit(WM1);
  %plot data and format figure%
  [n,d]=hist(WM1);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-1) by VWLR (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-1) (VWLR criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_VWLR/IMG/SRAM_WM1_VWLR.eps');
  close(gcf);
end

%%%%%%%%%% get the min(WM0,WM1) as the final writeMargin %%%%%%%%%%%%
if (size(f0,1)>0 & size(f1,1)>0)
  WM=min(WM0,WM1);
  [m,s]=normfit(WM);
  %plot data and format figure%
  [n,d]=hist(WM);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin by VWLR (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Margin (VWLR criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_VWLR/IMG/SRAM_WM_VWLR.eps');
  close(gcf);
end

