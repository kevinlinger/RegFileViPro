% Plot delay vs fanout, fit to line and get tau and p

dly = load('RVP_Inv_LEparams/delay.txt');
dly_lin = dly(1:4,:);
fo = dly(:,1);

%fit curve

params = polyfit(dly(:,1),dly(:,2),1);
tau = params(1);
p = params(2)/params(1);

%plot curve and fitted lines
fo1 = [0; 1; 2; fo];
h = plot(fo1,tau*p+tau*fo1,'-x', fo,dly(:,2),'-o');
set(h,'linewidth',1.5);
set(gca, 'fontsize',12,'fontweight','bold');
xlabel('Fanout','fontsize',12,'fontweight','bold');
ylabel('Delay','fontsize',12,'fontweight','bold');
title('Delay vs fanout for characteristic inverter');

%print tau(in ps) and p values to file
fout = fopen('RVP_Inv_LEparams/data.txt', 'w');
fprintf(fout, '%f\t%f\n', 1e12*tau,p);
fclose(fout);

%save and close%
print(gcf, '-depsc', 'RVP_Inv_LEparams/IMG/RVP_Inv_LEparams.eps');
close(gcf);
