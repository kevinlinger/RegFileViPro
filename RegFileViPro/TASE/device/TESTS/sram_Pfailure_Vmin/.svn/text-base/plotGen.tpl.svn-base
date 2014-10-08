% Include path to vmin function
path(path,'./SRAM_Pfailure_Vmin');

% load data
hsnm0=load('SRAM_Pfailure_Vmin/OUT/HSNM0/monteCarlo/mcdata');
hsnm1=load('SRAM_Pfailure_Vmin/OUT/HSNM1/monteCarlo/mcdata');
hsnm2=load('SRAM_Pfailure_Vmin/OUT/HSNM2/monteCarlo/mcdata');
hsnm3=load('SRAM_Pfailure_Vmin/OUT/HSNM3/monteCarlo/mcdata');

rsnm0=load('SRAM_Pfailure_Vmin/OUT/RSNM0/monteCarlo/mcdata');
rsnm1=load('SRAM_Pfailure_Vmin/OUT/RSNM1/monteCarlo/mcdata');
rsnm2=load('SRAM_Pfailure_Vmin/OUT/RSNM2/monteCarlo/mcdata');
rsnm3=load('SRAM_Pfailure_Vmin/OUT/RSNM3/monteCarlo/mcdata');

wnm0=load('SRAM_Pfailure_Vmin/OUT/WNM0/monteCarlo/mcdata');
wnm1=load('SRAM_Pfailure_Vmin/OUT/WNM1/monteCarlo/mcdata');
wnm2=load('SRAM_Pfailure_Vmin/OUT/WNM2/monteCarlo/mcdata');
wnm3=load('SRAM_Pfailure_Vmin/OUT/WNM3/monteCarlo/mcdata');

% Get means and sigmas for each snm-low
[hmu0 hsig0] = normfit(hsnm0(:,1));
[hmu1 hsig1] = normfit(hsnm1(:,1));
[hmu2 hsig2] = normfit(hsnm2(:,1));
[hmu3 hsig3] = normfit(hsnm3(:,1));

hmu = [hmu0 hmu1 hmu2 hmu3];
hsig = [hsig0 hsig1 hsig2 hsig3];

% Ref. VDD for model - convert to mV for consistency
v0 = 0.3*<pvdd>;
vdd = 1e3*[v0 v0+<VDDstep> v0+2*<VDDstep> v0+3*<VDDstep>];
v0 = 1e3*v0;

% Fit mean and sigma to get a, b and c.
p = polyfit(vdd,hmu,2);
a=p(1);
b=p(2);

q = polyfit(vdd,hsig,1);
c=q(1);

% Threshold NM = 0
s = 0;

% Get mu and sig as functions of vdd
v = 1e3*<pvdd>*[0.3:0.1:1];
hmu1 = hmu0 + a*(v.^2-v0^2) + b*(v-v0);
hsig1 = hsig0 + c*(v-v0);

% Plot Prob(SNM less than 0) vs. VDD
efc = erfc(-(s-hmu1)./(hsig1*sqrt(2)));
P_h = efc - 0.25*efc.^2; % For Hold plot 1 vs. v (vdd)

% Plot vs. std norm quantiles
Q = [3 3.5 4 4.5 5 5.5 6];
F1 = normcdf(Q,0,1);
Vmin1_h = vmin_cdfinv(hmu0,hsig0,v0,a,b,c,s,F1); % For Hold plot 2 vs. Quartiles

% Plot vs. memory size for fixed yield (array failure prob.)
mem_size = [1e4 1e5 1e6 1e7 1e8 1e9];
Paf = 1 - <yield>;
F2 = Paf.^(1./mem_size);

Vmin2_h = vmin_cdfinv(hmu0,hsig0,v0,a,b,c,s,F2); % For Hold plot 3 vs. Mem-size

[rmu0 rsig0] = normfit(rsnm0(:,1));
[rmu1 rsig1] = normfit(rsnm1(:,1));
[rmu2 rsig2] = normfit(rsnm2(:,1));
[rmu3 rsig3] = normfit(rsnm3(:,1));

rmu = [rmu0 rmu1 rmu2 rmu3];
rsig = [rsig0 rsig1 rsig2 rsig3];

v0 = <pvdd>/2;
vdd = 1e3*[v0 v0+<VDDstep> v0+2*<VDDstep> v0+3*<VDDstep>];
v0 = v0*1e3;

% Fit mean and sigma to get a, b and c.
p = polyfit(vdd,rmu,2);
a=p(1);
b=p(2);

q = polyfit(vdd,rsig,1);
c=q(1);

% Threshold NM = 0
s = 0;

% Get mu and sig as functions of vdd
v = 1e3*<pvdd>*[0.3:0.1:1];
rmu1 = rmu0 + a*(v.^2-v0^2) + b*(v-v0);
rsig1 = rsig0 + c*(v-v0);

% Plot Prob(SNM less than 0) vs. VDD
efc = erfc(-(s-rmu1)./(rsig1*sqrt(2)));
P_r = efc - 0.25*efc.^2; % For Read plot 1 vs. v

Vmin1_r = vmin_cdfinv(rmu0,rsig0,v0,a,b,c,s,F1); % For read plot 2 vs. quartiles
Vmin2_r = vmin_cdfinv(rmu0,rsig0,v0,a,b,c,s,F2); % For read plot 3 vs. mem-size

[wmu0 wsig0] = normfit(wnm0(:,1));
[wmu1 wsig1] = normfit(wnm1(:,1));
[wmu2 wsig2] = normfit(wnm2(:,1));
[wmu3 wsig3] = normfit(wnm3(:,1));

wmu = 1e3*[wmu0 wmu1 wmu2 wmu3];
wsig = 1e3*[wsig0 wsig1 wsig2 wsig3];
wmu0 = 1e3*wmu0;
wsig0 = 1e3*wsig0;

v0 = <pvdd>/2;
vdd = 1e3*[v0 v0+<VDDstep> v0+2*<VDDstep> v0+3*<VDDstep>];
v0 = v0*1e3;

% Fit mean and sigma to get a, b and c.
p = polyfit(vdd,wmu,2);
a=p(1);
b=p(2);

q = polyfit(vdd,wsig,1);
c=q(1);

% Threshold NM = 0
s = 0;

% Get mu and sig as functions of vdd
v = 1e3*<pvdd>*[0.3:0.1:1];
wmu1 = wmu0 + a*(v.^2-v0^2) + b*(v-v0);
wsig1 = wsig0 + c*(v-v0);

% Plot Prob(SNM less than 0) vs. VDD
efc = erfc(-(s-wmu1)./(wsig1*sqrt(2)));
P_w = efc - 0.25*efc.^2;  % For write plot 1 vs. v

Vmin1_w = vmin_cdfinv(wmu0,wsig0,v0,a,b,c,s,F1); % For write plot 2 vs. quartiles
Vmin2_w = vmin_cdfinv(wmu0,wsig0,v0,a,b,c,s,F2); % For write plot 3 vs. mem-size

subplot(3,1,1);
semilogy(v,P_h,'-^',v,P_r,'-o',v,P_w,'-s','LineWidth',2);
grid on;
xlabel('V_D_D (mV)','fontsize',12);
ylabel('P(NM < 0)','fontsize',12);
axis([300 1000 10e-18 1]);
title('Cell failure probability','fontsize',16);

subplot(3,1,2);
plot(Q,Vmin1_h,'-^',Q,Vmin1_r,'-o',Q,Vmin1_w,'-s','LineWidth',2);
grid on;
xlabel('Standard normal quantiles','fontsize',12);
ylabel('Vmin (mV)','fontsize',12);
title('Predicted Vmin','fontsize',16);

subplot(3,1,3);
semilogx(mem_size,Vmin2_h,'-^',mem_size,Vmin2_r,'-o',mem_size,Vmin2_w,'-s','LineWidth',2);
grid on;
xlabel('Memory capacity (bits)','fontsize',12);
ylabel('Vmin (mV)','fontsize',12);
title('Vmin for yield=<yield>','fontsize',16);

% save and close
print(gcf, '-depsc', 'SRAM_Pfailure_Vmin/IMG/SRAM_Pfailure_Vmin.eps');
close(gcf);
