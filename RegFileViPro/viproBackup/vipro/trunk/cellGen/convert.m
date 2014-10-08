% Matlab script to convert bitcell sizes from lamda values to absolute
% values
% Author: Satya Nalam

load 'cellGenOutput';
cd ../configuration/;
user;
cd ../cellGen;

switch (Node)
    case '180';
        lambda = 90e-9;
    case '130';
        lambda = 65e-9;
    case '90';
        lambda = 40e-9;
    case '65';
        lambda = 30e-9;
    case '45';
        lambda = 20e-9;
    case '32';
        lambda = 16e-9;
    case '22';
        lambda = 11e-9;
    case '16';
        lambda = 8e-9;
end

cellGenOutput = cellGenOutput*lambda;

lpg = cellGenOutput(1);
lpd = cellGenOutput(2);
lpu = cellGenOutput(3);
wpg = cellGenOutput(4);
wpd = cellGenOutput(5);
wpu = cellGenOutput(6);
H_BC = cellGenOutput(8);
W_BC = cellGenOutput(9);
I_cell = cellGenOutput(10);

fout = fopen('bitcellSizes.m','w');
fprintf(fout,'wpu = %e;\n',wpu);
fprintf(fout,'lpu = %e;\n',lpu);
fprintf(fout,'wpd = %e;\n',wpd);
fprintf(fout,'lpd = %e;\n',lpd);
fprintf(fout,'wpg = %e;\n',wpg);
fprintf(fout,'lpg = %e;\n',lpg);
fprintf(fout,'Bitcell_Height = %e;\n',H_BC);
fprintf(fout,'Bitcell_Width = %e;\n',W_BC);
fprintf(fout,'I_cell = %e;\n',I_cell);
fclose(fout);

exit;
