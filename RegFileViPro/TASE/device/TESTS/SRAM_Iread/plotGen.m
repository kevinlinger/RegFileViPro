%##############################################################
%#      MATLAB code to plot SRAM cell Read Current	      #
%##############################################################

%load data%
f=load('SRAM_Iread/monteCarlo/mcdata');

%get Ipeak and Iavg%
%#Iavg=f(:,1);
Ipeak=f(:,2)*1E6;

%get mean and std of Iavg and Ipeak%
%#[m1,s1]=normfit(Iavg);
[m2,s2]=normfit(Ipeak);

%plot data and format figure%
%#[n1,d1]=hist(Iavg);
[n2,d2]=hist(Ipeak);
%#plot(1E6*d1,n1,':',1E6*d2,n2,':X');
bar(d2,n2);
grid on;
strx=sprintf('Peak Read Drive current(uA) mean=%f; sigma=%f;)',1*m2,1*s2); 
xlabel(strx,'fontsize',12);
ylabel('Occurance','fontsize',12);
legend('peak',1,'Location','NorthEastOutside');

%save and close%
print(gcf, '-depsc', 'SRAM_Iread/IMG/SRAM_Iread.eps');
close(gcf);


