% Run this script after running RVP.csh with atleast the characterizer
% flag set to get data about WL cap.

% Get wpg, Cgate and W_BC from RVP output.
constructor;

numCells = [8 16 32 64 128 256 512];
capMetalInt = InterconnectCap(90,'i','cu',[0 0 0 0 0]);

%WLCapInt = capWL(numCells, wpg, capMetalInt*1e15, Gate_Capacitance*1e15, Bitcell_Width*1e6);

% Write WL cap data to a file
numCells = [8 16 32 64 128 256 512];
data = [numCells ; capWL(numCells, wpg, capMetalInt*1e15, Gate_Capacitance*1e15, Bitcell_Width*1e6)];

fid = fopen('WLCap.txt','w');
fprintf(fid,'%d\t%4.2f\n',data);
fclose(fid);