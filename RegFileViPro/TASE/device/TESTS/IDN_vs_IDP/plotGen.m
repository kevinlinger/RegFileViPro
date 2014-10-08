%####################################################
%#      MATLAB code to plot NMOS logIDVD curves     #
%####################################################

%load data% 
load IDN_vs_IDP/DAT/dc_pvdd.dat;
load IDN_vs_IDP/DAT/dc_N1_NX_d.dat;
load IDN_vs_IDP/DAT/dc_P1_PX_d.dat;

%in uA%
In = abs(dc_N1_NX_d)*1e6;
Ip = abs(dc_P1_PX_d)*1e6;


%plot data and format figure%
subplot(2,1,1);
plot(In,Ip,'-o','LineWidth',2);
hold on;
plot(In,In,'--k');
grid on;
%legend(VGS1,VGS2,VGS3,'Location','NorthWest');
xlabel('IDn (uA)','fontsize',12);
ylabel('IDp (uA)','fontsize',12);
title('PMOS/NMOS Drain Current Ratio vs. VDD','fontsize',16);


subplot(2,1,2);
plot(dc_pvdd,In./Ip,'-o','LineWidth',2);
grid on;
%legend(VGS1,VGS2,VGS3,'Location','NorthWest');
xlabel('VDD (V)','fontsize',12);
ylabel('IDn / IDp','fontsize',12);
title('NMOS/PMOS Drain Current Ratio vs. VDD','fontsize',16);


%save and close%
print(gcf, '-depsc', 'IDN_vs_IDP/IMG/IDN_vs_IDP.eps');
close(gcf);
