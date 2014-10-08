%%%%%%%%%%%%%%%%%%%%%%
% Bitcell class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_Bitcell < SRAM_Component
	properties

	end

	methods 

	% Constructor
        	function obj = SRAM_Bitcell(toolPath,tasePath,uid)
			obj = obj@SRAM_Component(toolPath,tasePath,uid);
        	end      

        % Energy
        	function energy = E(obj,wrt)
			if (wrt == 1)
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_CD/dataw.txt'));
				energy = dataw(:,5);
				obj.energy = energy;
				%debug data
				dlmwrite(strcat(obj.toolPath,'/files/debugBCwrtEnergy.txt'),energy);

			else
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_CD/datar.txt'));
				energy = datar(:,4);
				obj.energy = energy;
				%debug data
				dlmwrite(strcat(obj.toolPath,'/files/debugBCrdEnergy.txt'),energy);				
			end
       		end
        % Delay
	        function delay = D(obj)
			load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_CD/dataw.txt'));
			delay = dataw(:,3);
			obj.delay = delay;
			%debug data
			dlmwrite(strcat(obj.toolPath,'/files/debugBCdly.txt'),delay);
        	end
     	end
end
