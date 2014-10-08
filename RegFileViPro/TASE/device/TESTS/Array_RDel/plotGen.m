%%Delay for Array Read
load ('Array_RDel/OUT/delayRows64.txt');
load ('Array_RDel/OUT/delayRows128.txt');
load ('Array_RDel/OUT/delayRows256.txt');
load ('Array_RDel/OUT/delayRows512.txt');
load ('Array_RDel/OUT/delayRows1024.txt');

NR = [64 128 256 512 1024];
NC = (2^16)./(16*NC);

%Simulation
T64 = delayRows64(:,1);
T128 = delayRows128(:,1);
T256 = delayRows256(:,1);
T512 = delayRows512(:,1);
T1024 = delayRows1024(:,1);

%start of bitline
aBL64 = delayRows64(:,2);
aBL128 = delayRows128(:,2);
aBL256 = delayRows256(:,2);
aBL512 = delayRows512(:,2);
aBL1024 = delayRows1024(:,2);

aBLB64 = delayRows64(:,3);
aBLB128 = delayRows128(:,3);
aBLB256 = delayRows256(:,3);
aBLB512 = delayRows512(:,3);
aBLB1024 = delayRows1024(:,3);

%end of bitline
BL64 = delayRows64(:,4);
BL128 = delayRows128(:,4);
BL256 = delayRows256(:,4);
BL512 = delayRows512(:,4);
BL1024 = delayRows1024(:,4);

BLB64 = delayRows64(:,5);
BLB128 = delayRows128(:,5);
BLB256 = delayRows256(:,5);
BLB512 = delayRows512(:,5);
BLB1024 = delayRows1024(:,5);

C64 = size(T64,1);
C128 = size(T128,1);
C256 = size(T256,1);
C512 = size(T512,1);
C1024 = size(T1024,1);


ft64=0;
for i = C64:-1:1
    d64=BL64(i)-BLB64(i);
    if (d64>0.1)
        ft64 = T64(i);
    end
    
    ad64=aBL64(i)-aBLB64(i);
    if (ad64>0.1)
        aft64 = T64(i);
    end
end

ft128=0;
for i = C128:-1:1
    d128=BL128(i)-BLB128(i);
    if (d128>0.1)
        ft128 = T128(i);
    end
    ad128=aBL128(i)-aBLB128(i);
    if (ad128>0.1)
        aft128 = T128(i);
    end
end

ft256=0;
for i = C256:-1:1
    d256=BL256(i)-BLB256(i);
    if (d256>0.1)
        ft256 = T256(i);
    end
    ad256=aBL256(i)-aBLB256(i);
    if (ad256>0.1)
        aft256 = T256(i);
    end
end

ft512=0;
for i = C512:-1:1
    d512=BL512(i)-BLB512(i);
    if (d512>0.1)
        ft512 = T512(i);
    end
    ad512=aBL512(i)-aBLB512(i);
    if (ad512>0.1)
        aft512 = T512(i);
    end
end

ft1024=0;
for i = C1024:-1:1
    d1024=BL1024(i)-BLB1024(i);
    if (d1024>0.1)
        ft1024 = T1024(i);
        a=i;
    end
    ad1024=aBL1024(i)-aBLB1024(i);
    if (ad1024>0.1)
        aft1024 = T1024(i);
    end
end

% 50ps delay + 0.5*100ps risetime
Del = [ft64 ft128 ft256 ft512 ft1024]-1*10^-10;
aDel = [aft64 aft128 aft256 aft512 aft1024]-1*10^-10;
diff = Del - aDel;

f1=figure(1);
h1=plot(NR, Del, '-.g*');
set(h1,'linewidth',2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',7,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('Number of rows','fontsize',7);
ylabel('Delay','fontsize',7);
legend('Sim','Location','NorthWest');
print(f1, '-depsc', 'Array_RDel/IMG/Array_RDelRows.eps');
close(f1);


f2=figure(2);
h2=plot(NC, Del, '-.g*');
set(h2,'linewidth',2);
set(gcf,'PaperPosition',[0 0 3.5 3]);
set(gca,'fontsize',7,'fontweight','bold','xgrid','on','ygrid','on');
xlabel('Number of columns','fontsize',7);
ylabel('Delay','fontsize',7);
legend('Sim','Location','NorthWest');
print(f2, '-depsc', 'Array_RDel/IMG/Array_RDelColumns.eps');
close(f2);
