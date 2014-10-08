%####################################################
%#      MATLAB code to plot NMOS leakage curves     #
%####################################################

%load data%
load lk_stack_n/DAT/dc_dc.dat;
load lk_stack_n/DAT/dc_N1_NX_d.dat;
load lk_stack_n/DAT/dc_N1_NX_g.dat;
load lk_stack_n/DAT/dc_N1_NX_s.dat;
load lk_stack_n/DAT/dc_VBULK_p.dat;
load lk_stack_n/DAT/dc_N2_NX_d.dat;
load lk_stack_n/DAT/dc_N2_NX_g.dat;
load lk_stack_n/DAT/dc_N2_NX_s.dat;
load lk_stack_n/DAT/dc_N3_NX_d.dat;
load lk_stack_n/DAT/dc_N3_NX_g.dat;
load lk_stack_n/DAT/dc_N3_NX_s.dat;
load lk_stack_n/DAT/dc_N4_NX_d.dat;
load lk_stack_n/DAT/dc_N4_NX_g.dat;
load lk_stack_n/DAT/dc_N4_NX_s.dat;

%put all data into matrix I%
%I=abs(cat(2,dc_N1_NX_d,dc_N1_NX_g,dc_N1_NX_s,dc_VBULK_p,dc_N2_NX_d,dc_N2_NX_g,dc_N2_NX_s,dc_N3_NX_d,dc_N3_NX_g,dc_N3_NX_s,dc_N4_NX_d,dc_N4_NX_g,dc_N4_NX_s));
I=abs(cat(2,dc_N1_NX_d,dc_VBULK_p,dc_N2_NX_d,dc_N3_NX_d,dc_N4_NX_d));

%plot data and format figure%
semilogy(dc_dc,I,'LineWidth',2);
grid on;
%legend('\midDrain\mid','\midGate\mid','\midSource\mid','\midBulk\mid','Location','NorthWest');
legend('\midDrain\mid','Location','NorthWest');
xlabel('VGS (V)','fontsize',12);
ylabel('Current (A)','fontsize',12);
title('Ioff/Ion - 2 nfets in series vs single','fontsize',16);

%get Ioff
W=<wdef>;
Ioff2 = abs(dc_N1_NX_d(find(dc_dc==0)))*1e12/(W*1e6);
Ioff3 = abs(dc_N3_NX_d(find(dc_dc==0)))*1e12/(W*1e6);
Isoff2=abs(dc_N1_NX_s(find(dc_dc==0)))*1e12/(W*1e6);
Isoff3 = abs(dc_N3_NX_s(find(dc_dc==0)))*1e12/(W*1e6);
Ioff4 = abs(dc_N4_NX_d(find(dc_dc==0)))*1e12/(W*1e6);
Isoff4 = abs(dc_N4_NX_s(find(dc_dc==0)))*1e12/(W*1e6);
Ion2 = abs(dc_N1_NX_d(find(dc_dc==<pvdd>)))*1e6/(W*1e6);
Ion3 = abs(dc_N3_NX_d(find(dc_dc==<pvdd>)))*1e6/(W*1e6);
Ion4 = abs(dc_N4_NX_d(find(dc_dc==<pvdd>)))*1e6/(W*1e6);

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
str1 = sprintf('stacked Idoff=%g(pA/um) Ion2ser=%g (uA/um)',Ioff2,Ion2);
str2 = sprintf('Idoff 2*Lmin=%g (pA/um) Ion2L=%g (uA/um)',Ioff3,Ion3);
str3 = sprintf('base case Idoff Lmin=%g (pA/um) Ion1L=%g (uA/um)',Ioff4,Ion4);
%legend('\midDrain\mid','\midGate\mid','\midSource\mid','\midBulk\mid',str1,str2,str3,'Location','NorthWest');
legend(str1,str2,str3,'Location','NorthWest');
set(gca,'xTick',-.5:0.1:1.5);

%save the [Ioff2 S] values into a file
fout = fopen('lk_stack_n/data.txt', 'w');
fprintf(fout, '%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\n', [Ioff2 Ion2 Ioff3 Ion3 Ioff4 Ion4 Isoff2 Isoff3 Isoff4]); 
fclose(fout);

%save and close%
print(gcf, '-depsc', 'lk_stack_n/IMG/leakage_2N_vs_1N_v2.eps');
close(gcf);
