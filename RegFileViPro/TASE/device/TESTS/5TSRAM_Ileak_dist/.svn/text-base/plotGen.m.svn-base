%##################################################################
%#   MATLAB code to plot SRAM Cell Leakage Current distribution	  #
%#                                                                #
%# Created by jw4pg@virginia.edu                                  #
%##################################################################


%load data%
f=load('5TSRAM_Ileak_dist/OUT/monteCarlo/mcdata');

%get Ileak, unit pA%
Ilk=(f(:,1)+f(:,2)+f(:,3))*1e12;


%get mean and std of the lognormal distribution%
p = lognfit(Ilk);
m = exp(p(1)+p(2)^2/2);
s2 = exp(2*p(1)+p(2)^2)*(exp(p(2)^2)-1);
s = sqrt(s2);

%plot data and format figure%
ndata = length(Ilk);
nbins = ceil(sqrt(ndata));
[n,d]=hist(Ilk,nbins);
bar(d,n,1);
grid on;
xl=sprintf('Cell Leakage Current (pA)\nFitted as a log-normal with mean=%0.3g; sigma=%0.3g',m,s);
xlabel(xl,'fontsize',12);
ylabel('Occurance','fontsize',12);
title('Ileak Distribution at nominal VDD','fontsize',16);

%save and close%
print(gcf, '-depsc', '5TSRAM_Ileak_dist/IMG/5TSRAM_Ileak_dist.eps');
close(gcf);


