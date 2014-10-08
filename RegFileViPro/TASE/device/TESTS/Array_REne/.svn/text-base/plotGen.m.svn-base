%################################################
%# MATLAB code to plot Array Energy during read #
%################################################



%%%SIMULATION%%%

% load data
load ('Array_REne/OUT/powerRows64.txt');
load ('Array_REne/OUT/powerRows128.txt');
load ('Array_REne/OUT/powerRows256.txt');
load ('Array_REne/OUT/powerRows512.txt');
load ('Array_REne/OUT/powerRows1024.txt');


% get voltage current and time waveforms into an matri
V64 = powerRows64(:,2);
V128 = powerRows128(:,2);
V256 = powerRows256(:,2);
V512 = powerRows512(:,2);
V1024 = powerRows1024(:,2);

I64 = powerRows64(:,3);
I128 = powerRows128(:,3);
I256 = powerRows256(:,3);
I512 = powerRows512(:,3);
I1024 = powerRows1024(:,3);

T64 = powerRows64(:,1);
T128 = powerRows128(:,1);
T256 = powerRows256(:,1);
T512 = powerRows512(:,1);
T1024 = powerRows1024(:,1);

VB64 = powerRows64(:,5);
VB128 = powerRows128(:,5);
VB256 = powerRows256(:,5);
VB512 = powerRows512(:,5);
VB1024 = powerRows1024(:,5);

IB64 = powerRows64(:,6);
IB128 = powerRows128(:,6);
IB256 = powerRows256(:,6);
IB512 = powerRows512(:,6);
IB1024 = powerRows1024(:,6);

X64 = powerRows64(:,4);
X128 = powerRows128(:,4);
X256 = powerRows256(:,4);
X512 = powerRows512(:,4);
X1024 = powerRows1024(:,4);




%Set counter value for each array size (getting number of measurements)
C64 = size(T64, 1);
C128 = size(T128, 1);
C256 = size(T256, 1);
C512 = size(T512, 1);
C1024 = size(T1024, 1);

%Find energy by multiplying V*I*dT
E64total=0;
E64Btotal = 0;
dt = zeros(C64,1);
for i=1:1:C64
if (i == 1)
dt(i) = 0;
else
dt(i) = T64(i) - T64(i-1);
end
%for BL
E64 = abs(V64(i)*I64(i)*dt(i));
E64total = E64total + E64;
%for BLB
E64B = abs(VB64(i)*IB64(i)*dt(i));
E64Btotal = E64Btotal + E64B;
end
Pe64 = E64total;
PeB64 = E64Btotal;

E128total=0;
E128Btotal = 0;
for i=1:1:C128
if (i == 1)
dt = 0;
else
dt = T128(i) - T128(i-1);
end
%for BL
E128 = abs(V128(i)*I128(i)*dt);
E128total = E128total + E128;
%for BLB
E128B = abs(VB128(i)*IB128(i)*dt);
E128Btotal = E128Btotal + E128B;
end
Pe128 = E128total;
PeB128 = E128Btotal;

E256total=0;
E256Btotal = 0;
for i=1:1:C256
if (i == 1)
dt = 0;
else
dt = T256(i) - T256(i-1);
end
%for BL
E256 = abs(V256(i)*I256(i)*dt);
E256total = E256total + E256;
%for BLB
E256B = abs(VB256(i)*IB256(i)*dt);
E256Btotal = E256Btotal + E256B;
end
Pe256 = E256total;
PeB256 = E256Btotal;

E512total=0;
E512Btotal = 0;
for i=1:1:C512
if (i == 1)
dt = 0;
else
dt = T512(i) - T512(i-1);
end
%for BL
E512 = abs(V512(i)*I512(i)*dt);
E512total = E512total + E512;
%for BLB
E512B = abs(VB512(i)*IB512(i)*dt);
E512Btotal = E512Btotal + E512B;
end
Pe512 = E512total;
PeB512 = E512Btotal;

E1024total=0;
E1024Btotal = 0;
for i=1:1:C1024
if (i == 1)
dt = 0;
else
dt = T1024(i) - T1024(i-1);
end
%for BL
E1024 = abs(V1024(i)*I1024(i)*dt);
E1024total = E1024total + E1024;
%for BLB
E1024B = abs(VB1024(i)*IB1024(i)*dt);
E1024Btotal = E1024Btotal + E1024B;
end
Pe1024 = E1024total;
PeB1024 = E1024Btotal;

% get instantaneous power
P64 = abs(V64.*I64);
P128 = abs(V128.*I128);
P256 = abs(V256.*I256);
P512 = abs(V512.*I512);
P1024 = abs(V1024.*I1024);


% plot average power
Energy_RBL = 1e-8*[mean(P64) mean(P128) mean(P256) mean(P512) mean(P1024)];
Enn = [Pe64 Pe128 Pe256 Pe512 Pe1024];
EnnB = [PeB64 PeB128 PeB256 PeB512 PeB1024];



%Multiply by number of columns
for i = 1:1:5
Energy_RBL2(i) = Energy_RBL(i)*M(i);
Enn2(i) = Enn(i) * M(i);
EnnB2(i) = EnnB(i) * M(i);
end


nrows = [64 128 256 512 1024];
Edif = EnnB - Enn;
f1 = figure(1);
h1 = plot(nrows, EnnB,'--', nrows, Enn, '-.');

set(h1, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',10,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('No: of rows','fontsize',10,'fontweight','bold');
ylabel('BL Energy per read cycle (J)','fontsize',10,'fontweight','bold');
legend('Sim BLB','SimBL','Location','NorthEast');
print(f1,'-depsc','Array_REne/IMG/Array_REneRows.eps');
close(f1);


Edif2 = EnnB2 - Enn2;
f2 = figure(2);
h2 = plot(nrows, EnnB2,'--', nrows, Enn2, '-.');
set(h2, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',10,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('No: of rows','fontsize',10,'fontweight','bold');
ylabel('BL Energy per read cycle (J)','fontsize',10,'fontweight','bold');
legend('SimBLB','SimBL','Location','NorthEast');
print(f2,'-depsc','Array_REne/IMG/Array_REneColumns.eps');

