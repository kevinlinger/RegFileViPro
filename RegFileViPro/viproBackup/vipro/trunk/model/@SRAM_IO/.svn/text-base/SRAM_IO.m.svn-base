%%%%%%%%%%%%%%%%%%%%%%
% Write Circuit class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_IO < SRAM_Component
	properties

	end
	
	methods
		% Constructor
        	function obj = SRAM_IO(toolPath,tasePath,uid)
			obj = obj@SRAM_Component(toolPath,tasePath,uid);
        	end
		
        	% Energy
		function energy = E(obj,wrt)
		
			if (wrt == 1)
				load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_IO/dataw.txt'));
				if (obj.getMetrics == 1)
					energy = dataw(:,3);
					obj.energy = energy;
				else 
					if (obj.wnio ~= 0)
						[minDiff, index] = min(abs(dataw(:,1)-obj.wnio));
						energy = dataw(index,3);
						temp = [];
						numEntries = log2(512/obj.minRows)+1;
						for i=1:numEntries
							temp = [temp;energy];
						end
						energy = temp;
						obj.energy = energy;
						%debug data
						dlmwrite(strcat(obj.toolPath,'/files/debugIOwrtEnergy.txt'),energy);
					else
						energy = dataw(:,3);
						obj.energy = energy;
					end
				end
			else
				load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_IO/datar.txt'));
                                if (obj.getMetrics == 1)
                                        energy = datar(:,3);
                                        obj.energy = energy;
                                else
					if (obj.wnio ~= 0)
						[minDiff, index] = min(abs(datar(:,1)-obj.wnio));
						energy = datar(index,3);
						temp = [];
						numEntries = log2(512/obj.minRows)+1;
						for i=1:numEntries
							temp = [temp;energy];
						end
						energy = temp;
						obj.energy = energy;
						%debug data
						dlmwrite(strcat(obj.toolPath,'/files/debugIOrdEnergy.txt'),energy);
					else
						energy = datar(:,3);
						obj.energy = energy;
					end
				end
			end
		end

		% Delay
		function delay = D(obj,wrt)
			if (wrt == 1)
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_IO/dataw.txt'));
				if (obj.getMetrics == 1)
					delay = dataw(:,2);
					obj.delay = delay;
				else
					if (obj.wnio ~=0)
						[minDiff, index] = min(abs(dataw(:,1)-obj.wnio));
						delay = dataw(index,2);
						temp = [];
						numEntries = log2(512/obj.minRows)+1;
						for i=1:numEntries
							temp = [temp;delay];
						end
						delay = temp;
						obj.delay = delay;
						
						%debug data
						dlmwrite(strcat(obj.toolPath,'/files/debugIOwrtDelay.txt'),delay);
					else
						delay = dataw(:,2);
						obj.delay = delay;
					end
				end
			else
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_IO/datar.txt'));
				if (obj.getMetrics == 1)
					delay = datar(:,2);
					obj.delay = delay;
				else
					if (obj.wnio ~=0)
						[minDiff, index] = min(abs(datar(:,1)-obj.wnio));
						delay = datar(index,2);
						temp = [];
						numEntries = log2(512/obj.minRows)+1;
						for i=1:numEntries
							temp = [temp;delay];
						end
						delay = temp;
						obj.delay = delay;
						
						%debug data
						dlmwrite(strcat(obj.toolPath,'/files/debugIOrdDelay.txt'),delay);
					else
						delay = datar(:,2);
						obj.delay = delay;
					end
				end
			end
		end 
	end 
end
