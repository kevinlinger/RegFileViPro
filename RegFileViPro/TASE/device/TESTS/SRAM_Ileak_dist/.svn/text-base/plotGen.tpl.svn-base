%##################################################################
%#   MATLAB code to plot SRAM Cell Leakage Current distribution	  #
%#                                                                #
%# Created by jw4pg@virginia.edu                                  #
%##################################################################


%load data%
f=load('sram_Ileak_dist/OUT/monteCarlo/mcdata');
VDD=<pvdd>;
VBL=<bitline>;
VWL=<wlv>;
nd=<ldef>;
node=nd*1e9;
temp=<temp>;


%get Ileak, unit pA%
Ilk=(f(:,1)+f(:,2)+f(:,3))*1e12;
Ilkwc=max(f(:,4))*1e12;

%get mean and std of the lognormal distribution%
p = lognfit(Ilk);
m = exp(p(1)+p(2)^2/2);
s2 = exp(2*p(1)+p(2)^2)*(exp(p(2)^2)-1);
s = sqrt(s2);

%plot data and format figure%
ndata = length(Ilk);
nbins = ceil(sqrt(ndata));
minx=0;
minxx=5;
maxx=Ilk+(4*s);

nbars=(maxx-minx)/50;
%xx=minx:5:maxx;
xx=minxx:nbars:maxx;
%[n,d]=hist(Ilk,nbins);
[n,d]=hist(Ilk,xx);
bar(d,n,1,'b');
grid on;
xl=sprintf('Cell Leakage Current (pA)\nFitted as a log-normal with mean=%0.3g; sigma=%0.3g',m,s);
xlabel(xl,'fontsize',12);
ylabel('Occurance','fontsize',12);
title('Ileak Distribution at nominal VDD','fontsize',16);

fout = fopen('sram_Ileak_dist/data.txt', 'w');
%fprintf(fout,'%f\t%f\t%f\t%f\n',[VDD m s Ilkwc]);
fprintf(fout,'%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',[m s Ilkwc node VDD VBL VWL temp ]);
  fclose(fout);

%save and close%
print(gcf, '-depsc', 'sram_Ileak_dist/IMG/sram_Ileak_dist.eps');
print(gcf, '-dtiff','-r300','sram_Ileak_dist/IMG/sram_Ileak_dist.tif')
close(gcf);


