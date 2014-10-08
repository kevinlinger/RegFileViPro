%%%%%%%%%%%%%%%%%%%%%%
% Bitcell class
%%%%%%%%%%%%%%%%%%%%%%

classdef SRAM_colAssist < SRAM_Component
	properties

	end % properties

	methods
        
        % Constructor
        function obj = SRAM_colAssist(wr,rows,cols)

        end

        % Energy
        function obj = E(obj)
          E@SRAM_Component(obj,'colAssist',obj.templateName); 
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1)
          end
        end % Energy

        function obj = D_write(obj)
          D(obj,'colAssist',obj.templateName); 
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1)
          end
        end % Write Delay

        % Read Delay
        function obj = D_read(obj)
          D(obj,'colAssist',obj.templateName); 
          if (obj.autoSelect ~= 1 && obj.fixedComponent ~= 1)  
          end
        end % Read Delay
      end % methods
end % classdef
