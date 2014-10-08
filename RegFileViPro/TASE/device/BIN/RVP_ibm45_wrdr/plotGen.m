
  %load data%
  f0=load('RVP_CD_sweep/dataw16.txt')
  delay0 = f0(:,5);
  energy0= f0(:,9);

  f1=load('RVP_CD_sweep/dataw32.txt')
  delay1 = f1(:,5);
  energy1= f1(:,9);

  f2=load('RVP_CD_sweep/dataw64.txt')
  delay2 = f2(:,5);
  energy2= f2(:,9);

  f3=load('RVP_CD_sweep/dataw128.txt')
  delay3 = f3(:,5);
  energy3= f3(:,9);

  f4=load('RVP_CD_sweep/dataw256.txt')
  delay4 = f4(:,5);
  energy4= f4(:,9);

  f5=load('RVP_CD_sweep/dataw512.txt')
  delay5 = f5(:,5);
  energy5= f5(:,9);


plot(energy0,delay0,'-s',energy1,delay1,'-d',energy2,delay2,'-*',energy3,delay3,'->',energy4,delay4,'-^','linewidth',3,'MarkerSize',8);
  grid on;
  legend('16 Rows','32 Rows','64 Rows','128 Rows','256 Rows','512 Rows');  


  xlabel('Energy','fontsize',16);
  ylabel('Delay','fontsize',16);
  title('E-D for Varying Write Driver Widths','fontsize',18);

  %save and close%
  print(gcf, '-depsc', 'WrDrvr.eps');



