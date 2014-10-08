function [capTotal wwr wpch WColMux] = capBL(CapMetalInt,CapJunction,CapGate,ROWS,COLS,TECH)

capTotal = 0;
constructor;

% This is more of less compatible with all TECHs although it has been tuned initially for 90nm
% Things to revisit if you want any changes wrt TECH:
% 1) Beta ratio
% 2) SA sizings
% 3) SpeedPCH & SpeedWrite (but they are more design choices)
% 4) VColMuxDrop

% Variables - functions of design.
SpeedPCH = 3 ; % FO4 delays in which a fully discharged BL will precharged.
SpeedWrite = 3; % FO4 delays in which a fully precharged BL will discharge.
Beta = 2;% Ratio of strength of NMOS and PMOS (later to be retrieved from constructor)

% SA sizings: Estimates for 90nm
SA_pg = 4;
SA_pu = 5;
SA_pd = 8;
SA_TECH_SHRINK_FACTOR = 1.1;% Shrink in SA (analogish ckt) is less than technology scaling

if(TECH==130)
  SA_pg = SA_pg * (SA_TECH_SHRINK_FACTOR^1);
  SA_pu = SA_pu * (SA_TECH_SHRINK_FACTOR^1);
  SA_pd = SA_pd * (SA_TECH_SHRINK_FACTOR^1);
end
if(TECH==180)
  SA_pg = SA_pg * (SA_TECH_SHRINK_FACTOR^2);
  SA_pu = SA_pu * (SA_TECH_SHRINK_FACTOR^2);
  SA_pd = SA_pd * (SA_TECH_SHRINK_FACTOR^2);
end
if(TECH==65)
  SA_pg = SA_pg / (SA_TECH_SHRINK_FACTOR^1);
  SA_pu = SA_pu / (SA_TECH_SHRINK_FACTOR^1);
  SA_pd = SA_pd / (SA_TECH_SHRINK_FACTOR^1);
end
if(TECH==45)
  SA_pg = SA_pg / (SA_TECH_SHRINK_FACTOR^2);
  SA_pu = SA_pu / (SA_TECH_SHRINK_FACTOR^2);
  SA_pd = SA_pd / (SA_TECH_SHRINK_FACTOR^2);
end
if(TECH==32)
  SA_pg = SA_pg / (SA_TECH_SHRINK_FACTOR^3);
  SA_pu = SA_pu / (SA_TECH_SHRINK_FACTOR^3);
  SA_pd = SA_pd / (SA_TECH_SHRINK_FACTOR^3);
end
if(TECH==22)
  SA_pg = SA_pg / (SA_TECH_SHRINK_FACTOR^4);
  SA_pu = SA_pu / (SA_TECH_SHRINK_FACTOR^4);
  SA_pd = SA_pd / (SA_TECH_SHRINK_FACTOR^4);
end
if(TECH==16)
  SA_pg = SA_pg / (SA_TECH_SHRINK_FACTOR^5);
  SA_pu = SA_pu / (SA_TECH_SHRINK_FACTOR^5);
  SA_pd = SA_pd / (SA_TECH_SHRINK_FACTOR^5);
end

SA_height = (SA_pg + SA_pu + SA_pd)/2 * 1.2; % Cross coupled pd & pu + active shielding + padding
% ColMux
VColMuxDrop = 20; % (in mV) Sized for 10mV drop
RColMuxDrop = VColMuxDrop/I_cell;% (in mV/Amp) Assuming constant read current
Reff_P = 200/Ion_P(3); % in (mV/Amp . Microns)
WColMux = Reff_P/RColMuxDrop*1e6; % (in Microns)

% BL capacitance components due to 6T array
cap6T_device = wpg*1e6*CapJunction; 
cap6T_metal  = Bitcell_Height*1e6*CapMetalInt;
cap6T = cap6T_device + cap6T_metal;
capARRAY = ROWS*cap6T;

% SA capacitance
capSA_device = (SA_pg*2 + SA_pu + SA_pd) * CapJunction+ (SA_pu+SA_pd)*Channel_Length*CapGate;
capSA_metal = SA_height * CapMetalInt; 
capSA = capSA_device + capSA_metal;

% ColMux capacitance
capColMux = 5*WColMux*CapJunction;

% Equalizer|Pch
capTotal = capARRAY+capSA+capColMux;% partial Sum
temp1 = capTotal/CapGate;%cap in microns of gate
temp2 = temp1/(4*SpeedPCH); % Equivalent inv sizing for FO4*SpeedPCH drive
wpch = temp2*Beta/(Beta+1);
weq = wpch;
capPCH_EQ = (weq+wpch)*CapGate*Channel_Length;

% Write Driver
capTotal=capTotal+capPCH_EQ;
temp1 = capTotal/CapGate;
temp2 = temp1/(4*SpeedWrite);
wwr = temp2*1/(Beta+1);
capWWR = wwr*CapGate*Channel_Length;
capTotal = capTotal+capWWR;
capTotal = capTotal + (wwr*CapGate*Channel_Length)/(4*SpeedPCH)*Beta/(Beta+1);

%fprintf('\nWcolMux=%e\ncapARRAY=%e\ncapSA=%e\ncapColMux=%e\n',WColMux,capARRAY,capSA,capColMux);
%fprintf('WPCH=%e\nCapPCH_EQ=%e\nCapWWR=%e\n\n',wpch,capPCH_EQ,capWWR);

end
