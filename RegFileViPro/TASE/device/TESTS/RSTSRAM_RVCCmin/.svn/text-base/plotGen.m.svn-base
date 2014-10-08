%##############################################################
%#      MATLAB code to plot SRAM VCCmin for Read              #
%##############################################################

f0 = [];
f1 = [];

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('RSTSRAM_RVCCmin/OUT/DAT0','dir')   
  %load data%
  f0=load('RSTSRAM_RVCCmin/OUT/DAT0/monteCarlo/mcdata');
  %get WriteMargin%
  VCCmin0=f0(:,1)*1e3; % in mV
  %replace '-1.11111e+36' (nil) value to zero%
  id=find(VCCmin0<0);
  VCCmin0(id)=0;
  %save write margin data in a file%
  fout1 = fopen('RSTSRAM_RVCCmin/OUT/rvcc_d0.out','w');
  fprintf(fout1, '%f\n', f0(:,1));
  fclose(fout1);
  %get mean and std
  [m,s]=normfit(VCCmin0);
  %plot data and format figure%
  [n,d]=hist(VCCmin0);
  bar(d,n);
  grid on;
  strx=sprintf('VCCmin (cell-0) (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('VCCmin (cell-0) ','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'RSTSRAM_RVCCmin/IMG/RSTSRAM_RVCCmin0.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('RSTSRAM_RVCCmin/OUT/DAT1','dir')   
  %load data%
  f1=load('RSTSRAM_RVCCmin/OUT/DAT1/monteCarlo/mcdata');
  %get WriteMargin%
  VCCmin1=f1(:,1)*1e3; % in mV
  %replace '-1.11111e+36' (nil) value to zero%
  id=find(VCCmin1<0);
  VCCmin1(id)=0;
  %save write margin data in a file%
  fout1 = fopen('RSTSRAM_RVCCmin/OUT/rvcc_d1.out','w');
  fprintf(fout1, '%f\n', f1(:,1));
  fclose(fout1);
  %get mean and std
  [m,s]=normfit(VCCmin1);
  %plot data and format figure%
  [n,d]=hist(VCCmin1);
  bar(d,n);
  grid on;
  strx=sprintf('VCCmin (cell-1) (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('VCCmin (cell-1) ','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'RSTSRAM_RVCCmin/IMG/RSTSRAM_RVCCmin1.eps');
  close(gcf);
end

%%%%%%%%%% get the min(VCCmin0,VCCmin1) as the final writeMargin %%%%%%%%%%%%
if (size(f0,1)>0 & size(f1,1)>0)
  VCCmin=max(VCCmin0,VCCmin1);
  [m,s]=normfit(VCCmin);
  %plot data and format figure%
  [n,d]=hist(VCCmin);
  bar(d,n);
  grid on;
  strx=sprintf('VCCmin (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('VCCmin ','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'RSTSRAM_RVCCmin/IMG/RSTSRAM_RVCCmin.eps');
  close(gcf);
end

