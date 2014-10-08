%####################################################
%#      MATLAB code to plot NMOS leakage curves     #
%####################################################

%load data%
load leakage_N/DAT/dc_dc.dat;
load leakage_N/DAT/dc_N1_NX_d.dat;
load leakage_N/DAT/dc_N1_NX_g.dat;
load leakage_N/DAT/dc_N1_NX_s.dat;
load leakage_N/DAT/dc_VBULK_p.dat;

%put all data into matrix I%
I=abs(cat(2,dc_N1_NX_d,dc_N1_NX_g,dc_N1_NX_s,dc_VBULK_p));

%plot data and format figure%
semilogy(dc_dc,I,'LineWidth',2);
grid on;
legend('\midDrain\mid','\midGate\mid','\midSource\mid','\midBulk\mid','Location','NorthWest');
xlabel('VGS (V)','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Leakage Currents','fontsize',16);

%get Ioff
W=<wdef>;
Ioff = abs(dc_N1_NX_d(find(dc_dc==0)))*1e12/(W*1e6);


%extract the subthreshold swing factor 'n'
Is = I(:,3);
id = find(dc_dc>=0 & dc_dc<=0.3);
Vgs = abs(dc_dc(id));
lnI = log(Is(id));
%fitting the linear curve ln(Is)
p = polyfit(Vgs,lnI,1);
Vth = 0.026;
n = 1/Vth/p(1);
S = log(10)*n*Vth*1000;
%plot the fitted curve
id = find(dc_dc>=0 & dc_dc<=0.6);
Vgs = abs(dc_dc(id));
yfit = exp(p(1).*Vgs+p(2));
hold on;
semilogy(Vgs,yfit,'--mx','LineWidth',1.5);
str = sprintf('Fitted Ids (S=%f) Ioff=%g (pA/um)',S, Ioff);
legend('\midDrain\mid','\midGate\mid','\midSource\mid',...
    '\midBulk\mid',str,'Location','NorthWest');
set(gca,'xTick',-1.5:0.1:1.5);

%save the [Ioff S] values into a file
fout = fopen('leakage_N/data.txt', 'w');
fprintf(fout, '%e\t%e\n', [Ioff S]'); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'leakage_N/IMG/leakage_N.eps');
close(gcf);
