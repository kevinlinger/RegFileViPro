%####################################################
%#      MATLAB code to generate NMOS IDVG plot      #
%####################################################

%load data%
load HandOnParam_N/DAT/dc_dc.dat;
load HandOnParam_N/DAT/dc_N1_NX_d.dat;
load HandOnParam_N/DAT/dc_N2_NX_d.dat;

W = <wpg>;
Leff = <lpg>;

% Calculate Vth0 using the maximum transconductance method


% Get gm1 
gm(1,1) = 0;
for s = 2:numel(dc_N1_NX_d)
  gm(s,1) = (dc_N1_NX_d(s) - dc_N1_NX_d(s-1)) / (dc_dc(s) - dc_dc(s-1));
end
gmax = max(gm(:,1));
gmax = find(gm==gmax);
v1 = dc_dc(gmax);
v2 = dc_dc(gmax+1);
i1 = dc_N1_NX_d(gmax);
i2 = dc_N1_NX_d(gmax+1);
slope = (i2-i1)/(v2-v1);

% Get vth0
vthe0 = v1 - (i1/slope);

% Calculate S (sub-threshold parameter)
id = find(dc_dc<vthe0);
Ith = dc_N1_NX_d(id(end));
id = find(dc_N2_NX_d<0.1*Ith);
vx = dc_dc(id(end));
S = vthe0 - vx;


% Get gamma by calculating the
% threshold of N2 (VB = 0.1*VDD)
% and comparing it to vth0
gm2(1,1) = 0;
for s = 2:numel(dc_N2_NX_d)
  gm2(s,1) = (dc_N2_NX_d(s) - dc_N2_NX_d(s-1)) / (dc_dc(s) - dc_dc(s-1));
end
gmax2 = max(gm2(:,1));
gmax2 = find(gm2==gmax2);
v1 = dc_dc(gmax2);
v2 = dc_dc(gmax2+1);
i1 = dc_N2_NX_d(gmax2);
i2 = dc_N2_NX_d(gmax2+1);
slope = (i2-i1)/(v2-v1);
vthe2 = v1 - (i1/slope);
vsb = -0.1*<pvdd>;
gamma = (vthe2 - vthe0)/(sqrt(0.6 + vsb) - sqrt(0.6));


%plot data and format figure%
plot(dc_dc,dc_N1_NX_d,'b','LineWidth',2);
hold on;
plot(dc_dc,dc_N2_NX_d,'g','LineWidth',2);
hold on;
plot(dc_dc,gm,'--b','LineWidth',2);
hold on;
plot(dc_dc,gm2,'--g','LineWidth',2);
grid on;
ylabel('Drain Current (A)','fontsize',12);
xlabel('VGS (V)','fontsize',12);

 
%st = sprintf('VBS= 0','VBS=%g','Gm1(VBS=0)', 'Gm2(VBS=%g)',vb,vb);
legend('VBS= 0','VBS=0.1*VDD','Gm1(VBS=0)', 'Gm2(VBS=0.1*VDD)');
title('NMOS Drain Current vs. VGS','fontsize',16);

st = sprintf('vthe0 = %g \n S = %g \n gamma = %g',vthe0,S,gamma);
ht = text(max(dc_dc(:,1))/1.5, max(dc_N1_NX_d(:,1))/3, st, 'fontsize',12);

%save the parameters into a file
fout = fopen('HandOnParam_N/data.txt', 'w');
fprintf(fout, '%e\t%e\t%e\n', [vthe0 S gamma]'); 
fclose(fout);


%save and close%
print(gcf, '-depsc', 'HandOnParam_N/IMG/HandOnParam_N.eps');
close(gcf);







