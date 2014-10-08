%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Col decoder and mux class
%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_CD < SRAM_Component
	properties
		% col-mux fet sizes
		wncs;
		lncs;
		wpcs;
		lpcs;
		
		% precharge sizes
		wpch;
		lpch;
		
	end
	
	methods
		% Constructor
        	function obj = SRAM_CD(toolPath,tasePath,uid)
			obj = obj@SRAM_Component(toolPath,tasePath,uid);
        	end
		
        	% Energy
		function energy = E(obj,wrt)
			if (wrt == 1)
                                load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_CD/dataw.txt'));
				energy = dataw(:,4);
			 	obj.energy = energy;
				%debug data
				dlmwrite(strcat(obj.toolPath,'/files/debugCDwrtEnergy.txt'),energy);
			else
                                load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_CD/datar.txt'));
				energy = datar(:,3);
				obj.energy = energy;
				%debug data
				dlmwrite(strcat(obj.toolPath,'/files/debugCDrdEnergy.txt'),energy);
			end

		end

		% Delay
		function delay = D(obj,wrt)
			if (wrt == 1)
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_CD/dataw.txt'));
				delay = dataw(:,2);
				obj.delay = delay;	
				%debug data
				dlmwrite(strcat(obj.toolPath,'/files/debugCDwrtDelay.txt'),delay);
			else
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_CD/datar.txt'));
				delay = datar(:,2);
				obj.delay = delay;
				%debug data
				dlmwrite(strcat(obj.toolPath,'/files/debugCDwrtDelay.txt'),delay);			
			end
		end 
	end 
end
