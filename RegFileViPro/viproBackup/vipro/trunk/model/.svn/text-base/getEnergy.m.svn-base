% Get Energy per access for given SRAM configuration.  
% Usage: [energy eRd eWr] = getEnergy(toolPath,tasePath,uid)
% SRAM_Top object is instantiated to get energy per access

function [energy eRd eWr] = getEnergy(toolPath,tasePath,uid)

topInst = SRAM_Top(toolPath,tasePath,uid);

[eRd eWr] = topInst.E;

energy = max(eRd,eWr);
