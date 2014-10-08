% Get Fmax for given SRAM configuration.  
% Will be determined by slower operation, usually read.
% Usage: [fmax fmaxRd fmaxWr] = getDelay(toolPath,tasePath,uid)
% A SRAM_Top object is instantiated and tmin is determined first, which is then used to determine fmax

function [fmax fmaxRd fmaxWr] = getDelay(toolPath,tasePath,uid)

topInst = SRAM_Top(toolPath,tasePath,uid);

[tminRd tminWr] = topInst.D;

tmin = max(tminRd, tminWr);

fmax = 1/tmin;
fmaxRd = 1/tminRd;
fmaxWr = 1/tminWr;

