%##############################################################
%#      MATLAB code to plot SRAM Write SNM distribution       #
%##############################################################


f0 = [];
f1 = [];

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('SRAM_WM_SNM/OUT/DAT0','dir')   
  %load data%
  f0=load('SRAM_WM_SNM/OUT/DAT0/monteCarlo/mcdata');
  VM0 = f0(:,1);
  VOH0= f0(:,2);
  WM0 = f0(:,3)*1e3; % in mV
  VT  = f0(:,4:9);
  %replace nil value '-1.11111e+36' to 0%
  id=find(WM0<0);
  if size(id,1)>0 
    WM0(id)=0;
  end
  %save write margin data in a file%
  fout1 = fopen('SRAM_WM_SNM/OUT/snm_d0.out', 'w');
  fprintf(fout1, '%f\t%f\t%f\n', [f0(:,1:3)*1e3]');
  fclose(fout1);
  %save vth data in a file%
  fout2 = fopen('SRAM_WM_SNM/OUT/snm_d0.vt', 'w');
  fprintf(fout2, '%f\t%f\t%f\t%f\t%f\t%f\n', VT');
  fclose(fout2);
  %get mean and std
  [m,s]=normfit(WM0);
  %plot data and format figure%
  [n,d]=hist(WM0);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-0) by SNM (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-0) (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM/IMG/SRAM_WM0_SNM.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('SRAM_WM_SNM/OUT/DAT1','dir')
  %load data%
  f1=load('SRAM_WM_SNM/OUT/DAT1/monteCarlo/mcdata');
  VM1 = f1(:,1);
  VOH1= f1(:,2);
  WM1 = f1(:,3)*1e3;
  VT  = f1(:,4:9);
  %replace nil value '-1.11111e+36' to 0%
  id=find(WM1<0);
  if size(id,1)>0 
    WM1(id)=0;
  end
  %save write margin data in a file%
  fout1 = fopen('SRAM_WM_SNM/OUT/snm_d1.out', 'w');
  fprintf(fout1, '%f\t%f\t%f\n', [f1(:,1:3)*1e3]');
  fclose(fout1);
  %save vth data in a file%
  fout2 = fopen('SRAM_WM_SNM/OUT/snm_d1.vt', 'w');
  fprintf(fout2, '%f\t%f\t%f\t%f\t%f\t%f\n', VT');
  fclose(fout2);
  %get mean and std
  [m,s]=normfit(WM1);
  %plot data and format figure%
  [n,d]=hist(WM1);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-1) by SNM (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-1) (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM/IMG/SRAM_WM1_SNM.eps');
  close(gcf);
end

%%%%%%%%%% get the min(WM0,WM1) as the final witeMargin %%%%%%%%%%%%
if (size(f0,1)>0 & size(f1,1)>0)
  WM=min(WM0,WM1);
  [m,s]=normfit(WM);
  %plot data and format figure%
  [n,d]=hist(WM);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin by SNM (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Margin (SNM criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_SNM/IMG/SRAM_WM_SNM.eps');
  close(gcf);
end







