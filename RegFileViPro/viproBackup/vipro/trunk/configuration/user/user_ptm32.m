% Everything in S.I units. Ion and Ileak in A/m
Technology = 'ptm32';
Node = '32';
Memory_Size = 2^14;
Cell_Type = 'DRC';
Process = 'tt';
Channel_Length = 0.032;
Channel_Width = 0.032;
V_DD = 0.9;
SRAM_USP = 'gp';
Interconnect_Metal = 'cu';
Word_Size = 16;
Energy_Constraint = 0;
Delay_Constraint = 1e-9;

SA_offset = 0.0833;

% User specs for which components to auto-select from a bunch of available
% options and for which components to select a particular option. Stored in
% a cell array.
% The naming convention for templates in the characterizer should be of the
% form RVP_<component name in hierarcy>_<option name>. E.g.
% RVP_SA_latchType or RVP_rowPeriphery_default

% Second field says whether you choose from a bunch of available types of
% the component depending on whether the user specifices gp,lp or hp.
% Third one says if a particular type of component is to be chosen and
% final field gives the name of the template.
selectOptions = {'bitcell',0,0,'',0,[0 0],0,'','';...
                 'colMux',0,0,'',0,[0 0],0,'', '';...
                 'Decoder',0,0,'',0,[0 0],0,'', '';...
                 'ReadCircuit',0,0,'',0,[0 0],0,'' ,'';...
                 'SA',0,0,'',0,[0 0],0,'' ,'';...
                 'WLDriver',0,0,'',0,[0 0],0,'' ,'';...
                 'WriteCircuit',0,0,'',0,[0 0],0,'', '';...
                 'rowAssist',0,0,'',0,[0 0],0,'' ,''};

