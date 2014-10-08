%%%%%%%%%%%%%%%%%%%%%%
% WL Driver Class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_WLDriver < SRAM_Component
	properties
		% inverter dimensions
		Wp_inv1;
		Wn_inv1;

		Wp_inv2;
        Wn_inv2;

		Wp_inv3;
        Wn_inv3;
		
		% nand dimensions
		Wp_nand;
		Wn_nand;

		% bitcell passgate dimensions
		Wpg;
        Lpg

		% accurate in the eventual model.
		WL_DRIVER_WIDTH;

		% parasitic delays - need to make more accurate later
		p_nand = 2;
		p_inv1 = 2/25;
		p_inv2 = 2/100;
		p_inv3 = 2/500;
        
%         p_nand = 120/7;
%         p_inv1 = 25/7;
%         p_inv2 = 100/7;
%         p_inv3 = 400/7;
        
        % VDD WL,separated from nominal VDD to accomodate assist methods
        % such as WL boosting for write and drooping for read
        VDDWL;

	end % properties

	methods
        
        % Constructor
        function obj = SRAM_WLDriver(wr,rows,cols)
            obj = obj@SRAM_Component(wr,rows,cols);
            constructor;
                     
            obj.autoSelect = selectOptions{6,2}(1,1);
            obj.fixedComponent = selectOptions{6,3}(1,1);
            obj.templateName = selectOptions{6,4};
            obj.bbEstimate = selectOptions{6,5};
            if (obj.bbEstimate == 1)
                obj.Energy = selectOptions{6,6}(1,1);
                obj.Delay = selectOptions{6,6}(1,2);
            end
            obj.userModel = selectOptions{6,7};
            if (obj.userModel == 1)
                obj.Energy = selectOptions{6,8};
                obj.Delay = selectOptions{6,9};
            end
            
            % use boosted WL voltage only for write and if assist is being
            % used
            if (wr == 1 && obj.fixedComponent == 1)
                obj.VDDWL = VDD_WLboost;            
            else
                obj.VDDWL = V_DD;
            end
            
            obj.Wpg = wpg*1e6; %convert to microns since cap is per micron
            obj.Lpg = lpg*1e6;
            
            obj.Wp_inv1 = (0.5/0.04)*obj.lambda;
            obj.Wn_inv1 = (0.5/0.04)*obj.lambda;

            obj.Wp_inv2 = (2/0.04)*obj.lambda;
            obj.Wn_inv2 = (2/0.04)*obj.lambda;

            obj.Wp_inv3 = (8/0.04)*obj.lambda;
            obj.Wn_inv3 = (8/0.04)*obj.lambda;

            obj.Wp_nand = (0.6/0.04)*obj.lambda;
            obj.Wn_nand = (0.6/0.04)*obj.lambda;

            obj.WL_DRIVER_WIDTH = (45/0.04)*obj.lambda;
            
        end
        
		% Energy
		function obj = E(obj)
          E@SRAM_Component(obj,'WLDriver',obj.templateName); 
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1 && obj.bbEstimate ~=1 && obj.userModel ~=1)
            [Cinv1_in, Cinv1_out] = obj.getInvCap(obj.Wp_inv1, obj.Wn_inv1);
            [Cinv2_in, Cinv2_out] = obj.getInvCap(obj.Wp_inv2, obj.Wn_inv2);
            [Cinv3_in, Cinv3_out] = obj.getInvCap(obj.Wp_inv3, obj.Wn_inv3);
            [Cnand_in, Cnand_out] = obj.getNandCap(obj.Wp_nand, obj.Wn_nand);
            Cpg = 2*obj.cap_gate*obj.Lpg*obj.Wpg;

            Cap_WL = obj.NC*Cpg + obj.cap_metal_int * obj.W_BC * obj.NC;
            Cap_driver_device = Cnand_in + Cnand_out + Cinv1_in + Cinv1_out + Cinv2_in + Cinv2_out + Cinv3_in + Cinv3_out;
            Cap_int_nodes = 1.5 * obj.WL_DRIVER_WIDTH * obj.cap_metal_int; % Rough summation of all internal caps + WL cap
            obj.Energy = 2*(1/2)*((obj.VDDWL)^2)*(Cap_int_nodes + Cap_driver_device + Cap_WL);
          end
		end % Energy
		
		% Delay
		function obj = D(obj)
          D@SRAM_Component(obj,'WLDriver',obj.templateName); 
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1 && obj.bbEstimate ~=1 && obj.userModel ~=1)
            [Cinv1_in, Cinv1_out] = obj.getInvCap(obj.Wp_inv1, obj.Wn_inv1);
            [Cinv2_in, Cinv2_out] = obj.getInvCap(obj.Wp_inv2, obj.Wn_inv2);
            [Cinv3_in, Cinv3_out] = obj.getInvCap(obj.Wp_inv3, obj.Wn_inv3);
            [Cnand_in, Cnand_out] = obj.getNandCap(obj.Wp_nand, obj.Wn_nand);
            Cpg = 2*obj.cap_gate*obj.Lpg*obj.Wpg;

            P = obj.p_nand + obj.p_inv1 + obj.p_inv2 + obj.p_inv3;
            DF = obj.g_nand*Cinv1_in/Cnand_in + obj.g_inv*Cinv2_in/Cinv1_in + obj.g_inv*Cinv3_in/Cinv2_in + obj.g_inv*(Cpg*obj.NC/2 + obj.cap_metal_int*obj.W_BC*obj.NC/2)/Cinv3_in;
            obj.Delay = obj.tau*(P + DF);
          end
		end % D_rowDecoder
	end % methods
end % classdef
