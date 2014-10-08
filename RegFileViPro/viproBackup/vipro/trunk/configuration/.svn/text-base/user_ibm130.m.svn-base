% top-level parameters
% rows and cols ignored if optimization is performed
technology = 'ibm130';
wdef = 160e-9;
memSize = 8192;
rows = 512; 
cols = 16;
arbits = 9;
acbits = 0;
wordSize = 16;
vdd = 1.2;
vsub = 1.2;
temp = 25;

%Get metrics for fixed configuration without optimization or run optimization? 1 - simply get metrics. 0- do optimization
getMetrics = 1;

% Constraints - non-zero value indicates constraint. zero indicates minimization objective
energyConstraint = 0;
delayConstraint = 2e-9;

% Optimization knobs - fix some knobs to speed up optimization
% Default knob is NR, the number of rows
% Additional knobs currently include decoder stages and write driver size
% Comment out if all knobs are to be considered for optimization

% width of write driver in multiples of default/min width defined above
% choices - 2,4,8,16,24,32,40
wnio = 8;

% number of predecode and WL buffer stages
decStages=[2,1];

% using ibm65 bitcell height and width - later get from cell generator
height = 0.68e-6;
width = 1.46e-6;

% interconnect metal 'cu' or 'al'
globalMtl = 'cu';
interMtl = 'cu';
localMtl = 'cu';

% Optional Interconnect parameters in microns -[width spacing thickness height dielectric constant]. Replace '0' with the appropriate value below
globalParams = [0 0 0 0 0];
interParams = [0 0 0 0 0];
localParams = [0 0 0 0 0];
