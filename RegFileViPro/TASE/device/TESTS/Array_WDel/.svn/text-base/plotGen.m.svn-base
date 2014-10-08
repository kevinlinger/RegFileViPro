

load ('Array_WDel/Out/delayW.txt');

%%Delay for currents
load ('Array_WDel/Out/delayRows64.txt');
load ('Array_WDel/Out/delayRows128.txt');
load ('Array_WDel/Out/delayRows256.txt');
load ('Array_WDel/Out/delayRows512.txt');
load ('Array_WDel/Out/delayRows1024.txt');

T64 = delayRows64(:,1);
I64 = delayRows64(:,2);
IB64 =delayRows64(:,3);
C64 = size(T64,1);

T128 = delayRows128(:,1);
I128 = delayRows128(:,2);
IB128 =delayRows128(:,3);
C128 = size(T128,1);

T256 = delayRows256(:,1);
I256 = delayRows256(:,2);
IB256 =delayRows256(:,3);
C256 = size(T256,1);

T512 = delayRows512(:,1);
I512 = delayRows512(:,2);
IB512 =delayRows512(:,3);
C512 = size(T512,1);

T1024 = delayRows1024(:,1);
I1024 = delayRows1024(:,2);
IB1024 =delayRows1024(:,3);
C1024 = size(T1024,1);

NR = [64 128 256 512 1024];

SI64=0;
SIB64 =0;
for i = 1:1:C64
   if (i==1)
       dt = 0;
   else
       dt = T64(i) - T64(i-1);
   end 
   SI64= SI64 + abs(I64(i)*dt);
   SIB64= SIB64 + abs(IB64(i)*dt);
end
AI64 = SI64/T64(C64);
AIB64 = SIB64/T64(C64);

SI128=0;
SIB128 =0;
for i = 1:1:C128
   if (i==1)
       dt = 0;
   else
       dt = T128(i) - T128(i-1);
   end 
   SI128= SI128 + abs(I128(i)*dt);
   SIB128= SIB128 + abs(IB128(i)*dt);
end
AI128 = SI128/T128(C128);
AIB128 = SIB128/T128(C128);

SI256=0;
SIB256 =0;
for i = 1:1:C256
   if (i==1)
       dt = 0;
   else
       dt = T256(i) - T256(i-1);
   end 
   SI256= SI256 + abs(I256(i)*dt);
   SIB256= SIB256 + abs(IB256(i)*dt);
end
AI256 = SI256/T256(C256);
AIB256 = SIB256/T256(C256);


SI512=0;
SIB512 =0;
for i = 1:1:C512
   if (i==1)
       dt = 0;
   else
       dt = T512(i) - T512(i-1);
   end 
   SI512= SI512 + abs(I512(i)*dt);
   SIB512= SIB512 + abs(IB512(i)*dt);
end
AI512 = SI512/T512(C512);
AIB512 = SIB512/T512(C512);

SI1024=0;
SIB1024 =0;
for i = 1:1:C1024
   if (i==1)
       dt = 0;
   else
       dt = T1024(i) - T1024(i-1);
   end 
   SI1024= SI1024 + abs(I1024(i)*dt);
   SIB1024= SIB1024 + abs(IB1024(i)*dt);
end
AI1024 = SI1024/T1024(C1024);
AIB1024 = SIB1024/T1024(C1024);


AI = [AI64 AI128 AI256 AI512 AI1024];
AIB = [AIB64 AIB128 AIB256 AIB512 AIB1024];


Mcolumn = delayW(:,1);
Nrows = delayW(:,2);
delQ = delayW(:,3);
delQB = delayW(:,4);

f1=figure(1);
h1=plot(Mcolumn, delQ, '-R+',Mcolumn,delQB,'--Bx');
set(h1,'linewidth',2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',7,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('Number of column','fontsize',7);
ylabel('Delay','fontsize',7);
legend('DelayQ','DelayQB','Location','NorthEast');
print(f1, '-depsc', 'Array_WDel/IMG/Array_WDelColumn.eps');

f2=figure(2);
h2=plot(Nrows, delQ, '-R+',Nrows,delQB,'--Bx');
set(h2,'linewidth',2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',7,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('Number of rows','fontsize',7);
ylabel('Delay','fontsize',7);
legend('DelayQ','DelayQB','Location','NorthWest');
print(f2, '-depsc', 'Array_WDel/IMG/Array_WDelRows.eps');
