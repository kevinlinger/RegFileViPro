


%load data
load('Array_LK/OUT/Ave.txt');

NC =Ave(:,1);
NR =Ave(:,2);
AvP=Ave(:,3);




%plot values
f1 = figure(1);
h1 = plot(NC, AvP);
set(h1, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',10,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('No: of rows','fontsize',10,'fontweight','bold');
ylabel('Ave Power per column','fontsize',10,'fontweight','bold');
legend( 'SimBLR','SimBLBR');
print(f1,'-depsc','-r300','Array_LK/IMG/Array_LK.eps');



