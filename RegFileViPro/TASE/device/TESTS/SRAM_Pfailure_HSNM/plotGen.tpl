% Include path to vmin function
path(path,'./SRAM_Pfailure_HSNM');

% load SNM data
snm0=load('SRAM_Pfailure_HSNM/OUT/SNM0/monteCarlo/mcdata');
snm1=load('SRAM_Pfailure_HSNM/OUT/SNM1/monteCarlo/mcdata');
snm2=load('SRAM_Pfailure_HSNM/OUT/SNM2/monteCarlo/mcdata');
snm3=load('SRAM_Pfailure_HSNM/OUT/SNM3/monteCarlo/mcdata');

% Get means and sigmas for each snm-low
[mu0 sig0] = normfit(snm0(:,1));
[mu1 sig1] = normfit(snm1(:,1));
[mu2 sig2] = normfit(snm2(:,1));
[mu3 sig3] = normfit(snm3(:,1));

mu = [mu0 mu1 mu2 mu3];
sig = [sig0 sig1 sig2 sig3];

% Ref. VDD for model - convert to mV for consistency
v0 = 0.3*<pvdd>;
vdd = 1e3*[v0 v0+<VDDstep> v0+2*<VDDstep> v0+3*<VDDstep>];
v0 = 1e3*v0;

% Fit mean and sigma to get a, b and c.
p = polyfit(vdd,mu,2);
a=p(1);
b=p(2);

q = polyfit(vdd,sig,1);
c=q(1);

% Threshold NM = 0
s = 0;

% Get mu and sig as functions of vdd
v = 1e3*<pvdd>*[0.3:0.1:0.6];
mu1 = mu0 + a*(v.^2-v0^2) + b*(v-v0);
sig1 = sig0 + c*(v-v0);

% Plot Prob(SNM less than 0) vs. VDD
efc = erfc(-(s-mu1)./(sig1*sqrt(2)));
P = efc - 0.25*efc.^2;

subplot(3,1,1);
semilogy(v,P,'-s','LineWidth',2);
grid on;
xlabel('V_D_D (mV)','fontsize',12);
ylabel('P(HSNM < 0)','fontsize',12);
title('Cell Failure probability','fontsize',16);

% Plot DRV vs. std norm quantiles
Q = [3 3.5 4 4.5 5 5.5 6];
F1 = normcdf(Q,0,1);

Vmin = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F1);

subplot(3,1,2);
plot(Q,Vmin,'-s','LineWidth',2);
grid on;
xlabel('Standard normal quantiles','fontsize',12);
ylabel('DRV (mV)','fontsize',12);
title('Predicted Data Retention Voltage','fontsize',16);

% Plot DRV vs. memory size for fixed yield (array failure prob.)
mem_size = [1e4 1e5 1e6 1e7 1e8 1e9];
Paf = 1 - <yield>;
F2 = Paf.^(1./mem_size);

Vmin = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F2);

subplot(3,1,3);
semilogx(mem_size,Vmin,'-s','LineWidth',2);
grid on;
xlabel('Memory capacity (bits)','fontsize',12);
ylabel('DRV (mV)','fontsize',12);
title('DRV for yield=<yield>','fontsize',16);

% save and close
print(gcf, '-depsc', 'SRAM_Pfailure_HSNM/IMG/SRAM_Pfailure_HSNM.eps');
close(gcf);


% Plot DRV vs. yield for fixed memory size
%yield = 1e-2*[93.3 99.38 99.977 99.99966 99.9999981];
%mem_size = <mem_size>;
%Paf = 1 - yield;

%F3 = 1 - Paf.^(1/mem_size);

%Vmin = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F3);
%Y = [3 4 5 6 7];

%plot(Y,Vmin,'-s');

% 3D plot
%mem_size = [1e4 1e5 1e6 1e7 1e8 1e9];
%yield = 1e-2*[93.3 99.38 99.977 99.99966 99.9999981];
%Paf = 1 - yield;

%[M P] = meshgrid(mem_size,Paf);

%F4 = 1 - P.^(1./M);

%Vmin = vmin_cdfinv(mu0,sig0,v0,a,b,c,s,F4);

%surf(M,P,Vmin);
