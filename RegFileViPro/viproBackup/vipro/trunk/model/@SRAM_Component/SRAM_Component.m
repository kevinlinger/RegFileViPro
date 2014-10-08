%%%%%%%%%%%%%%%
% This is the parent class of all SRAM component classes. It contains global attributes such as global FoMs, VDD, technology specs etc. Each component of the SRAM at each level of the hierarchy is represented by an inherited class which includes, in addtition to the the inherited parameters, some local parameters such as capacitances, offsets, currents etc.
%%%%%%%%%%%%%%%

classdef SRAM_Component < handle
	properties
		uid;
		technology;
		memSize;
		delay;
		energy;
		wrt;		
		toolPath;
		tasePath;
		rows;
		cols;
		wordSize;
		numWords;
		minRows;
		vdd;
		vsub;
		temp;
		getMetrics;
		
		% interconnect
		globalParams;
		interParams;
		localParams;
		globalMtl;
		interMtl;
		localMtl;
		
		% bitcell
		wpu;
		lpu;
		wpd;
		lpd;
		wpg;
		lpg;
		
		%wrt driver
		wnio;
	end 

	methods
        % Super-class constructor
		function obj = SRAM_Component(toolPath,tasePath,uid)
			obj.toolPath = toolPath;
			obj.tasePath = tasePath;
			obj.uid = uid;

			chdir(strcat(toolPath,'/configuration'));
			user;
			bitcellSizes;
			chdir(strcat(toolPath,'/model'));

			obj.technology = technology;
			obj.memSize = memSize;
			obj.rows = rows;
			obj.cols = cols;
			obj.wordSize = wordSize;
			obj.numWords = obj.memSize/obj.wordSize;
			obj.minRows = max(obj.numWords/8,8);
			obj.vdd = vdd;
			obj.vsub = vsub;
			obj.temp = temp;

			obj.wpu = wpu;
			obj.lpu = lpu;
			obj.wpd = wpd;
			obj.lpd = lpd;
			obj.wpg = wpg;
			obj.lpg = lpg;
			
			obj.globalParams = globalParams;
			obj.interParams = interParams;
			obj.localParams = localParams;
			obj.globalMtl = globalMtl;
			obj.interMtl = interMtl;
			obj.localMtl = localMtl;
			
			obj.getMetrics = getMetrics;	
			
			if (exist('wnio'))
				obj.wnio=wnio;
			end						
		end
	end 
end 
