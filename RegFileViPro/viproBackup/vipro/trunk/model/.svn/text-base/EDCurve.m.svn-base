dcon = 0.3;
delete('output.txt');
while (dcon <= 3)
    optimizeBruteForce(0, dcon*1e-9);
    dcon = dcon+0.05;
end

system('uniq -1 output.txt > uniq_output.txt');

% Plot E-D curve of tool output for various constraints

EDcurveData = load('uniq_output.txt');

E = EDcurveData(:,4);%./min(EDcurveData(:,4));
D = EDcurveData(:,5);%./min(EDcurveData(:,5));

h = plot(D,E,'-o');
set(h, 'linewidth',2);
set(gca,'xgrid','on','ygrid','on','fontsize',10,'fontweight','bold');
xlabel('Access time ','fontsize',10,'fontweight','bold');
ylabel('Energy per access ','fontsize',10,'fontweight','bold');
%title('Tool Output with different delay constraints for 16kb, 16-bit word-size');
%axis([4e-10 13e-10 1e-12 12e-12]);
% text(1.01,1.21,'64x256','fontsize',10,'fontweight','bold');
% text(1.04,1.04,'128x128','fontsize',10,'fontweight','bold');
% text(1.2,1.01,'256x64','fontsize',10,'fontweight','bold');

%set(gcf,'PaperPosition',[0 0 2 2]);

print(gcf,'-depsc','EDCurve.eps');
close(gcf);

exit;