%####################################################
%#      MATLAB code to plot NMOS IDVD curves        #
%####################################################

%load data%
load ExtVDSAT/DAT/dc_dc.dat;
load ExtVDSAT/DAT/dc_N1_NX_d.dat;

W=<wpg>;
Leff=<lpg>;

% Inputs... % *********NOTE vthe0 is calculated from another test*******%
vgs = <pvdd>;
vth0 = 0.3114;   
vth0 = 0.32165;
vth0 = 0.3237;
vth0 = 0.325029;
vgt = vgs - vth0;

% Get vsat (velocity saturation voltage)
% by determining the point of intersection
% between linear and saturation curves
slope1 = (dc_N1_NX_d(2) - dc_N1_NX_d(1)) / (dc_dc(2) - dc_dc(1));
slope2 = (dc_N1_NX_d(end) - dc_N1_NX_d(end-2)) / (dc_dc(end) - dc_dc(end-2));
a = dc_N1_NX_d(end) - dc_dc(end) * slope2;
vdsat = a / (slope1-slope2);

% Get Isat  [I = Isat + slope2*VDS]
Imax = dc_N1_NX_d(end);
Isat = Imax - slope2 * dc_dc(end);

% Get Lambda
Lambda = slope2 / Isat;

% Get Kth
Kth =  Isat / ( ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2)))) );

%Kth & Lambda could be tuned to best 
%fit the simulation results
%Kth = 0.95 * Kth;
%Lambda = Lambda * 1.5;

% Plot ID-VD curve using the simplified 
% model parameters extracted  
for s = 1:numel(dc_dc)
   if dc_dc(s) < vdsat
      Id(s,1) = Kth * ((W/Leff) * (vgt*dc_dc(s) - (0.5*power(dc_dc(s),2)))) * (1 + Lambda * dc_dc(s));
   else 
      Id(s,1) = Kth * ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2)))) * (1 + (Lambda * (dc_dc(s))));
   end
end

%plot data and format figure
plot(dc_dc,dc_N1_NX_d,'LineWidth',2);
hold on;
plot(dc_dc,Id,'--k','LineWidth',2);
grid on;
% legend(VGS,'Location','NorthWest');
xlabel('VDS (V)','fontsize',12);
ylabel('Drain Current (uA/um)','fontsize',12);
title('NMOS Drain Current vs. VDS','fontsize',16);

%print Ion & Ig%
st=sprintf('Kth=%g \n Lambda=%g \n vdsat=%g',Kth,Lambda,vdsat);
ht=text(vdsat,Id(end)/2,st,'fontSize',14);

%save the parameters into a file
fout = fopen('ExtVDSAT/data.txt', 'w');
fprintf(fout, '%e\t%e\t%e\n', [Kth Lambda vdsat]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'ExtVDSAT/IMG/ExtVDSAT.eps');
close(gcf);

