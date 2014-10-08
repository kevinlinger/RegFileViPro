%somehow strip 1st 3 lines of output.txt
load 'output.txt';
I = 1e-5;
W = 6;

%trim the matrices so that we can get average cap over VGS=0 to 1
[mindiff,index] = min(abs(output(:,2)-1))
output = output(1:index,:);
VGS = output(:,2);
dVGSdt = output(:,3);
C = I/dVGSdt;

plot(VGS,C);

%mean gate cap per micron
cap_gate = mean(C)/W;

%write data to file
fout = fopen('Cgate_N/modelParams.txt','w');
fprintf(fout,'%e\n',cap_gate);
fclose(fout);
