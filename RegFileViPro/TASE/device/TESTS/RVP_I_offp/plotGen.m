%##########################################################
%#      MATLAB code to plot PMOS leakage current vs VDS   #
%##########################################################

%load data%
load RVP_I_offp/DAT/dc_dc.dat;
load RVP_I_offp/DAT/dc_P1_PX_d.dat;

%put current data into matrix I%
I=dc_P1_PX_d;

%print Ioff at nominal VDD to file for RVP model calculations
fout = fopen('RVP_I_offp/data.txt', 'w');
fprintf(fout, '%e\n', abs(I(1,1)));
fclose(fout);

%plot data and format figure%
semilogy(abs(dc_dc),abs(I),'LineWidth',2);
grid on;
xlabel('VDS (V)','fontsize',12);
ylabel('\midDrain Current\mid (A)','fontsize',12);
title('PMOS Leakage Current vs. VDS','fontsize',16);

%extract the DIBL/S coefficient 
%remove the points close to 5*Vth (5*26mV)
Vth = 0.026;
thresh = 5*Vth;
id = find(abs(dc_dc)>thresh);
vds = abs(dc_dc(id));
lnI = log(abs(I(id)));
%fitting the linear curve ln(I)
p = polyfit(vds,lnI,1);
DIBLdivS = p(1)/log(10);
%plot the fitted curve
yfit = exp(p(1).*vds+p(2));
hold on;
semilogy(vds,yfit,'--r','LineWidth',1.5);
str = sprintf('Fitted w/ DIBL/S=%f',DIBLdivS);
legend('Simulated',str,'location','southEast');
%save the DIBL/S value into a file
%fout = fopen('RVP_I_offp/data.txt', 'w');
%fprintf(fout, '%e\n', [DIBLdivS]'); 
%fclose(fout);

%save and close%
print(gcf, '-depsc', 'RVP_I_offp/IMG/RVP_I_offp.eps');
close(gcf);

