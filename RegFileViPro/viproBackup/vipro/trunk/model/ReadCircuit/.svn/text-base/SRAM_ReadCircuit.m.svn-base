%%%%%%%%%%%%%%%%%%%%%%
% Read Circuit class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_ReadCircuit< SRAM_Component
	properties
		VDDPCH;
		deltaVBL;

		Wpch;
		Weq;

		Wtxp;
		Wtxn;

		Wwr;
		
		Wsa;

		% inverter dimensions
		Wp_inv;
		Wn_inv;

		% nand dimensions
		Wp_nand;
		Wn_nand;

		% bitcell passgate dimensions
		Wpg;
		Lpg;
		
		% pmos eq resistance for delay calculation - different from Reqp in
		% write circuit as voltage range is different
		Reqp;

	end % properties

	methods
        
        % Constructor
        function obj = SRAM_ReadCircuit(wr,rows,cols)
            obj = obj@SRAM_Component(wr,rows,cols);
            constructor;
            obj.Wpg = wpg*1e6;
            obj.Lpg = lpg*1e6;
            
            obj.autoSelect = selectOptions{4,2}(1,1);
            obj.fixedComponent = selectOptions{4,3}(1,1);
            obj.templateName = selectOptions{4,4};
            obj.bbEstimate = selectOptions{4,5};
            if (obj.bbEstimate == 1)
                obj.Energy = selectOptions{4,6}(1,1);
                obj.Delay = selectOptions{4,6}(1,2);
            end
            obj.userModel = selectOptions{4,7};
            if (obj.userModel == 1)
                obj.Energy = selectOptions{4,8};
                obj.Delay = selectOptions{4,9};
            end

            obj.VDDPCH = V_DD;
            obj.deltaVBL = 0.2;

            obj.Wpch = (5/0.04)*obj.lambda;
            obj.Weq = (5/0.04)*obj.lambda;

            obj.Wtxp = (0.48/0.04)*obj.lambda;
            obj.Wtxn = (0.48/0.04)*obj.lambda;

            obj.Wwr = (5/0.04)*obj.lambda;

            obj.Wsa = (0.2/0.04)*obj.lambda;

            obj.Wp_inv = (1/0.04)*obj.lambda;
            obj.Wn_inv = (0.6/0.04)*obj.lambda;

            obj.Wp_nand = (0.6/0.04)*obj.lambda;
            obj.Wn_nand = (0.6/0.04)*obj.lambda;
            
            obj.Reqp = 1e6*obj.deltaVBL/obj.Wpch*Ion_P(1,3);
        end
           
        % Energy
        function obj = E(obj)
          E@SRAM_Component(obj,'ReadCircuit',obj.templateName); 
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1 && obj.bbEstimate ~=1 && obj.userModel ~=1 )
              %Cap_Intc = obj.cap_metal_int*obj.NR*obj.H_BC;
              %Cap_BL = obj.Wpch*obj.L*obj.cap_junction + obj.Weq*obj.L*obj.cap_junction + obj.NR*obj.Wpg*obj.Lpg*obj.cap_junction + 2*(obj.Wtxp + obj.Wtxn)*obj.L*obj.cap_junction + obj.Wwr*obj.L*obj.cap_junction + obj.Wsa*obj.L*obj.cap_junction + Cap_Intc;
              % During Precharge of BL and BLB. 
              [Cap_BL wwr wpch] = capBL(obj.cap_metal_int,obj.cap_junction,obj.cap_gate,obj.NR,obj.NC,obj.tech);

              E_pch = obj.VDDPCH*obj.deltaVBL*Cap_BL;

              % Pull down of either BL or BLB.
              % MB : deltaVBLnom ~ 200mV such that the wc (nom-4or5 sigmas) is > ~50mV
              % We should then use the nominal value of deltaVBL
              E_Rd = obj.VDDPCH*obj.deltaVBL*Cap_BL;

              % Total Energy for the array;
              obj.Energy = obj.NC*E_pch + (obj.NC)/(obj.col_mux)*E_Rd;
          end
        end % Energy
		
		% Delay
		function obj = D(obj)
          D@SRAM_Component(obj,'ReadCircuit',obj.templateName); 
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1 && obj.bbEstimate ~=1 && obj.userModel ~=1)
              [Cap_BL wwr wpch] = capBL(obj.cap_metal_int,obj.cap_junction,obj.cap_gate,obj.NR,obj.NC,obj.tech);
              %Cap_BL = obj.Wpch*obj.L*obj.cap_junction + obj.Weq*obj.L*obj.cap_junction + obj.NR*obj.Wpg*obj.Lpg*obj.cap_junction + 2*(obj.Wtxp + obj.Wtxn)*obj.L*obj.cap_junction + obj.Wwr*obj.L*obj.cap_junction + obj.Wsa*obj.L*obj.cap_junction;
              obj.Delay = 0.69*obj.Reqp*Cap_BL;	
          end
		end % Delay
	end % methods
end % classdef
