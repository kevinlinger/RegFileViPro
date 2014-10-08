%####################################################
%#      MATLAB code to plot NMOS IDVD curves        #
%####################################################

%load data%
load ExtVDSAT/DAT/dc_dc.dat;
load ExtVDSAT/DAT/dc_N1_NX_d.dat;

%put all data into matrix I and convert to uA/um%
%I=dc_N1_NX_d;

%simulate Ion with width 0.6um%
W=<wdef>;
Leff=<leff>;

%I=I*1e6/(W*1e6);  %I in the unit of uA/um

%Get the slope
slope1 = (dc_N1_NX_d(2) - dc_N1_NX_d(1)) / (dc_dc(2) - dc_dc(1));
slope2 = (dc_N1_NX_d(end) - dc_N1_NX_d(end-2)) / (dc_dc(end) - dc_dc(end-2));
%c = dc_dc(end) - (dc_N1_NX_d(end) / slope2);
%k = -slope2 * c;
k = dc_N1_NX_d(end) - dc_dc(end) * slope2;
xi = (k / (slope1-slope2))*1.0;


% Input
h_vth = 0.2585;
h_vgs = <pvdd>;

xi = 0.256;

vgt = h_vgs - h_vth;


vdsat = xi;


% Get Kth
vmid = xi / 2;
id = find(dc_dc<vmid);
v1=dc_dc(id(end));
v2=dc_dc(id(end)+1);
i1=dc_N1_NX_d(id(end));
i2=dc_N1_NX_d(id(end)+1);

v1=dc_dc(1);
v2=dc_dc(2);
i1=dc_N1_NX_d(1);
i2=dc_N1_NX_d(2);

slope = (i2-i1)/(v2-v1);
vdsi = dc_dc(2);
%Kth  = slope1 / ( (W/Leff) * ((vgt - vdsi) + (2 * Lambda * vgt * vdsi)) );

Kth  = slope1 / ( (W/Leff) * ((vgt - vdsi) ) );


% Get Lambda
id=find(dc_dc<xi);
%Isat = dc_N1_NX_d(id(end));
Isat = Kth * ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2))));
Lambda = slope2 / Isat;



for s = 1:numel(dc_dc)
   if dc_dc(s) < xi
      curveX(s,1) = Kth * ((W/Leff) * (vgt*dc_dc(s) - (0.5*power(dc_dc(s),2)))) * (1 + Lambda * dc_dc(s)) ;
      %curveX(s,1) = slope1 * dc_dc(s) ;
   else 
      %curveX(s,1) = Kth * ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2)))) * (1 + (Lambda * (dc_dc(s))))  ;
      curveX(s,1) = slope2 * dc_dc(s) + k;
   end
end


I=[dc_N1_NX_d];  

%plot data and format figure
plot(dc_dc,I,'LineWidth',2);
hold on;
plot(dc_dc,curveX,'--k','LineWidth',2);

grid on;
% legend(VGS,'Location','NorthWest');
xlabel('VDS (V)','fontsize',12);
ylabel('Drain Current (uA/um)','fontsize',12);
title('NMOS Drain Current vs. VDS','fontsize',16);


%print Ion & Ig%
s=sprintf('Kth=%g \n Lambda=%g',Kth,Lambda);

%line([xi xi],[0 max(I(:,1))],'lineStyle','--');
%s=sprintf('vdsat=%g',xi);
ht=text(xi,I(end)/2,s,'fontSize',14);

%save and close%
print(gcf, '-depsc', 'ExtVDSAT/IMG/ExtVDSAT.eps');
close(gcf);

