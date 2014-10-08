%##############################################################
%#      MATLAB code to plot SRAM Write Margin (WL criterion)   #
%##############################################################

f0 = [];
f1 = [];

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('5TSRAM_WM_WL/OUT/DAT0','dir')   
  %load data%
  f0=load('5TSRAM_WM_WL/OUT/DAT0/monteCarlo/mcdata');
  %get WriteMargin%
  WM0=f0(:,1)*1e3; % in mV
  QBmQ=f0(:,2);
  %replace nil value '-1.11111e+36' to 0%
  id=find(WM0<0);
  if size(id,1)>0 
    WM0(id)=0;
  end
  %find iterations having Q/QB flipped/converged initially but no crossing point   
  %If they exist, set their margin value to VDD
  if size(id,1)>0 
    for i=1:1:size(id,1)
       if QBmQ(id(i))<0
           WM0(id(i))=<pvdd>*1e3;
       end
    end
  end
  %save write margin data in a file%
  fout1 = fopen('5TSRAM_WM_WL/OUT/wl_d0.out','w');
  fprintf(fout1, '%f\n', WM0);
  fclose(fout1);
  %get mean and std
  [m,s]=normfit(WM0);
  %plot data and format figure%
  [n,d]=hist(WM0);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-0) by WL (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-0) (WL criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', '5TSRAM_WM_WL/IMG/SRAM_WM0_WL.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('5TSRAM_WM_WL/OUT/DAT1','dir')   
  %load data%
  f1=load('5TSRAM_WM_WL/OUT/DAT1/monteCarlo/mcdata');
  %get WriteMargin%
  WM1=f1(:,1)*1e3; % in mV
  QBmQ=f1(:,3);
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
  %save write margin data in a file%
  fout1 = fopen('5TSRAM_WM_WL/OUT/wl_d1.out','w');
  fprintf(fout1, '%f\n', WM1);
  fclose(fout1);
  %get mean and std
  [m,s]=normfit(WM1);
  %plot data and format figure%
  [n,d]=hist(WM1);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-1) by WL (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-1) (WL criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', '5TSRAM_WM_WL/IMG/SRAM_WM1_WL.eps');
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
  strx=sprintf('WriteMargin by WL (mV)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Margin (WL criterion)','fontsize',16);
  %save and close%
  print(gcf, '-depsc', '5TSRAM_WM_WL/IMG/5TSRAM_WM_WL.eps');
  close(gcf);
end

