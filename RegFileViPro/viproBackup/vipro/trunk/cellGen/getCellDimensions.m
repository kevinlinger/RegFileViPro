% Matlab script to call area function if user-specified bitcell is used and
% to write the calculated height and width into the calcParams.m file

% load bitcell sizes and user configuration
bitcellSizes;
user;

% get lambda
switch (Node)
    case '180';
        lambda = 90;
    case '130';
        lambda = 65;
    case '90';
        lambda = 40;
    case '65';
        lambda = 30;
    case '45';
        lambda = 20;
    case '32';
        lambda = 16;
    case '22';
        lambda = 11;
    case '16';
        lambda = 8;
end

LPG = 1e9*lpg/lambda;
LPD = 1e9*lpd/lambda;
LPU = 1e9*lpu/lambda;
WPG = 1e9*wpg/lambda;
WPD = 1e9*wpd/lambda;
WPU = 1e9*wpu/lambda;

% open file to write sizes in format required by area.m
fid = fopen('range.init','w');
fprintf(fid,'%e\t%e\t%e\t%e\t%e\t%e\t',LPG, LPD, LPU, WPG, WPD, WPU);
fclose(fid);

% use area function to calculate cell dimensions
area(Cell_Type,lambda);
h = load('h_results');
w = load('w_results');

% write cell dimensions to calcParams.m
fid = fopen('../configuration/calcParams.m','a');
fprintf(fid,'Bitcell_Height = %e;\nBitcell_Width = %e;\n', h*lambda*1e-9, w*lambda*1e-9);
fclose(fid);

exit;
