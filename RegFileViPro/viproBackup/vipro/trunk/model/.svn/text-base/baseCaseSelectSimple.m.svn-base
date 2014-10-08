function baseCaseSelectSimple()

% load params
constructor;

% sweep delay constraint to get points on the optimal E-D curve
% sweep space hard-coded from 0.3ns to 3ns.
dcon = 0.3;
delete('output.txt');
delete('baseCase.txt');

while (dcon <= 3)
    %optimizeBruteForce(0, dcon*1e-9);
    optimizeBruteForce1(0, dcon*1e-9);
    dcon = dcon+0.05;
end

% Get unique points from those generated in the sweep above
out = load('output.txt');
unqPts = unique(out(:,2:5),'rows');
numSolns = size(unqPts,1);
fout = fopen('baseCase.txt','a');

% Simple algorithm to select high-performance and low-power configurations:
% For high performance, select the configuration just before the half-way
% point of the E-D curve points, and for low power select the one just
% after the half-way point.
if (strcmp(SRAM_USP, 'lp'))
    %baseCaseIndex = ceil(numSolns/2) + 1;
    baseCaseIndex = numSolns;
elseif (strcmp(SRAM_USP, 'hp'))
    %baseCaseIndex = fix(numSolns/2);
    baseCaseIndex = 1;
elseif (strcmp(SRAM_USP, 'gp'))
    baseCaseIndex = fix(numSolns/2);
end

fprintf(fout,'%d\t%d\t%e\t%e\n',unqPts(baseCaseIndex,:));
fclose(fout);
