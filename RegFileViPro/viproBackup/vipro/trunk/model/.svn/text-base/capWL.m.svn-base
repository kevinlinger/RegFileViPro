%%%%%%%%%%%%%%
% This function calculates the WL capacitance. The arguments are No: of
% cells on a WL, width of passgate, parasitic metal cap and gate cap (fF/u)
% and width of the bitcell. Output is WL capacitance in fF
%%%%%%%%%%%%%%%

function [WLCap] = capWL(numCells, wpg,lpg, capMetal, Cgate, W_BC)

Ccells = numCells*2*Cgate*wpg*lpg;
Cmetal = numCells*capMetal*W_BC;

WLCap = Ccells + Cmetal;