% top-level parameters
% rows and cols ignored if optimization is performed
technology = ibm45;
%wdef = 70e-9;
memSize = 8192;
rows = 512; 
banks = 1;
colMux = 1;
wordSize = 16;
vdd = 1.0;
%vsub = 1.0;
temp = 25;
% SAoffset=BL differential required for a read
SAoffset = .150;

% using ibm65 bitcell height and width - later get from cell generator
height = 0.34e-6;
width = 0.73e-6;

% interconnect metal 'cu' or 'al'
%globalMtl = cu;
%interMtl = cu;
%localMtl = cu;

% Optional Interconnect parameters in microns -[width spacing thickness height dielectric constant]. Replace '0' with the appropriate value below
%globalParams = [0 0 0 0 0];
%interParams = [0 0 0 0 0];
%localParams = [0 0 0 0 0];

%Get metrics for fixed configuration without optimization or run optimization? 1 - simply get metrics. 0- do optimization
%getMetrics = 0;

% Constraints - non-zero value indicates constraint. zero indicates minimization objective
energyConstraint = 0;
delayConstraint = 1e-9;

% Optimization knobs - fix some knobs to speed up optimization
% Default knob is NR, the number of rows
% Additional knobs currently include decoder stages and write driver size
% Comment out if all knobs are to be considered for optimization

% width of write driver in multiples of default/min width defined above
% choices - 2,4,8,16,24,32,40
wnio = 8;

% number of predecode and WL buffer stages
%decStages=[2,1];

tasePath = /var/home/plb3qt/scratch/plb3qt/TASE;

% Commands, either SWEEP, OPTIMIZE, CALCULATE
%SWEEP SAoffset 0.05 0.3 0.05 ./sweep.txt
%SWEEP PCratio 5 10 1 ./sweep_pcratio.txt
%SWEEP WLratio 1 4 1 ./sweep_wlratio.txt
OPTIMIZE OBJECTIVE 
	   ENERGY 0 
	   DELAY 1.15
         KNOBS 
	   NBANKS 1 16
	   NCOLS 1 8
	   NROWS 32 512
