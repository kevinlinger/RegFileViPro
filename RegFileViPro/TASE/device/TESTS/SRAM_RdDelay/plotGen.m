%##################################################################
%#   MATLAB code to plot SRAM Cell Read delay		  	  #
%#                                                                #
%##################################################################

%load data%
f=load('SRAM_RdDelay/OUT/DAT/monteCarlo/mcdata');

%get Iread, unit ps%
Tread=f(:,1)*1e12;

%plot data and format figure%
ndata = length(Tread);
nbins = ceil(sqrt(ndata));

% replace failed iterations with max pulse width
x = find(Tread == -1.11111e+48);
for i=1:length(x)
  Tread(x(i)) = max(Tread)+max(Tread)/nbins;
end

[n,d]=hist(Tread,nbins);
bar(d,n,1);
grid on;
txt=sprintf('Bitline discharge delay (ps)');
xlabel(txt,'fontsize',12);
ylabel('Occurance','fontsize',12);
title(' BL discharge delay dist. for 128 rows','fontsize',16);

%save and close%
print(gcf, '-depsc', 'SRAM_RdDelay/IMG/SRAM_RdDelay.eps');
close(gcf);
