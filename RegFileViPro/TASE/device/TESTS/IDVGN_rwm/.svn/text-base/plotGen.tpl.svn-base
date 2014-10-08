%####################################################
%#      MATLAB code to generate NMOS IDVG plot      #
%####################################################

%load data%
load IDVGN_rwm/DAT/dc_dc.dat;
load IDVGN_rwm/DAT/dc_N1_NX_d.dat;
load IDVGN_rwm/DAT/dc_N2_NX_d.dat;

%put data into I and convert to milliamps%
I=[dc_N1_NX_d dc_N2_NX_d];
I=I*10^3;

VDD=<pvdd>;
VBL=<bitline>;
VWL=<wlv>;
VSS=<pvss>;
nd=<ldef>;
node=nd*1e9;
temp=<temp>;
pwell=<pvbn>;


%plot data and format figure%
plot(dc_dc,I,'LineWidth',2);
grid on;
ylabel('Drain Current (mA)','fontsize',12);
xlabel('VGS (V)','fontsize',12);
legend('VDS=<pvdd>','VDS=0.05');
title('NMOS Drain Current vs. VGS','fontsize',16);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                             %%
%%  Estimate Vtsat & Vtlin                     %%
%%                                             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
W = <wdef>;
% effective length
Leff = <ldef>;

% estimated Id when Vg=Vtsat
I_vtsat = 300e-9*W/Leff;
id = find(dc_N1_NX_d<I_vtsat);
Vtsat = (dc_dc(id(end))+dc_dc(id(end)+1))/2;
line([Vtsat Vtsat],[0 max(I(:,1))],'lineStyle','--');
st = sprintf('Vt_{sat}=%g',Vtsat);
ht = text(Vtsat, max(I(:,1))/2, st, 'fontsize',12);

% estimated Id when Vg=Vtlin
I_vtlin = 300e-9*W/Leff;
id = find(dc_N2_NX_d<I_vtlin);
Vtlin = (dc_dc(id(end))+dc_dc(id(end)+1))/2;
line([Vtlin Vtlin],[0 max(I(:,1))],'lineStyle','--');
st = sprintf('Vt_{lin}=%g',Vtlin);
ht = text(Vtlin, max(I(:,1))/3, st, 'fontsize',12);

%save the Vtsat/Vtlin values into a file
Wnm=W*1e9;
Lnm=Leff*1e9;
fout = fopen('IDVGN_rwm/data.txt', 'w');
fprintf(fout, '%e\t%e\t%f\t%f\t%f\t%f\t%f\t%f\n', [Vtsat Vtlin VDD node pwell temp Wnm Lnm]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'IDVGN_rwm/IMG/IDVGN_rwm.eps');
close(gcf);
