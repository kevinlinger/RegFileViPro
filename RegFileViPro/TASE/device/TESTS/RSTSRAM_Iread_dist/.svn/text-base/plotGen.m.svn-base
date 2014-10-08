%##################################################################
%#   MATLAB code to plot SRAM Cell Read Current distribution	  #
%#                                                                #
%# Created by jw4pg@virginia.edu                                  #
%##################################################################


%load data%
f=load('PDSRAM_Iread_dist/OUT/monteCarlo/mcdata');

%get Iread, unit uA%
Iread=f(:,1)*1e6;

%get Vreadbump%
Vbump=f(:,3);

%Fit Iread as the normal distribution%
[m,s] = normfit(Iread);

%plot data and format figure%
ndata = length(Iread);
nbins = ceil(sqrt(ndata));
[n,d]=hist(Iread,nbins);
bar(d,n,1);
grid on;
txt=sprintf('Cell Read Current (uA)\nFitted as a normal w/ mean=%0.3g; sigma=%0.3g',m,s);
xlabel(txt,'fontsize',12);
ylabel('Occurance','fontsize',12);
title('Iread Distribution at nominal VDD','fontsize',16);

%save and close%
print(gcf, '-depsc', 'PDSRAM_Iread_dist/IMG/PDSRAM_Iread_dist.eps');
close(gcf);



%Plot Vbump %
ndata = length(Vbump);
nbins = ceil(sqrt(ndata));
[n,d]=hist(Vbump,nbins);
bar(d,n,1);
grid on;
[m,s]=normfit(Vbump);
txt=sprintf('Cell Read Voltage Bump (V)\nFitted as a normal w/ mean=%0.3g; sigma=%0.3g',m,s);
xlabel(txt,'fontsize',12);
ylabel('Occurance','fontsize',12);
title('Read Voltage Bump Distribution at nominal VDD','fontsize',16);

%save and close%
print(gcf, '-depsc', 'PDSRAM_Iread_dist/IMG/SRAM_Vread_dist.eps');
close(gcf);
