%%%%%%%%%%%%%%%%%%%%%%
% Bitcell class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_rowAssist < SRAM_Component
% 	properties
%         % Put in new parameters that are needed for analytical expressions
%         % for energy and delay methods.
% 	end % properties

	methods
        % Constructor
        function obj = SRAM_rowAssist(wr,rows,cols)
            obj = obj@SRAM_Component(wr,rows,cols);
            constructor;
            obj.autoSelect = selectOptions{8,2}(1,1);
            obj.fixedComponent = selectOptions{8,3}(1,1);
            obj.templateName = selectOptions{8,4};     
            obj.bbEstimate = selectOptions{8,5};
            if (obj.bbEstimate == 1)
                obj.Energy = selectOptions{8,6}(1,1);
                obj.Delay = selectOptions{8,6}(1,2);
            end
            obj.userModel = selectOptions{8,7};
            if (obj.userModel == 1)
                obj.Energy = selectOptions{8,8};
                obj.Delay = selectOptions{8,9};
            end
        end

        % Energy, assuming energy for both read and write is the
        % same
        function obj = E(obj)
          E@SRAM_Component(obj,'rowAssist',obj.templateName);
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1 && obj.bbEstimate ~=1 && obj.userModel ~=1)
              % Put in analytical equations
              obj.Energy = 0;
          end
        end % Energy

        % Delay, assuming delay is the same for both read and write
        function obj = D(obj)
          D@SRAM_Component(obj,'rowAssist',obj.templateName);
          if (obj.fixedComponent == 1)
              % take into account changing WL driver size as NR increases,
              % which affects delay. Done very crudely for now, without any
              % basis for the assumption, just to show some trends
              obj.Delay = obj.Delay*(1.2^(log2(obj.NR/32)));
          end          
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1 && obj.bbEstimate ~=1 && obj.userModel ~=1)
              %Put in analytical equations
              obj.Delay = 0;
          end
        end % Delay
      end % methods
end % classdef
