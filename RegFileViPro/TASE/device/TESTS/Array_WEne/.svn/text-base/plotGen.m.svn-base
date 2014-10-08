%%% Only Read energy considered now. Need to add write energy sim and model


%%%SIMULATION%%%

%%%%%%%%%%%%%%%%%Write Columns%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data
load('Array_WEne/OUT/powerW64.txt');
load('Array_WEne/OUT/powerW128.txt');
load('Array_WEne/OUT/powerW256.txt');
load('Array_WEne/OUT/powerW512.txt');
load('Array_WEne/OUT/powerW1024.txt');

% get voltage current and time waveforms
V64 = powerW64(:,2);
V128 = powerW128(:,2);
V256 = powerW256(:,2);
V512 = powerW512(:,2);
V1024 = powerW1024(:,2);

I64 = powerW64(:,3);
I128 = powerW128(:,3);
I256 = powerW256(:,3);
I512 = powerW512(:,3);
I1024 = powerW1024(:,3);

T64 = powerW64(:,1);
T128 = powerW128(:,1);
T256 = powerW256(:,1);
T512 = powerW512(:,1);
T1024 = powerW1024(:,1);

VB64 = powerW64(:,4);
VB128 = powerW128(:,4);
VB256 = powerW256(:,4);
VB512 = powerW512(:,4);
VB1024 = powerW1024(:,4);

IB64 = powerW64(:,5);
IB128 = powerW128(:,5);
IB256 = powerW256(:,5);
IB512 = powerW512(:,5);
IB1024 = powerW1024(:,5);

%Set counter value for each array size (getting number of measurements)
C64 = size(T64, 1);
C128 = size(T128, 1);
C256 = size(T256, 1);
C512 = size(T512, 1);
C1024 = size(T1024, 1);

%calculate energy

E64 = 0;
E64B = 0;
for i=1:1:C64
if (i==1)
dt = 0;
else
dt = T64(i) - T64(i-1);
end
%for BL
E64 = E64 + abs(V64(i)*I64(i)*dt);
%for BLB
E64B = E64B + abs(VB64(i)*IB64(i)*dt);
end

E128 = 0;
E128B = 0;
for i=1:1:C128
if (i==1)
dt = 0;
else
dt = T128(i) - T128(i-1);
end
%for BL
E128 = E128 + abs(V128(i)*I128(i)*dt);
%for BLB
E128B = E128B + abs(VB128(i)*IB128(i)*dt);
end

E256 = 0;
E256B = 0;
for i=1:1:C256
if (i==1)
dt = 0;
else
dt = T256(i) - T256(i-1);
end
%for BL
E256 = E256 + abs(V256(i)*I256(i)*dt);
%for BLB
E256B = E256B + abs(VB256(i)*IB256(i)*dt);
end

E512 = 0;
E512B = 0;
for i=1:1:C512
if (i==1)
dt = 0;
else
dt = T512(i) - T512(i-1);
end
%for BL
E512 = E512 + abs(V512(i)*I512(i)*dt);
%for BLB
E512B = E512B + abs(VB512(i)*IB512(i)*dt);
end

E1024 = 0;
E1024B = 0;
for i=1:1:C1024
if (i==1)
dt = 0;
else
dt = T1024(i) - T1024(i-1);
end
%for BL
E1024 = E1024 + abs(V1024(i)*I1024(i)*dt);
%for BLB
E1024B = E1024B + abs(VB1024(i)*IB1024(i)*dt);
end


EW = [E64 E128 E256 E512 E1024];
EWB = [E64B E128B E256B E512B E1024B];



%%%%%%%%%%%%%%%%%Read Columns%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data
load('Array_WEne/OUT/powerR64.txt');
load('Array_WEne/OUT/powerR128.txt');
load('Array_WEne/OUT/powerR256.txt');
load('Array_WEne/OUT/powerR512.txt');
load('Array_WEne/OUT/powerR1024.txt');

% get voltage current and time waveforms
VR64 = powerR64(:,2);
VR128 = powerR128(:,2);
VR256 = powerR256(:,2);
VR512 = powerR512(:,2);
VR1024 = powerR1024(:,2);

IR64 = powerR64(:,3);
IR128 = powerR128(:,3);
IR256 = powerR256(:,3);
IR512 = powerR512(:,3);
IR1024 = powerR1024(:,3);

TR64 = powerR64(:,1);
TR128 = powerR128(:,1);
TR256 = powerR256(:,1);
TR512 = powerR512(:,1);
TR1024 = powerR1024(:,1);

VBR64 = powerR64(:,5);
VBR128 = powerR128(:,5);
VBR256 = powerR256(:,5);
VBR512 = powerR512(:,5);
VBR1024 = powerR1024(:,5);

IBR64 = powerR64(:,6);
IBR128 = powerR128(:,6);
IBR256 = powerR256(:,6);
IBR512 = powerR512(:,6);
IBR1024 = powerR1024(:,6);

%Set counter value for each array size (getting number of measurements)
CR64 = size(T64, 1);
CR128 = size(T128, 1);
CR256 = size(T256, 1);
CR512 = size(T512, 1);
CR1024 = size(T1024, 1);

%Find energy by multiplying V*I*dT
ER64=0;
ER64B = 0;
dt = zeros(CR64,1);
for i=1:1:CR64
if (i == 1)
dt(i) = 0;
else
dt(i) = TR64(i) - TR64(i-1);
end
%for BL
ER64 = ER64 + abs(VR64(i)*IR64(i)*dt(i));
%for BLB
ER64B = ER64B + abs(VBR64(i)*IBR64(i)*dt(i));
end 

ER128=0;
ER128B = 0;
dt = zeros(CR128,1);
for i=1:1:CR128
if (i == 1)
dt(i) = 0;
else
dt(i) = TR128(i) - TR128(i-1);
end
%for BL
ER128 = ER128 + abs(VR128(i)*IR128(i)*dt(i));
%for BLB
ER128B = ER128B + abs(VBR128(i)*IBR128(i)*dt(i));
end 

ER256=0;
ER256B = 0;
dt = zeros(CR256,1);
for i=1:1:CR256
if (i == 1)
dt(i) = 0;
else
dt(i) = TR256(i) - TR256(i-1);
end
%for BL
ER256 = ER256 + abs(VR256(i)*IR256(i)*dt(i));
%for BLB
ER256B = ER256B + abs(VBR256(i)*IBR256(i)*dt(i));
end 

ER512=0;
ER512B = 0;
dt = zeros(CR512,1);
for i=1:1:CR512
if (i == 1)
dt(i) = 0;
else
dt(i) = TR512(i) - TR512(i-1);
end
%for BL
ER512 = ER512 + abs(VR512(i)*IR512(i)*dt(i));
%for BLB
ER512B = ER512B + abs(VBR512(i)*IBR512(i)*dt(i));
end 

ER1024=0;
ER1024B = 0;
dt = zeros(CR1024,1);
for i=1:1:CR1024
if (i == 1)
dt(i) = 0;
else
dt(i) = TR1024(i) - TR1024(i-1);
end
%for BL
ER1024 = ER1024 + abs(VR1024(i)*IR1024(i)*dt(i));
%for BLB
ER1024B = ER1024B + abs(VBR1024(i)*IBR1024(i)*dt(i));
end 


ER = [ER64 ER128 ER256 ER512 ER1024];
ERB = [ER64B ER128B ER256B ER512B ER1024B];


ET = EW*8 + ER.*(NR-9);
ETB = EWB*8 + ERB.*(NR-9); 


%%%%%%%%%Plot results%%%%%%%%%%%%%%

f1 = figure(1);
h1 = plot(NR, EW, '--', NR, EWB, '-.');

set(h1, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',10,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('No: of rows','fontsize',10,'fontweight','bold');
ylabel('BL Energy per read cycle (J) per write column','fontsize',10,'fontweight','bold');
legend('SimBLW', 'ModelW', 'SimBLBW');
print(f1,'-depsc','-r300','Array_WEne/IMG/Array_WEneRows.eps');


f2 = figure(2);
h2 = plot( NR, ER, '--', NR, ERB, '-.');

set(h2, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',10,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('No: of rows','fontsize',10,'fontweight','bold');
ylabel('BL Energy per read cycle (J) per read column','fontsize',10,'fontweight','bold');
legend( 'SimBLR','SimBLBR');
print(f2,'-depsc','-r300','Array_WEne/IMG/Array_WEneColumns.eps');



f3 = figure(3);
h3 = plot(NR, ET,'--', NR, ETB, '-.');
set(h3, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',10,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('No: of rows','fontsize',10,'fontweight','bold');
ylabel('BL Energy per read cycle (J)','fontsize',10,'fontweight','bold');
legend('BL','BLB');
print(f3,'-depsc','-r300','Array_WEne/IMG/Array_WEneTotal.eps');





