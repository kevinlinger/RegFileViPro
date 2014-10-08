%%%%%%%%%%%%%%
% This function calculates the interconnect resistance(Ohm/micron) and 
% capacitance(fF/micron) for the PTM models. Structure 2 model of the 
% interconnect is reproduced in this function. techNum is one of 
% (180,135,130,90,65,45,32,22), intcLevel is one of (g or G, l or L, i or I) for global,
% local and intermediate levels of interconnect respecitvely. metal is 
% "cu" or "al". Optional argument in the form of a vector [w s t h k] can be used to specify custom width(w), 
% spacing(s), thickness(t), height(h) or dielectric constant(k) to override 
% the defaults. If not all parameters are to be overridden, it should be zero. 
% 
% Examples:
% 1. InterconnectCap(90,'l','cu')
% gives the R and C  values for the local copper interconnect in 90 nm, 
% with the default values of the dimensions.
% 2. InterconnectCap(135,'G','al',[0 0 0.25 0.3 0])
% gives the R and C values for the global aluminium interconnect in 135 nm. 
% with the default values of w,s and k and with t = 0.25 micron and h = 0.3 micron
%%%%%%%%%%%%%%%

function [R_intc C_intc] = InterconnectCap(techNum,intcLevel, metal, varargin)

% default values of w,s,t,h and k for various techs and levels from PTM website

defaults(:,:,1) = [0.28	0.28  	0.45  	0.65  	3.5; 
		   0.35	0.35 	0.65 	0.65 	3.5; 
		   0.80	0.80 	1.25 	0.65 	3.5];

defaults(:,:,2) = [0.20	0.20  	0.45  	0.45  	3.2;  
		   0.28	0.28 	0.45 	0.45 	3.2; 
		   0.60	0.60 	1.20 	0.45 	3.2];

defaults(:,:,3) = [0.15	0.15  	0.30  	0.30  	2.8; 
		   0.20	0.20 	0.45 	0.30 	2.8; 
		   0.50	0.50 	1.20 	0.30 	2.8];

defaults(:,:,4) = [0.10	0.10  	0.20  	0.20  	2.2; 
 	    	   0.14	0.14 	0.35 	0.20 	2.2; 
		   0.45	0.45 	1.20 	0.20 	2.2];
       
defaults(:,:,5) = [0.07 0.07 0.18 0.18 2.2; 
                  0.1  0.1  0.31 0.18 2.2; 
                  0.32 0.32 1.08 0.18 2.2];
defaults(:,:,6) = [0.05 0.05 0.16 0.16 2.2;
		   0.07 0.07 0.28 0.16 2.2;
		   0.22 0.22 1.0 0.16 2.2];
defaults(:,:,7) = [0.04 0.04 0.15 0.15 2.2;
		   0.05 0.05 0.25 0.15 2.2;
		   0.15 0.15 0.9 0.9 2.2];

if techNum == 180
	tech = 1;
elseif (techNum == 135 || techNum == 130)
	tech = 2;
elseif techNum == 90
	tech = 3;
elseif techNum == 65
	tech = 4;
elseif techNum == 45
	tech = 5;
elseif (techNum == 32 || techNum == 28)
	tech = 6;
elseif techNum == 22
	tech = 7;
else
	return;
end

if (intcLevel == 'g' || intcLevel == 'G')
	level = 3;
elseif (intcLevel == 'i' || intcLevel == 'I')
        level = 2;
elseif (intcLevel == 'l' || intcLevel == 'L')
        level = 1;
else
	return;
end

params = defaults(level,:,tech);

if (nargin > 3)
	paramList = varargin{1};
	for i=1:1:5
		if (paramList(i) ~= 0)
			params(i) = paramList(i);
		end
	end
end

w = params(1);
s = params(2);
t = params(3);
h = params(4);
k = params(5);

if (metal == 'cu')
	rho = 2.2e-2;
else
	rho = 3.3e-2;
end

e0 = 8.85e-18;

% Calculate R and C using the equations in the PTM website for the specified parameters

R_intc = rho/(w*t);

C_g = k*e0*((w/h) + 2.04*((s/(s + 0.54*h))^1.77)*((t/(t + 4.53*h))^0.07));

C_c = k*e0*((1.14*(t/s)*exp(-4*s/(s + 8.01*h))) + 2.37*((w/(w + 0.31*s))^0.28)*((h/(h + 8.96*s))^0.76)*(exp(-2*s/(s + 6*h))));

C_intc = 2*(C_g + C_c);
