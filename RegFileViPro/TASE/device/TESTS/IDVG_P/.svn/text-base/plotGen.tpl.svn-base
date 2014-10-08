%####################################################
%#      MATLAB code to generate PMOS IDVG plot      #
%####################################################

%load data%
load IDVG_P/DAT/dc_dc.dat;
load IDVG_P/DAT/dc_P1_PX_d.dat;
load IDVG_P/DAT/dc_P2_PX_d.dat;

%put data into I and convert to milliamps%
I=[dc_P1_PX_d dc_P2_PX_d];
I=I*10^3;

%plot data and format figure%
plot(abs(dc_dc),abs(I),'LineWidth',2);
grid on;
xlabel('\midVDS\mid (V)','fontsize',12);
ylabel('\midDrain Current\mid (mA)','fontsize',12);
legend('|VDS|=<pvdd>','|VDS|=0.05');
title('PMOS Drain Current vs. VGS','fontsize',16);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                             %%
%%  Estimate Vtsat/Vtlin                       %%
%%                                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W = <wdef>;
% effective length
Leff = <ldef>;

% estimated Id when Vg=Vtsat
I_Vtsat = 70e-9*W/Leff;
id = find(abs(dc_P1_PX_d)<I_Vtsat);
Vtsat = abs((dc_dc(id(end))+dc_dc(id(end)+1)))/2;
line([Vtsat Vtsat],[0 max(abs(I(:,1)))],'lineStyle','--');
st = sprintf('|Vtsat|=%g',Vtsat);
ht = text(Vtsat, max(abs(I(:,1)))/2, st, 'fontsize',12);

% estimated Id when Vg=Vtlin
I_Vtlin = 70e-9*W/Leff;
id = find(abs(dc_P2_PX_d)<I_Vtlin);
Vtlin = abs((dc_dc(id(end))+dc_dc(id(end)+1)))/2;
line([Vtlin Vtlin],[0 max(abs(I(:,1)))],'lineStyle','--');
st = sprintf('|Vtlin|=%g',Vtsat);
ht = text(Vtlin, max(abs(I(:,1)))/3, st, 'fontsize',12);

%save the Vtsat/Vtlin values into a file
fout = fopen('IDVG_P/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [Vtsat Vtlin]'); 
fclose(fout);


%save and close%
print(gcf, '-depsc', 'IDVG_P/IMG/IDVG_P.eps');
close(gcf);
