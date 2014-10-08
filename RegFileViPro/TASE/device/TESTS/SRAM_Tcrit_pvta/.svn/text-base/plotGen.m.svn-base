%##############################################################
%#      MATLAB code to plot Tcrit distribution		      #
%##############################################################

f0 = [];
f1 = [];

%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
if exist('SRAM_Tcrit_mc/Tcrit_wr0.txt', 'file')

  %load data%
  f0=load('SRAM_Tcrit_mc/Tcrit_wr0.txt')
  Tcrit0 = f0(:,1)*1e12;

  %get mean and std
  [m,s]=normfit(Tcrit0);

  %plot data and format figure%
  [n,d]=hist(Tcrit0);
  bar(d,n);
  grid on;
  strx=sprintf('Tcrit (cell-0) (ps)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Tcrit (cell-0)','fontsize',16);

  %save and close%
  print(gcf, '-depsc', 'SRAM_Tcrit_mc/IMG/SRAM_Tcrit0_mc.eps');
  close(gcf);
end

%%%%%%%%% For Write '0' into the cell that holds '1' %%%%%%%%%%%
if exist('SRAM_Tcrit_mc/Tcrit_wr1.txt', 'file')

  %load data%
  f1=load('SRAM_Tcrit_mc/Tcrit_wr1.txt')
  Tcrit1 = f1(:,1)*1e12;

  %get mean and std
  [m,s]=normfit(Tcrit1);

  %plot data and format figure%
  [n,d]=hist(Tcrit1);
  bar(d,n);
  grid on;
  strx=sprintf('Tcrit (cell-1) (ps)\n(mean=%f; sigma=%f)',m,s);
  xlabel(strx,'fontsize',12);
  ylabel('Occurance','fontsize',12);
  title('Tcrit (cell-1)','fontsize',16);

  %save and close%
  print(gcf, '-depsc', 'SRAM_Tcrit_mc/IMG/SRAM_Tcrit1_mc.eps');
  close(gcf);
end

%%%%%%%%%% get the max(Tcrit0, Tcrit1) as the final write Tcrit %%%%%%%%%%%%
if (size(f0,1)>0 & size(f1,1)>0)
  Tcrit_Read = min(Tcrit0, Tcrit1);
  Tcrit_Write = max(Tcrit0, Tcrit1);
  [mr,sr]=normfit(Tcrit_Read);
  [mw,sw]=normfit(Tcrit_Write);

  %plot data and format figure%
  [nw,dw]=hist(Tcrit_Write);
  bar(dw,nw);
  grid on;
  strx=sprintf('Write Tcrit (ps)\n(mean=%f; sigma=%f)',mw,sw);
  xlabel(strx,'fontsize',12)
  ylabel('Occurance','fontsize',12);
  title('Write Tcrit','fontsize',16);

  %save and close%
  print(gcf, '-depsc', 'SRAM_Tcrit_mc/IMG/SRAM_Tcrit_Write.eps');
  close(gcf);
end
