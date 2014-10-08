%##########################################################
%#      MATLAB code to plot NMOS Leakage current vs VDS   #
%##########################################################

%load data%
load RVP_Ileak_PG/DAT/dc_dc.dat;
load RVP_Ileak_PG/DAT/dc_N1_NX_d.dat;

%put current data into matrix I%
I=dc_N1_NX_d;

W=270e-9;
Leff=125e-9;
I=I*1e6/(W*1e6);  %I in the unit of uA/um

%output Ioff at VDS=nominal VDD for RVP model calculations
%fout = fopen('RVP_Ileak_PG/data.txt','w');
%fprintf(fout, '%e\n',I(1,1));
%fclose(fout);

%plot data and format figure%
semilogy(abs(dc_dc),abs(I),'LineWidth',2);
grid on;
xlabel('VDS (V)','fontsize',12);
ylabel('\midDrain Current\mid (A)','fontsize',12);
title('NMOS Leakage Current vs. VDS','fontsize',16);

%extract the DIBL/S coefficient 
%remove the points close to 5*Vth (5*26mV)
Vth = 0.026;
thresh = 5*Vth;
id = find(abs(dc_dc)>thresh);
vds = abs(dc_dc(id));
lnI = log(abs(I(id)));
%fitting the linear curve ln(I)
p = polyfit(vds,lnI,1);
%calcuate dibl/S
DIBLdivS = p(1)/log(10);
%plot the fitted curve
yfit = exp(p(1).*vds+p(2));
hold on;
semilogy(vds,yfit,'--r','LineWidth',1.5);
str = sprintf('Fitted w/ DIBL/S=%f',DIBLdivS);
legend('Simulated',str,'location','southEast');
%save the DIBL/S value into a file
%fout = fopen('RVP_Ileak_PG/data.txt', 'w');
%fprintf(fout, '%e\n', [DIBLdivS]'); 
%fclose(fout);

%save and close%
print(gcf, '-depsc', 'RVP_Ileak_PG/IMG/RVP_Ileak_PG.eps');
close(gcf);

