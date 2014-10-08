%##############################################################
%#      MATLAB code to plot SRAM Write Margin (WL criterion)   #
%##############################################################

f0 = [];
f1 = [];
VDD=<pvdd>;
VWL=<wlv>;
VSS=<pvss>;
VBL=<bitline>;
LBL=<lbl>;
nd=<ldef>;
node=nd*1e9;
temp=<temp>;
pwell=<pvbn>;
nwell=<pvbp>;
VDDa=<pvdda>;

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('SRAM_WM_WL_rwm/OUT/DAT0','dir')   
  %load data%
  f0=load('SRAM_WM_WL_rwm/OUT/DAT0/monteCarlo/mcdata');
  %get WriteMargin%
  WM0=f0(:,1)*1e3; % in mV
  WM0min=min(f0(:,1))*1e3;
  QBmQ=f0(:,2);
  %replace nil value '-1.11111e+36' to 0%
  id=find(WM0==-1.11111e+36);
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
  fout1 = fopen('SRAM_WM_WL_rwm/OUT/wl_d0.out','w');
  fprintf(fout1, '%f\n', WM0);
  fclose(fout1);
  %get mean and std
  [m0,s0]=normfit(WM0);
  %plot data and format figure%
  [n,d]=hist(WM0);
  bar(d,n);
  grid on;
  strx=sprintf('WriteMargin (cell-0) by WL (mV)\n(mean=%f; sigma=%f)',m0,s0);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Write Margin (cell-0) (WL criterion)','fontsize',16);

 %fout0 = fopen('SRAM_WM_WL_rwm/data.txt','w');
 % fprintf(fout0, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', [m0 s0 wmwcf VDD VWL VBL node temp]);
 % fclose (fout0);

  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_WL_rwm/IMG/SRAM_WM0_WL.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('SRAM_WM_WL_rwm/OUT/DAT1','dir')   
  %load data%
  f1=load('SRAM_WM_WL_rwm/OUT/DAT1/monteCarlo/mcdata');
  %get WriteMargin%
  WM1=f1(:,1)*1e3; % in mV
  QmQB=f1(:,2);
  WM1min=min(f0(:,1))*1e3;
  %replace nil value '-1.11111e+36' to 0%
  id=find(WM1==-1.11111e+36);
  if size(id,1)>0 
    WM1(id)=0;
  end
  %find iterations having Q/QB flipped/converged but no crossing point   
  %If they exist, set their margin value to VDD
  if size(id,1)>0 
    for i=1:1:size(id,1)
       if QmQB(id(i))<0
           WM1(id(i))=<pvdd>*1e3;
       end
    end
  end
  %save write margin data in a file%
  fout1 = fopen('SRAM_WM_WL_rwm/OUT/wl_d1.out','w');
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
  print(gcf, '-depsc', 'SRAM_WM_WL_rwm/IMG/SRAM_WM1_WL.eps');
  close(gcf);
end

%%%%%%%%%% get the min(WM0,WM1) as the final writeMargin %%%%%%%%%%%%
if (size(f0,1)>0 & size(f1,1)>0)
  WM=min(WM0,WM1);
  WMwc=min(WM0min,WM1min);
  [m,s]=normfit(WM);
minx=m-(4*s);
maxx=m+(4*s);
  %plot data and format figure%
nbars=(maxx-minx)/50;
xx=minx:nbars:maxx;
  [n,d]=hist(WM,xx);

  bar(d,n,1,'b');
  grid on;
  strx=sprintf('WriteMargin by WL (mV)\n(mean=%6.1f; sigma=%6.1f)',m,s);
  xlabel(strx,'fontsize',12)
  ylabel('cases','fontsize',12);
  legend('WM');
  title('Write Margin (WL criterion)','fontsize',16);

d1=load('SRAM_WM_WL_rwm/OUT/wl_d1.out');
d0=load('SRAM_WM_WL_rwm/OUT/wl_d0.out');
wmd0=(d0(:,1));
wmd1=(d1(:,1));
wmf=min(wmd0,wmd1);
wmd0wc=min(d0(:,1));
wmd1wc=min(d1(:,1));
wmwcf=min(wmd0wc,wmd1wc);
 
  fout = fopen('SRAM_WM_WL_rwm/msdata.txt','w');
  fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', [m s wmwcf VDD VWL VBL node temp m0 s0 LBL VSS pwell nwell VDDa]);
  fclose (fout);

%  fout = fopen('SRAM_WM_WL_rwm/data.txt','w');
%  fprintf(fout2, '%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', [VDD VWL VBL node m s wmwcf m0 s0 LBL]);    
%  fclose (fout2);
  
  %save and close%
  print(gcf, '-depsc', 'SRAM_WM_WL_rwm/IMG/SRAM_WM_WL_rwm.eps');
  print(gcf, '-dtiff','-r300','SRAM_WM_WL_rwm/IMG/SRAM_WM_WL_rwm.tif');
  close(gcf);
end

