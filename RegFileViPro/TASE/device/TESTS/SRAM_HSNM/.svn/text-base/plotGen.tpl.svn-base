%##############################################################
%#      MATLAB code to plot SRAM cell Hold SNM distribution   #
%##############################################################

%load data%
f=load('sram_HSNM/monteCarlo/mcdata');

%get VDD value%
VDD=<pvdd>;
temp=<temp>;

%get SNMh, SNMl, and SNM%
SNMh=f(:,1)*1e3;
SNMl=f(:,2)*1e3;
SNM=f(:,3)*1e3;
SNMmax=max(f(:,3)*1e3);
SNMmin=min(f(:,3)*1e3);

%get mean and std of SNM
[m1,s1]=normfit(SNMh);
[m2,s2]=normfit(SNMl);
[m,s]=normfit(SNM);
minx=SNMmin;
maxx=SNMmax;

%plot data and format figure%
[n1,d1]=hist(SNMh);
[n2,d2]=hist(SNMl);
nbars=(maxx-minx)/50;
xx=minx:nbars:maxx;
[n,d]=hist(SNM,xx);

bar(d1,n1,1,'b');
grid on;
hold on;
bar(d2,n2,1,'r');
bar(d,n,1,'g');

%stairs(d1,n1,'-bo','lineWidth',2);
%hold on;
%stairs(d2,n2,'-g^','lineWidth',2);
%hold on;
%stairs(d,n,'-rx','lineWidth',2);
%grid on;

strx=sprintf('Hold SNM (mV) when VDD=%4.1fV\n(mean=%6.1f; sigma=%6.1f, wc=%6.1f )',VDD,m,s,SNMmax);
xlabel(strx,'fontsize',12);
ylabel('cases','fontsize',12);
legend('SNMH','SNML','SNM');
title('Hold SNMH/SNML/SNM Distribution','fontsize',16);

%save the mean and sigma into a file
fout = fopen('sram_HSNM/data.txt', 'w');
fprintf(fout, '%f\t%f\t%f\t%f\t%f\t%f\n', [m1 s1 m2 s2 m s]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'sram_HSNM/IMG/sram_HSNM_h_l.eps');
close(gcf);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bar(d,n,1,'b');
grid on;
strx=sprintf('Hold SNM (mV) when VDD=%4.1fV and Temp=%3.1fC\n(mean=%6.1fmV, sigma=%6.1fmV, wc=%6.1fmV )',VDD,temp,m,s,SNMmax);
xlabel(strx,'fontsize',12);
ylabel('cases','fontsize',12);
legend('HSNM');
title('Hold SNM Distribution','fontsize',16);
print(gcf, '-depsc', 'sram_HSNM/IMG/sram_HSNM.eps');
close(gcf);