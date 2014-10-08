% function called by ViPro.pl to get E and D (Fmax) for a given
% configuration.
% Usage: [energy fmax] = getED(toolPath,tasePath,uid)
% This function in turn calls getEnergy and getDelay functions

function [energy fmax] = getED(toolPath,tasePath,uid)

fmax = getDelay(toolPath,tasePath,uid);
energy = getEnergy(toolPath,tasePath,uid);

% Write top-level metrics to a file. The following are determined
% Fmax
% Energy per access for read, wite, and average
fid = fopen('../files/topMetrics.txt','w');
fprintf(fid,'%e Hz\n%e J\n',fmax,energy);
fclose(fid);

exit;
