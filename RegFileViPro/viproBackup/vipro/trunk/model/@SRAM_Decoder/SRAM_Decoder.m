%%%%%%%%%%%%%%%%%%%%%%
% Decoder class
% This includes the row-predecode, WL Driver, and col-decoder
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_Decoder < SRAM_Component
	properties

		%predecode buffer stages
		n=0;

		%wl driver buffer stages
		k=0;

	end % properties

	methods
        	% Constructor
        	function obj = SRAM_Decoder(toolPath,tasePath,uid)
			obj = obj@SRAM_Component(toolPath,tasePath,uid);
			chdir(strcat(toolPath,'/configuration'));
			user;
			if (exist('decStages'))
				obj.n=decStages(1);
				obj.k=decStages(2);
			end
			chdir(strcat(toolPath,'/model'));
        	end

		% Energy
		function energy = E(obj)			
			%row decoder
			if (obj.getMetrics == 1)			
				data = load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Decoder/output_',num2str(log2(obj.rows)),'.txt'));
				erowdec = data(5,5)*32e-9;
				energy = erowdec;
				obj.energy = energy;
			else
				if (obj.n ~=0 && obj.k ~=0)
					index = 3*obj.k+obj.n+1;
					numEntries = log2(512/obj.minRows)+1;
					temp = [];
					rows = num2str(log2(obj.minRows));
					for i=1:numEntries
						data = load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Decoder/output_',rows,'.txt'));
						temp = [temp;data(index,5)];
						rows = rows + 1;
					end
					energy = temp;
					obj.energy = energy;
				else
				end
			end
		end 
		
		% Delay - row predecode, WL Driver and FF delays
		function delay = D(obj)
			data = load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_DFF/data.txt'));
			ddff = data(1,2);

			if (obj.getMetrics == 1)
			
				data = load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Decoder/output_',num2str(log2(obj.rows)),'.txt'));
				drowdec = data(5,4);

				delay = drowdec+ddff;
				obj.delay = delay;
			else
                                if (obj.n ~=0 && obj.k ~=0)
                                        index = 3*obj.k+obj.n+1;
                                        numEntries = log2(512/obj.minRows)+1;
                                        temp = [];
					rows = num2str(log2(obj.minRows));
                                        for i=1:numEntries
                                                data = load(strcat(obj.tasePath,'/device/BIN/',obj.uid,'/RVP_Decoder/output_',rows,'.txt'));
                                                temp = [temp;data(index,4)+ddff];
						rows = rows + 1;
                                        end
                                        delay = temp;
                                        obj.delay= delay;
                                else
                                end
			end
		end
	end 
end % classdef
