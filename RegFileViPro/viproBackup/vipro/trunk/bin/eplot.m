function [] = eplot()

% Get data - Plot E-D Curve
load ./optOut_16k.dat;
optOut_16k=sortrows(optOut_16k,5);
delay = optOut_16k(:,5) * 1e9;
energy = optOut_16k(:,4) * 1e12;

% Get optimal points
minE = 10;
j = 1;
for i = 1:size(energy)
   e = energy(i);
   d = delay(i);

   if e < minE
      %fprintf('sss');
      del(j,1) = d;
      en(j,1) = e;
      minE =e;
      j=j+1;
   end	
   %fprintf('energy=%e, delay=%e\n',e,d);
end   

grid on;
plot(delay,energy,'x')
hold on;
plot(del,en,'--rs');
ylabel('Energy(pJ)');
xlabel('Delay(ns)');
title('Energy vs Delay 16K SRAM');
print(gcf, '-depsc', '16k_SRAM_E_D.eps');
%close(gcf);
%exit;             
