%%%%%%%%%%%%%%
% This function first determines the number of stages for a buffer chain for a fanout of 4.
% Next, it determines the new fanout (>4) if the number of stages is one less than that required
% with a fanout of 4. This will save a bit of energy at the expense of a bit of delay.
% Maybe later another parameter can be added so that the reduction in number of stages is a user
% parameter rather than fixed at 1, so that a wider design space exploration can be done by the user
% This buffer chain sizing is done for the buffers in the timing block driving the horizontal
% control signals. The sizes and fanouts are determined for the four possible values of NC 
% given the word size
%
% The inputs to the function are as follows:
% toolPath = Top-level tool path
% memSize = memory capacity
% ws = word size
% cwl = metal cap per cell width
% cbl = metal cap per cell height
% cg = gate cap per micron
% wdef = min/default transistor width
% PMOS is assumed twice the size as NMOS in the buffer chain
%
% The outputs are as follows:
% f = Modified fanout of each stage is number of stages is one less than what is recommended by Fo4.
% n = number of stages required for Fo4.
% caps = The control signal caps
%
% Example:
% [f n cap] = bufChainOpt('/scratch/svn2u/ViPro_release/trunk',16384,1.9435091e-16,8.3720392e-17,6.597222e-16,0.2e-6)
%%%%%%%%%%%%%%%

function [f n caps] = bufChainOpt(toolPath,memSize,ws,cwl,cbl,cg,wdef)

%cg = 6.547619e-16
fid1 = fopen(strcat(toolPath,'/files/ctrlBufChains_f.txt'),'w');
fid2 = fopen(strcat(toolPath,'/files/ctrlBufChains_n.txt'),'w');

for i=1:4
	NC = 2^(i-1)*ws;
	%2 N or PMOS pass gates of width 6*wdef per output bit
	cap_CMUX = NC*cwl+2*ws*6*wdef*cg*1e6;

	% 3 Precharge and equalize transistors all of width 6*wdef per column
	cap_PCH = 3*NC*6*wdef*cg*1e6+NC*cwl;

	% 2 SA precharge transistors of width 5*wdef
	cap_SAPCH = NC*cwl+2*5*wdef*cg*1e6*ws;

	% 6 PMOS and one NMOS transistors in the SA
	cap_SAE = NC*cwl+7*wdef*cg*1e6*ws;

	% Input devices adding upto 4.95*wdef in I/O FFs
	%cap_CLK = NC*cwl + 2*ws*5*wdef*cg*1e6;

	% One 4x-inverter per output bit
	cap_WEN = NC*cwl + ws*4*wdef*cg*1e6;

	% Normalize to capacitance of min-inverter
	caps = [cap_CMUX cap_PCH cap_SAPCH cap_SAE cap_WEN]/(3*wdef*cg*1e6);

	f=[];
	n=[];

	for i=1:5
		n(i) = ceil((log2(caps(i))/2)); %rounded no: of stages with Fo4
		f(i) = caps(i)^(1/(n(i)-1)); %determine fanout with one less stage
	end

	% If number of stages is less than 2, reset it to 2 and fanout to 4
	for i=1:5	
		if (n(i)<3)
			n(i) = 2;
			f(i) = 4;
		end
	end

fprintf(fid1, '%1.2f\t%1.2f\t%1.2f\t%1.2f\t%1.2f\n', f);
fprintf(fid2, '%d\t%d\t%d\t%d\t%d\n', n);
end

fclose(fid1);
fclose(fid2);
exit;
