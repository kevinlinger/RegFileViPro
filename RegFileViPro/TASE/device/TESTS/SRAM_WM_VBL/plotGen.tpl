%##############################################################
%#      MATLAB code to plot SRAM Write margin (BL criterion)   #
%##############################################################

f0 = [];
f1 = [];

fout = fopen('SRAM_WM_VBL/data.txt', 'w');

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('SRAM_WM_VBL/OUT/DAT0','dir')   
  %load data%
  f0=load('SRAM_WM_VBL/OUT/DAT0/monteCarlo/mcdata');
  QBmQ=f0(:,3);
  WM0=f0(:,1)*1e3;  %in mV
  %replace nil value '-1.11111e+36' to 0%
  id=find(WM0<0);
  if size(id,1)>0 
    WM0(id)=0;
  end
  %find iterations having Q/QB flipped/converged but no crossing point   
  %If they exist, set their margin value to VDD
  if size(id,1)>0 
    for i=1:1:size(id,1)
       if QBmQ(id(i))<0
           WM0(id(i))=<pvdd>*1e3;
       end
    end
  end
  VT=f0(:,4:9);
  %save write margin data in a file%
  fout1 = fopen('SRAM_WM_VBL/OUT/vbl_d0.out', 'w');
  fprintf(fout1, '%f\n', WM0);
  fclose(fout1);
  %save vth data in a file%
  fout2 = fopen('SRAM_WM_VBL/OUT/vbl_d0.vt', 'w');
  fprintf(fout2, '%f\t%f\t%f\t%f\t%f\t%f\n', VT');
  fclose(fout2);
  %get mean and std
  [m,s]=normfit(WM0);
  %save mean and std values into a file%
  fprintf(fout, '%f\t%f\t',[m s]');
  %plot data and format figure%
  [n,d]=hist(WM0);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-0) by VBL (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-0) (VBL criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_VBL/IMG/SRAM_WM0_VBL.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('SRAM_WM_VBL/OUT/DAT1','dir')   
  %load data%
  f1=load('SRAM_WM_VBL/OUT/DAT1/monteCarlo/mcdata');
  QBmQ=f1(:,3);
  WM1=f1(:,1)*1e3; %in mV
  %replace nil value '-1.11111e+36' to 0%
  id=find(WM1<0);
  if size(id,1)>0 
    WM1(id)=0;
  end
  %find iterations having Q/QB flipped/converged but no crossing point   
  %If they exist, set their margin value to VDD
  if size(id,1)>0 
    for i=1:1:size(id,1)
       if QBmQ(id(i))<0
           WM1(id(i))=<pvdd>*1e3;
       end
    end
  end
  VT=f1(:,4:9);
  %save write margin data in a file%
  fout1 = fopen('SRAM_WM_VBL/OUT/vbl_d1.out', 'w');
  fprintf(fout1, '%f\n', WM1);
  fclose(fout1);
  %save vth data in a file%
  fout2 = fopen('SRAM_WM_VBL/OUT/vbl_d1.vt', 'w');
  fprintf(fout2, '%f\t%f\t%f\t%f\t%f\t%f\n', VT');
  fclose(fout2);
  %get mean and std
  [m,s]=normfit(WM1);
  %save mean and std values into a file%
  fprintf(fout, '%f\t%f\t',[m s]');
  %plot data and format figure%
  [n,d]=hist(WM1);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-1) by VBL (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-1) (VBL criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_VBL/IMG/SRAM_WM1_VBL.eps');
  close(gcf);
end

%%%%%%%%%% get the min(WM0,WM1) as the final writeMargin %%%%%%%%%%%%
if (size(f0,1)>0 & size(f1,1)>0)
  WM=min(WM0,WM1);
  [m,s]=normfit(WM);
  %save mean and std values into a file%
  fprintf(fout, '%f\t%f\t',[m s]');
  %plot data and format figure%
  [n,d]=hist(WM);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin by VBL (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Margin (VBL criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_VBL/IMG/SRAM_WM_VBL.eps');
  close(gcf);
end

fclose(fout);

