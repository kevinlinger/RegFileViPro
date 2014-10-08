% Include path to vmin function
path(path,'./sram_Pfailure_RSNM');

% load SNM data
snm0=load('sram_Pfailure_RSNM/OUT/RSNM0/monteCarlo/mcdata');
snm1=load('sram_Pfailure_RSNM/OUT/RSNM1/monteCarlo/mcdata');
snm2=load('sram_Pfailure_RSNM/OUT/RSNM2/monteCarlo/mcdata');
snm3=load('sram_Pfailure_RSNM/OUT/RSNM3/monteCarlo/mcdata');

% Get means and sigmas for each snm-low
[mu0 sig0] = normfit(snm0(:,1));
[mu1 sig1] = normfit(snm1(:,1));
[mu2 sig2] = normfit(snm2(:,1));
[mu3 sig3] = normfit(snm3(:,1));

mu = [mu0 mu1 mu2 mu3];
sig = [sig0 sig1 sig2 sig3];

v0 = <pvdd>/2;
vdd = 1e3*[v0 v0+<VDDstep> v0+2*<VDDstep> v0+3*<VDDstep>];
v0 = v0*1e3;

% Fit mean and sigma to get a, b and c.
p = polyfit(vdd,mu,2);
a=p(1);
b=p(2);

q = polyfit(vdd,sig,1);
c=q(1);

% Threshold NM = 0
s = 0;

% Get mu and sig as functions of vdd
v = 1e3*<pvdd>*[0.3:0.1:1];
mu1 = mu0 + a*(v.^2-v0^2) + b*(v-v0);
sig1 = sig0 + c*(v-v0);

% Plot Prob(SNM less than 0) vs. VDD
efc = erfc(-(s-mu1)./(sig1*sqrt(2)));
P = efc - 0.25*efc.^2;

subplot(3,1,1);
semilogy(v,P,'-s','LineWidth',2);
grid on;
xlabel('V_D_D (mV)','fontsize',12);
ylabel('P(RSNM < 0)','fontsize',12);
title('Cell failure probability','fontsize',16);

% Plot DRV vs. std norm quantiles
Q = [3 3.5 4 4.5 5 5.5 6];
F1 = normcdf(Q,0,1);

Vmin = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F1);

subplot(3,1,2);
plot(Q,Vmin,'-s','LineWidth',2);
grid on;
xlabel('Standard normal quantiles','fontsize',12);
ylabel('Vmin (mV)','fontsize',12);
title('Predicted Read Vmin','fontsize',16);

% Plot DRV vs. memory size for fixed yield (array failure prob.)
mem_size = [1e4 1e5 1e6 1e7 1e8 1e9];
Paf = 1 - <yield>;
F2 = Paf.^(1./mem_size);

Vmin = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F2);

subplot(3,1,3);
semilogx(mem_size,Vmin,'-s','LineWidth',2);
grid on;
xlabel('Memory capacity (bits)','fontsize',12);
ylabel('Read Vmin (mV)','fontsize',12);
title('Read Vmin for yield=<yield>','fontsize',16);

% save and close
print(gcf, '-depsc', 'sram_Pfailure_RSNM/IMG/sram_Pfailure_RSNM.eps');
close(gcf);


