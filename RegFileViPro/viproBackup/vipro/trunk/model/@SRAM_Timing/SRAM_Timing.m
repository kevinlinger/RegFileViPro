%%%%%%%%%%%%%%%%%%%%%%
% Timing class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_Timing < SRAM_Component

	methods  
	% Constructor
        function obj = SRAM_Timing(toolPath,tasePath,uid)
		obj = obj@SRAM_Component(toolPath,tasePath,uid);
        end

        % Energy
	        function energy = E(obj)
			load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_TIMING/data.txt'));
			energy_fixed = data(:,1);
			
			%load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_bufChains/data.txt'));
			%energy_buf = sum(data,2);
			
			% flip matrix upside down so the column mux corresponds to ascending order of rows. Earlier column mux was ascending, so corresponds to desceding rows
			energy = flipud(energy_fixed);
			obj.energy = energy;
        	end
     	end
end
