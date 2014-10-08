%%%%%%%%%%%%%%%%%%%%%%%GWL


%%%SIMULATION%%%
load('WL_Ene/OUT/GWL/Gpower16.txt');
load('WLEne/OUT/GWL/Gpower32.txt');
load('WLEne/OUT/GWL/Gpower64.txt');
load('WLEne/OUT/GWL/Gpower128.txt');
load('WLEne/OUT/GWL/Gpower256.txt');

%% Get the list of current, voltage and time(measurements) from sims
I16 = Gpower16(:,3);
I32 = Gpower32(:,3);
I64 = Gpower64(:,3);
I128 = Gpower128(:,3);
I256 = Gpower256(:,3);

V16 = Gpower16(:,2);
V32 = Gpower32(:,2);
V64 = Gpower64(:,2);
V128 = Gpower128(:,2);
V256 = Gpower256(:,2);

T16 = Gpower16(:,1);
T32 = Gpower32(:,1);
T64 = Gpower64(:,1);
T128 = Gpower128(:,1);
T256 = Gpower256(:,1);

DN16 = Gpower16(:,4);
DN32 = Gpower32(:,4);
DN64 = Gpower64(:,4);
DN128 = Gpower128(:,4);
DN256 = Gpower256(:,4);

DP16 = Gpower16(:,5);
DP32 = Gpower32(:,5);
DP64 = Gpower64(:,5);
DP128 = Gpower128(:,5);
DP256 = Gpower256(:,5);

A16 = Gpower16(:,6);
A32 = Gpower32(:,6);
A64 = Gpower64(:,6);
A128 = Gpower128(:,6);
A256 = Gpower256(:,6);

AD16 = Gpower16(:,7);
AD32 = Gpower32(:,7);
AD64 = Gpower64(:,7);
AD128 = Gpower128(:,7);
AD256 = Gpower256(:,7);



%%Get the size of the list
c16 = size(T16,1);
c32 = size(T32,1);
c64 = size(T64,1);
c128 = size(T128,1);
c256 = size(T256,1);

%%for loop for getting energy

E16=0;
EA16=0;
for i=1:1:c16
dt=0;
if (i >1)
dt = T16(i) - T16(i-1);
end
EA16 = EA16+ abs(V16(i)*I16(i)*dt);
EO16 = (DN16(i)+DP16(i)+A16(i)+AD16(i))*dt;
end
E16 = EA16 + EO16;

E32=0;
EA32=0;
ED32=0;
for i=1:1:c32
dt=0;
if (i >1)
dt = T32(i) - T32(i-1);
end
EA32 = EA32 + abs(V32(i)*I32(i)*dt);
EO32 = (DN32(i)+DP32(i)+A32(i)+AD32(i))*dt;
end
E32 = EA32+EO32;


E64=0;
EA64=0;
ED64=0;
for i=1:1:c64
dt=0;
if (i >1)
dt = T64(i) - T64(i-1);
end
EA64 = EA64 + abs(V64(i)*I64(i)*dt);
EO64 = (DN64(i)+DP64(i)+A64(i)+AD64(i))*dt;
end
E64 = EA64 + EO64;

E128=0;
EA128=0;
ED128=0;
for i=1:1:c128
dt=0;
if (i >1)
dt = T128(i) - T128(i-1);
end
EA128 = EA128 + abs(V128(i)*I128(i)*dt);
EO128 = (DN128(i)+DP128(i)+A128(i)+AD128(i))*dt;
end
E128 = EA128 + EO128;

E256=0;
EA256=0;
ED256=0;
for i=1:1:c256
dt=0;
if (i >1)
dt = T256(i) - T256(i-1);
end
EA256 = EA256 + V256(i)*I256(i)*dt;
EO256 = (DN256(i)+DP256(i)+A256(i)+AD256(i))*dt;
end
E256 = EA256 + EO256;



%%plot power
Energy_GWL = [E16 E32 E64 E128 E256];
ncolumns = [16 32 64 128 256];
EA = [EA16 EA32 EA64 EA128 EA256];
EO = [EO16 EO32 EO64 EO128 EO256];







%%%%%%%%%%%%%%%%%%%%%%%%%%%LWL

%%%SIMULATION%%%

% load data
load('WL_Ene/OUT/LWL/Lpower16.txt');
load('WL_Ene/OUT/LWL/Lpower32.txt');
load('WL_Ene/OUT/LWL/Lpower64.txt');
load('WL_Ene/OUT/LWL/Lpower128.txt');
load('WL_Ene/OUT/LWL/Lpower256.txt');


% get voltage and Lpower waveforms
LV16 = Lpower16(:,2);
LV32 = Lpower32(:,2);
LV64 = Lpower64(:,2);
LV128 = Lpower128(:,2);
LV256 = Lpower256(:,2);

LI16 = Lpower16(:,3);
LI32 = Lpower32(:,3);
LI64 = Lpower64(:,3);
LI128 = Lpower128(:,3);
LI256 = Lpower256(:,3);

LT16 = Lpower16(:,1);
LT32 = Lpower32(:,1);
LT64 = Lpower64(:,1);
LT128 = Lpower128(:,1);
LT256 = Lpower256(:,1);

LP16 = Lpower16(:,4);
LP32 = Lpower32(:,4);
LP64 = Lpower64(:,4);
LP128 = Lpower128(:,4);
LP256 = Lpower256(:,4);

LPA16 = Lpower16(:,5);
LPA32 = Lpower32(:,5);
LPA64 = Lpower64(:,5);
LPA128 = Lpower128(:,5);
LPA256 = Lpower256(:,5);

%%Get the size of the list
Lc16 = size(T16,1);
Lc32 = size(T32,1);
Lc64 = size(T64,1);
Lc128 = size(T128,1);
Lc256 = size(T256,1);


%for loop to get energy

LE16=0;
Lp16 = zeros(Lc16,1);
for i=1:1:Lc16
dt=0;
if (i >1)
dt = LT16(i) - LT16(i-1);
end
Lpp16(i) = LV16(i)*LI16(i)*dt;
LPd16(i) = (LP16(i)+LPA16(i))*dt;
LE16 = LE16 + Lpp16(i)+LPd16(i);
end

LE32=0;
Lp32 = zeros(Lc32,1);
for i=1:1:Lc32
dt=0;
if (i >1)
dt = LT32(i) - LT32(i-1);
end
Lpp32(i) = LV32(i)*LI32(i)*dt;
LPd32(i) = (LP32(i)+LPA32(i))*dt;
LE32 = LE32 + Lpp32(i)+LPd32(i);
end

LE64=0;
Lp64 = zeros(Lc64,1);
for i=1:1:Lc64
dt=0;
if (i >1)
dt = LT64(i) - LT64(i-1);
end
Lpp64(i) = LV64(i)*LI64(i)*dt;
LPd64(i) = (LP64(i)+LPA64(i))*dt;
LE64 = LE64 + Lpp64(i)+LPd64(i);
end

LE128=0;
Lp128 = zeros(Lc128,1);
for i=1:1:Lc128
dt=0;
if (i >1)
dt = LT128(i) - LT128(i-1);
end
Lpp128(i) = LV128(i)*LI128(i)*dt;
LPd128(i) = (LP128(i)+LPA128(i))*dt;
LE128 = LE128 + Lpp128(i)+LPd128(i);
end

LE256=0;
Lp256 = zeros(Lc256,1);
for i=1:1:Lc256
dt=0;
if (i >1)
dt = LT256(i) - LT256(i-1);
end
Lpp256(i) = LV256(i)*LI256(i)*dt;
LPd256(i) = (LP256(i)+LPA256(i))*dt;
LE256 = LE256 + Lpp256(i)+LPd256(i);
end

Energy_LWL = [E16 E32 E64 E128 E256];
ncols = [16 32 64 128 256];


%%PLOT RESULTS


f1 = figure(1);
h1 = plot(ncols, Energy_LWL,'--', ncols, Energy_GWL);
set(h1, 'linewidth', 2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',10,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('No: of cols','fontsize',10,'fontweight','bold');
ylabel('Local WL Energy per cycle (J)','fontsize',10,'fontweight','bold');
legend('LWL','GWL','Location','SouthEast');

print(f1,'-depsc','-r300','WL_Ene/IMG/WL_Ene.eps');
close(f1)
