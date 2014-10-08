%##############################################################
%#      MATLAB code to plot Tcrit distribution		      #
%##############################################################

f5_0=[];
f5_1=[];
f6_0=[];
f6_1=[];
f7_0=[];
f7_1=[];
f8_0=[];
f8_1=[];
f9_0=[];
f9_1=[];
f10_0=[];
f10_1=[];


%%%%%%%%% For Write '1' into the cell that holds '0' %%%%%%%%%%%
  %load data%
  f5_0 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr0_vdd_0.5.txt');
  f5_1 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr1_vdd_0.5.txt');
  f6_0 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr0_vdd_0.6.txt');
  f6_1 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr1_vdd_0.6.txt') ;
  f7_0 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr0_vdd_0.7.txt');
  f7_1 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr1_vdd_0.7.txt');
  f8_0 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr0_vdd_0.8.txt');
  f8_1 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr1_vdd_0.8.txt') ;
  f9_0 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr0_vdd_0.9.txt');
  f9_1 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr1_vdd_0.9.txt');
  f10_0 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr0_vdd_1.txt');
  f10_1 = load('SRAM_Tcrit_vs_vdd/Tcrit_wr1_vdd_1.txt');
  Tcrit5_0 = f5_0(:,1)*1e12;
  Tcrit5_1 = f5_1(:,1)*1e12;
  Tcrit6_0 = f6_0(:,1)*1e12;
  Tcrit6_1 = f6_1(:,1)*1e12;
  Tcrit7_0 = f7_0(:,1)*1e12;
  Tcrit7_1 = f7_1(:,1)*1e12;
  Tcrit8_0 = f8_0(:,1)*1e12;
  Tcrit8_1 = f8_1(:,1)*1e12;
  Tcrit9_0 = f9_0(:,1)*1e12;
  Tcrit9_1 = f9_1(:,1)*1e12;
  Tcrit10_0 = f10_0(:,1)*1e12;
  Tcrit10_1 = f10_1(:,1)*1e12;

  Tcrit5= max(Tcrit5_0, Tcrit5_1);
  Tcrit6= max(Tcrit6_0, Tcrit6_1);
  Tcrit7= max(Tcrit7_0, Tcrit7_1);
  Tcrit8= max(Tcrit8_0, Tcrit8_1);
  Tcrit9= max(Tcrit9_0, Tcrit9_1);
  Tcrit10= max(Tcrit10_0, Tcrit10_1);
  
average=[];
WC=[];
average(1)=mean(Tcrit5);
average(2)=mean(Tcrit6);
average(3)=mean(Tcrit7);
average(4)=mean(Tcrit8);
average(5)=mean(Tcrit9);
average(6)=mean(Tcrit10);
WC(1)=min(Tcrit5);
WC(2)=min(Tcrit6);
WC(3)=min(Tcrit7);
WC(4)=min(Tcrit8);
WC(5)=min(Tcrit9);
WC(6)=min(Tcrit10);
x=[0.5 0.6 0.7 0.8 0.9 1];

  bar(x,average);
  grid on;
  xlabel('VDD','fontsize',12)
  ylabel('Write Tcrit','fontsize',12);
  title('Average Write Tcrit (ps) vs VDD','fontsize',16);

  %save and close%
  print(gcf, '-depsc', 'SRAM_Tcrit_vs_vdd/IMG/SRAM_Tcrit_Write_ave.eps');
  close(gcf);

 bar(x,WC);
  grid on;
  xlabel('VDD','fontsize',12)
  ylabel('Write Tcrit','fontsize',12);
  title('Worst Case Write Tcrit (ps) vs VDD','fontsize',16);

  %save and close%
  print(gcf, '-depsc', 'SRAM_Tcrit_vs_vdd/IMG/SRAM_Tcrit_Write_WC.eps');
  close(gcf);

