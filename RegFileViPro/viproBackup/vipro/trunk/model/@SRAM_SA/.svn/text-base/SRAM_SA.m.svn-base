%%%%%%%%%%%%%%%%%%%%%%
% SA class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_SA < SRAM_Component
	properties
		%footer device
		wen;
		len;
		
		%equalize device
		weql;
		leql;

		% cross coupled devices
		wpsa;
		lpsa;
		wnsa;
		lnsa;
		
		%input devices
		wbl;
		lbl;
		
		%precharge devices
		wsapc;
		lsapc;
	end
	
	methods
		% Constructor
        	function obj = SRAM_SA(toolPath,tasePath,uid)
			obj = obj@SRAM_Component(toolPath,tasePath,uid);
        	end
		
        	% Energy
		function energy = E(obj,wrt)
			if (wrt == 1)
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_SA/dataw.txt'));
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
						dlmwrite(strcat(obj.toolPath,'/files/debugSAwrtEnergy.txt'),energy);
					else
						energy = dataw(:,3);
						obj.energy = energy;
					end
				end
			else
				load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_SA/datar.txt'));
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
                                                dlmwrite(strcat(obj.toolPath,'/files/debugSArdEnergy.txt'),energy);
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
	        		load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_SA/dataw.txt'));
				if (obj.getMetrics == 1)
					delay = dataw(:,2);
                                        obj.delay = delay;
				else
					if (obj.wnio ~= 0)
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
						dlmwrite(strcat(obj.toolPath,'/files/debugSAwrtDelay.txt'),delay);
					else
						delay = dataw(:,2);
						obj.delay = delay;
					end
				end
			else
				load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_SA/datar.txt'));
				if (obj.getMetrics == 1)
					delay = datar(:,2);
					obj.delay = delay;	
				else
					if (obj.wnio ~= 0)
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
                                                dlmwrite(strcat(obj.toolPath,'/files/debugSArdDelay.txt'),delay);
                                        else
						delay = datar(:,2);
                                                obj.delay = delay;
					end
				end
			end
		end 
	end 
end
