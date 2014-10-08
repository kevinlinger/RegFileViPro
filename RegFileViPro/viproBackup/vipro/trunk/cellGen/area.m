function area(cell_type,lambda)

%% MUDIT : Yet to be done:
%  1) Accurate formulas for other technologies


sizes = load('./range.init');
%info = load('temp.temp');
%cell_type = info(1);
%lambda = str2num(info(2));

% for indexing sizes
LPG=1;
LPD=2;
LPU=3;
WPG=4;
WPD=5;
WPU=6;

% All numbers in terms of LAMBDAS : Half-min L

if(lambda == 20)
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [3.6  5];         % Poly to poly distance
    poa     = [3.5  4.5];       % Poly extension over active
    a2n     = [2.25 4];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   4.5];       % Poly covering contact
    poc     = [-1   0.75];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.75 2.25];      % Contact to poly distance
    
end

if(lambda == 40) % These numbers are derived by extrapolating the 45nm numbers and DRC compliant rule numbers for 90nm
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [2.5  3.5];         % Poly to poly distance
    poa     = [2.7  3.5];       % Poly extension over active
    a2n     = [2.95 5.25];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   3.5];       % Poly covering contact
    poc     = [-1   0.25];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.36 1.75];      % Contact to poly distance
    
end

if(lambda == 90) % These numbers are derived by extrapolating the 45nm numbers and 90nm Assuming: 180nm->90nm->45nm by same factor
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [1.7  2.5];         % Poly to poly distance
    poa     = [2.1  2.7];       % Poly extension over active
    a2n     = [3.86 7.8];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   2.72];      % Poly covering contact
    poc     = [-1   0.10];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.05 1.36];      % Contact to poly distance
    
end

if(lambda == 65) % These numbers are derived by extrapolating the 45nm numbers and 90nm Assuming: 180nm->130nm->90nm->65nm->45nm by same factor
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [2.1  3.0];         % Poly to poly distance
    poa     = [2.4  3.1];       % Poly extension over active
    a2n     = [3.40 6.5];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   3.11];      % Poly covering contact
    poc     = [-1   0.15];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.20 1.56];      % Contact to poly distance
    
end

if(lambda == 30) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [3.05 4.25];         % Poly to poly distance
    poa     = [3.1  4.0];       % Poly extension over active
    a2n     = [2.60 4.63];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   4.0];       % Poly covering contact
    poc     = [-1   0.50];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.56 2.00];      % Contact to poly distance
    
end

if(lambda == 16) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [4.2  5.9];         % Poly to poly distance
    poa     = [4.1  5.0];       % Poly extension over active
    a2n     = [1.95 3.46];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   5.06];       % Poly covering contact
    poc     = [-1   1.10];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.96 2.53];      % Contact to poly distance
    
end

if(lambda == 11) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [4.9  6.96];         % Poly to poly distance
    poa     = [4.8  5.6];       % Poly extension over active
    a2n     = [1.69 3];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   5.7];       % Poly covering contact
    poc     = [-1   1.61];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [2.19 2.84];      % Contact to poly distance
    
end

if(lambda == 8) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [5.7  8.21];         % Poly to poly distance
    poa     = [5.6  6.25];       % Poly extension over active
    a2n     = [1.46 2.6];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   6.4];       % Poly covering contact
    poc     = [-1   2.35];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [2.44 3.19];      % Contact to poly distance
    
end

%% Most likely scenarios

% subDRC cell : Width governed by WPD and WPU (and not WPG) 
MCW0(:,1) = 2*(p2p(1)/2 + poa(1) + sizes(:,WPD) + 2*a2n(1) + sizes(:,WPU) + a2a(1)/2);
% DRC compliant cell: Width governed by WPD and WPU (and not WPG)
MCW0(:,2) = 2*(p2p(2)/2 + poa(2) + sizes(:,WPD) + 2*a2n(2) + sizes(:,WPU) + a2a(2)/2);

% subDRC cell: Height is governed by the NMOS stack (not the PMOS - mainly because of shared contacts)
MCH0(:,1) = cw(1)/2 + c2p(1) + sizes(:,LPD) + c2p(1) + cw(1) + c2p(1) + sizes(:,LPG) + cw(1)/2 + c2p(1);
% DRC compliant cell: Height governed by the PMOS stack in the center
MCH0(:,2) = p2p(2)/2 + pcc(2) - poc(2) + c2c(2) + cw(2) + c2p(2) + sizes(:,LPU) + c2p(2) + cw(2)/2;

% The following scenarios are unlikely to be chosen in a final cell, but need to be 
% considered for the generic bitcell generator/optimizer

% subDRC cell: Width governed by large WPG. 
%   Slightly tricky: As the PG increases, the poly over it nears the poly over the shared contact.
%   Both are equally strainted, when WPD-WPG=w1_pd_pg=60n for 45nm cell
w1_pd_pg_subDRC = 60/lambda;
MCW1(:,1) = MCW0(:,1) + 2* (sizes(:,WPG) - sizes(:,WPD) + w1_pd_pg_subDRC);

w1_pd_pg_DRC = 15/lambda;
MCW1(:,2) = MCW0(:,2) + 2* (sizes(:,WPG) - sizes(:,WPD) + w1_pd_pg_DRC);

% subDRC cell: Height governed by PMOS stack in the center
% Because of the shared contacts, a exact dimension IF the height is govened by PU is not exact.
% Defining height as: cw/2 + c2p + LPU + abp (active between polys) + LPU + c2p + cw/2

abp_subDRC = 120/lambda;    % Active between poly
MCH1(:,1) = cw(1)/2 + c2p(1) + sizes(:,LPU) + abp_subDRC + sizes(:,LPU) + c2p(1) + cw(1)/2;

% DRC cell : Governed by the PG/PD stack. Listed below from top to bot - 
MCH1(:,2) = cw(2)/2 + c2p(2) + sizes(:,LPD) + c2p(2) + cw(2) + c2p(2) + sizes(:,LPG) + c2p(2) + cw(2)/2;

% Max of sub-DRC calculations
flag = MCH0(:,1) >= MCH1(:,1);
MCH(:,1) = MCH0(:,1) .* flag + MCH1(:,1) .* (1-flag);
flag = MCW0(:,1) >= MCW1(:,1);
MCW(:,1) = MCW0(:,1) .* flag + MCW1(:,1) .* (1-flag);

% Max of DRC calculations
flag = MCH0(:,2) >= MCH1(:,2);
MCH(:,2) = MCH0(:,2) .* flag + MCH1(:,2) .* (1-flag);
flag = MCW0(:,2) >= MCW1(:,2);
MCW(:,2) = MCW0(:,2) .* flag + MCW1(:,2) .* (1-flag);



file_w = fopen('w_results','w');
file_h = fopen('h_results','w');


if(strcmpi(cell_type,'subDRC'))
    a = MCH(:,1).*MCW(:,1);
    fprintf(file_w,'%5.3f\n',MCW(:,1));
    fprintf(file_h,'%5.3f\n',MCH(:,1));
elseif(strcmpi(cell_type,'DRC'))
    a = MCH(:,2).*MCW(:,2);
    fprintf(file_w,'%5.3f\n',MCW(:,2));
    fprintf(file_h,'%5.3f\n',MCH(:,2));
elseif(strcmpi(cell_type,'Xreg'))
    a = 0 .*MCH(:,1);
end

file1 = fopen('area_results','w');
fprintf(file1,'%5.3f \n',a);
fclose(file1);
fclose(file_w);
fclose(file_h);

end
