% Plot delay vs fanout, fit to line and get tau and p

dly = load('RVP_Nand_LEparams/delay.txt');
tau_pinv = load('RVP_Inv_LEparams/data.txt');
tau = tau_pinv(1);
fo = dly(:,1);

%divide dly by tau
dly(:,2) = dly(:,2)/tau;

%fit curve

params = polyfit(dly(:,1),dly(:,2),1);
g = params(1);
p = params(2);

%plot curve and fitted lines
fo1 = [0; 1; 2; fo];
h = plot(fo1,p+g*fo1,'-x', fo,dly(:,2),'-o');
set(h,'linewidth',1.5);
set(gca, 'fontsize',12,'fontweight','bold');
xlabel('Fanout','fontsize',12,'fontweight','bold');
ylabel('Delay','fontsize',12,'fontweight','bold');
title('Delay vs fanout for characteristic inverter');

%print tau(in ps) and p values to file
fout = fopen('RVP_Nand_LEparams/data.txt', 'w');
fprintf(fout, '%f\t%f\n', p,g);
fclose(fout);

%save and close%
print(gcf, '-depsc', 'RVP_Nand_LEparams/IMG/RVP_Nand_LEparams.eps');
close(gcf);
