load ('WL_Del/OUT/result.txt');
NB = result(:,1);
NC = result(:,2);
St = result(:,3);
GW = result(:,4);
GWw = result(:,5);
LW = result(:,6);
LWw = result(:,7);
IG = result(:,8);
IL = result(:,9);

%%simulation

%%GW buffer 
G1 = GW - St;
%%GW interconnect
G2 = GWw - GW;
%%LW NAND+buffer
L1 = LW - GWw;
%%LWL interconnect
L2 = LWw-LW;


f1 = figure(1);
h1 = plot(NB, G2,':gx',NB, L2,'-bs');
set(h1, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',7,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('Number of banks','fontsize' ,7);
ylabel('Delay', 'fontsize',7);
legend('GWL intc','LWL intc',-1);
plot(f1, 'depsc', 'WL_Del/IMG/WL_DelBanks.eps')

f2 = figure(2);
h2 = plot( NC, G2,':gx',NC, L2,'-bs', NC);
set(h2, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',7,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('Number of columns','fontsize' ,7);
ylabel('Delay', 'fontsize',7);
legend('GWL intc','LWL intc',-1);
plot(f2, 'depsc', 'WL_Del/IMG/WL_DelColumn.eps')
