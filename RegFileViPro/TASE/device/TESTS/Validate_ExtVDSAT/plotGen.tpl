%####################################################
%#      MATLAB code to plot NMOS IDVD curves        #
%####################################################

%load data%
load Validate_ExtVDSAT/DAT/dc_dc.dat;
load Validate_ExtVDSAT/DAT/dc_N1_NX_d.dat;
load Validate_ExtVDSAT/DAT/dc_N2_NX_d.dat;
load Validate_ExtVDSAT/DAT/dc_N3_NX_d.dat;
load Validate_ExtVDSAT/DAT/dc_N4_NX_d.dat;

W=<wdef>;
Leff=<leff>;

% Input Parameters

%22nm
Kth = 0.00010555;
vdsat = 0.151158;
Lambda = 3.29;
vthe = 0.268;

%90nm
Kth = 0.00041097;
vdsat = 0.25668;
Lambda = 0.20493;
vthe = 0.325029;

%65nm
Kth = 0.000370082;
vdsat = 0.232817;
Lambda = 0.283263;
vthe = 0.3237;

%45nm
Kth = 0.0003047;
vdsat = 0.21019;
Lambda = 0.46077;
vthe = 0.32165;

%32nm
Kth = 0.000245199;
vdsat = 0.190936;
Lambda = 0.761046;
vthe = 0.3114;













vgs1 = <pvdd>;
vgs2 = 0.75 * <pvdd>;
vgs3 = 0.5 * <pvdd>;
vgs4 = 0.25 * <pvdd>;
	
% create curve1
vgt = vgs1 - vthe;
for s = 1:numel(dc_dc)
   if (dc_dc(s) < vdsat) && (dc_dc(s) < vgt)
      curveW1(s,1) = Kth * ((W/Leff) * (vgt*dc_dc(s) - (0.5*power(dc_dc(s),2)))) * (1 + (Lambda * dc_dc(s)) ) ;
   
   elseif (vdsat < vgt)
      curveW1(s,1) = Kth * ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2)))) * (1 + (Lambda * (dc_dc(s))))  ;
   
   else
      curveW1(s,1) = Kth * (W/ (2 * Leff)) * power(vgt,2) * (1 + (Lambda * dc_dc(s)) );
   
   end
end


% create curve2
vgt = vgs2 - vthe;
for s = 1:numel(dc_dc)
   if (dc_dc(s) < vdsat) && (dc_dc(s) < vgt)
      curveW2(s,1) = Kth * ((W/Leff) * (vgt*dc_dc(s) - (0.5*power(dc_dc(s),2)))) * (1 + (Lambda * dc_dc(s)) ) ;
   
   elseif (vdsat < vgt)
      curveW2(s,1) = Kth * ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2)))) * (1 + (Lambda * (dc_dc(s))))  ;
   
   else
      curveW2(s,1) = Kth * (W/ (2 * Leff)) * power(vgt,2) * (1 + (Lambda * dc_dc(s)) );
   
   end
end

% create curve3
vgt = vgs3 - vthe;
for s = 1:numel(dc_dc)
   if (dc_dc(s) < vdsat) && (dc_dc(s) < vgt)
      curveW3(s,1) = Kth * ((W/Leff) * (vgt*dc_dc(s) - (0.5*power(dc_dc(s),2)))) * (1 + (Lambda * dc_dc(s)) ) ;
   
   elseif (vdsat < vgt)
      curveW3(s,1) = Kth * ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2)))) * (1 + (Lambda * (dc_dc(s))))  ;
   
   else
      curveW3(s,1) = Kth * (W/ (2 * Leff)) * power(vgt,2) * (1 + (Lambda * dc_dc(s)) );
   
   end
end

% create curve4
vgt = vgs4 - vthe;
for s = 1:numel(dc_dc)
   if (dc_dc(s) < vdsat) && (dc_dc(s) < vgt)
      curveW4(s,1) = Kth * ((W/Leff) * (vgt*dc_dc(s) - (0.5*power(dc_dc(s),2)))) * (1 + (Lambda * dc_dc(s)) ) ;
   
   elseif (vdsat < vgt)
      curveW4(s,1) = Kth * ((W/Leff) * (vgt*vdsat - (0.5*power(vdsat,2)))) * (1 + (Lambda * (dc_dc(s))))  ;
   
   else
      curveW4(s,1) = Kth * (W/ (2 * Leff)) * power(vgt,2) * (1 + (Lambda * dc_dc(s)) );
   
   end
end


Error1(1,1) = 0;
for s = 2:numel(dc_N1_NX_d)
  Error1(s,1) = 100 * ((dc_N1_NX_d(s) - curveW1(s,1))/dc_N1_NX_d(s)); 
end

Error2(1,1) = 0;
for s = 2:numel(dc_N2_NX_d)
  Error2(s,1) = 100 * ((dc_N2_NX_d(s) - curveW2(s,1))/dc_N2_NX_d(s)); 
end

Error3(1,1) = 0;
for s = 2:numel(dc_N3_NX_d)
  Error3(s,1) = 100 * ((dc_N3_NX_d(s) - curveW3(s,1))/dc_N3_NX_d(s)); 
end

Error4(1,1) = 0;
for s = 2:numel(dc_N4_NX_d)
  Error4(s,1) = 100 * ((dc_N4_NX_d(s) - curveW4(s,1))/dc_N4_NX_d(s)); 
end

I = [dc_N1_NX_d dc_N2_NX_d dc_N3_NX_d dc_N4_NX_d];
curve = [curveW1 curveW2 curveW3 curveW4];
Error = [Error1 Error2 Error3]

VGS1=strcat('VGS = ',num2str(vgs1));
VGS2=strcat('VGS = ',num2str(vgs2));
VGS3=strcat('VGS = ',num2str(vgs3));
VGS4=strcat('VGS = ',num2str(vgs4));

%plot data and format figure
subplot(2,1,1);
plot(dc_dc,I,'LineWidth',2);
hold on;
plot(dc_dc,curve,'--k','LineWidth',2);

grid on;
%legend(VGS1,'Location','southEast');
legend(VGS1,VGS2,VGS3,VGS4,'Location','northwest');
xlabel('VDS (V)','fontsize',12);
ylabel('Drain Current (uA/um)','fontsize',12);
title('NMOS Drain Current vs. VDS','fontsize',12);

subplot(2,1,2);
plot(dc_dc,Error1,'b*','LineWidth',1);
hold on;
plot(dc_dc,Error2,'gv','LineWidth',1);
hold on;
plot(dc_dc,Error3,'r^','LineWidth',1);
%hold on;
%plot(dc_dc,Error4,'c.','LineWidth',1);

grid on;
legend(VGS1,VGS2,VGS3,VGS4,'Location','northeast');
%legend(VGS1,VGS2,VGS3,VGS4,'Location','southeast');
xlabel('VDS (V)','fontsize',12);
ylabel('ID ERROR (%)','fontsize',12);
title('ID ERROR IN (%) vs. VDS','fontsize',12);

%print Ion & Ig%
s=sprintf('Kth=%g vdsat=%g \n Lambda=%g  vthe=%g',Kth,vdsat,Lambda,vthe);
ht=text(0.6*dc_dc(end),min(Error(:)),s,'fontSize',12);


%save and close%
print(gcf, '-depsc', 'Validate_ExtVDSAT/IMG/Validate_ExtVDSAT.eps');
close(gcf);

