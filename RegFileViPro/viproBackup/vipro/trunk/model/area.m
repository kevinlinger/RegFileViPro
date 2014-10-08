%% File created by 
% Mudit Bhargava
% Carnegie Mellon Univsity
% 10/23/2008
%% BASIC DEFAULTS

%clear;

function [SRAM_AREA ARRAY_AREA IO_AREA WL_DRIVERS_AREA AREA_CONTROL SelfTime_AREA] = area(SRAM_ROWS,SRAM_COLS)
TECH=90; % in Nanometers
PROCESS=0; % (-2,-1,0,1,2) <=> (SF,SS,TT,FF,FS)
VDD = 1.0; % supply voltage
% Really really trivial note: PROCESS & VDD will impact only the delay and
% power numbers. For area, they dont matter at all !!
%% SRAM Unique Selling Point
% HD : High Density
% GP : General Purpose
% HS : High Speed
% LP : Low Power
% All the calculations are for 'GP' by default. The HD version has x%
% lower area as compared to GP. The HS and LP versions have y% higher area
% as compared to GP.
SRAM_USP = 'GP'; % or HD, HS, LP
switch(SRAM_USP)
    case 'GP'
        USP_fudge_factor = 1;
    case 'HD'
        USP_fudge_factor = 0.9; % Guesstimate
    case 'LP'
        USP_fudge_factor = 1.1; % Guesstimate
    case 'HS'
        USP_fudge_factor = 1.1; % Guesstimate
end

%% MEMORY SIZE
% Memory size can be given in terms of a) ROWS/COLS or b) WORDS/BITS. 
% Col mux option is also provided, default is 4.

% % Option A: Comment all option B lines
% SRAM_WORDS = 1024; 
% SRAM_BITS  = 64;
% SRAM_MUX   = 4;
% SRAM_COLS  = SRAM_BITS * SRAM_MUX;
% SRAM_ROWS  = (SRAM_WORDS * SRAM_BITS)/(SRAM_COLS);

% Option B: Comment all option A lines
SRAM_COLS  = 256;
SRAM_ROWS  = 256;
SRAM_MUX   = 4;
SRAM_WORDS = (SRAM_ROWS*SRAM_COLS)/(SRAM_MUX); 
SRAM_BITS  = SRAM_COLS/SRAM_MUX;
%% MEMORY CELL DIMENSIONS
% (The dimensions are calculated starting from a reasonable height and
% width assumption from a commercial 90nm SRAM. The ideal shrink dimensions
% are calculated and values fudged to match some quoted dimensions as
% published in literature)
% INPUTS:-
% Technology (eg: TECH=90)
% CellType (eg: cellType='subDRC')
% CellType2 (eg: cellType2 = 'lowArea' or 'highSpeed')
cellType = 'subDRC'; % ('subDRC' or 'DRC') <=> subDRC or DRC compliant
cellType2 = 'normal'; % ('lowArea', 'normal', 'highSpeed')<=>(0.9,1.0.1.1) times the normal area

% Memory cell height and width are provided for subDRC and DRC compliant
% subDRC sizes for 90nm
MCH90 = 0.6; % microns
MCW90 = 1.67; % microns
% The subDRC cell is x% less wide and y% less high than the DRC compliant
if(strcmp(cellType,'subDRC')) 
    drc_w_shrink = 1;
    drc_h_shrink = 1;
elseif(strcmp(cellType,'DRC'))
    drc_w_shrink = 1.15;
    drc_h_shrink = 1.33;
else
    'Error: cellType not defined correctly' %#ok<NOPTS>
    return;
end

shrink = 0.7;
% shrink is less than ideal shrink
shrink_fudge_90 = 1; 
shrink_fudge_65 = shrink_fudge_90 * 1.05; 
shrink_fudge_45 = shrink_fudge_65 * 1.15; 
shrink_fudge_32 = shrink_fudge_45 * 1.2; 
shrink_fudge_22 = shrink_fudge_32 * 1.3; 

switch(TECH)
    case 130 
        tech_shrink = 1/shrink;
    case 90 
        tech_shrink = 1 * shrink_fudge_90;
    case 65 
        tech_shrink = shrink * shrink_fudge_65;
    case 45 
        tech_shrink = (shrink^2) * shrink_fudge_45;
    case 32 
        tech_shrink = (shrink^3) * shrink_fudge_32;
    case 22 
        tech_shrink = (shrink^4) * shrink_fudge_22;
end
% TECH
% cellType
MCH = MCH90 * drc_h_shrink * tech_shrink;
MCW = MCW90 * drc_w_shrink * tech_shrink;
MCArea = MCH*MCW;
ARRAY_AREA = MCArea * SRAM_ROWS * SRAM_COLS;
%% Area of IO block
% (Precharge transistors + Write drivers + col_mux + SA + input/output buffers)
% Base calculation for 256 rows & 90nm technology. Others are extrapolated.
% From our calculations, We get the following height calculations.
if(SRAM_ROWS<128)
    IO90_HEIGHT = 40; % 35 + 5 (for SA)
elseif(SRAM_ROWS<256)
    IO90_HEIGHT = 40 + (SRAM_ROWS-128) * (5/128);
else
    IO90_HEIGHT = 45 + (SRAM_ROWS-256) * (20/128);
end

% This is the orientation shrink factor if Poly is required to be in same
% orientation all over the chip - it will be horizontal - if we consider BL
% as vertical lines - since the 6T will have horizontal poly and everything
% will need to be aligned to that. Also, some new pdk require poly to be
% pitch matched. This fudge factor takes the area increase because of these
% limitations.
poly_orientation_shrink_factor = 1;
% SA is not shrinking as much since critical devices are still analong
% devices which need to stay BIG to reduce offset.
SA_shrink_factor = 0.9; % Need to verify this number !!!

% shrink is less than ideal shrink
shrink_fudge_90 = 1; 
shrink_fudge_65 = shrink_fudge_90 * 1.05; 
shrink_fudge_45 = shrink_fudge_65 * 1.05; 
shrink_fudge_32 = shrink_fudge_45 * 1.05; 
shrink_fudge_22 = shrink_fudge_32 * 1.05; 


switch(TECH)
    case 130 
        tech_shrink = 1/shrink;
    case 90 
        tech_shrink = 1 * shrink_fudge_90;
        SA_shrink = SA_shrink_factor;
    case 65 
        tech_shrink = shrink * shrink_fudge_65;
        SA_shrink = SA_shrink_factor^2;
    case 45 
        tech_shrink = (shrink^2) * shrink_fudge_45;
        SA_shrink = SA_shrink_factor^3;
    case 32 
        tech_shrink = (shrink^3) * shrink_fudge_32 * poly_orientation_shrink_factor;
        SA_shrink = SA_shrink_factor^4;
    case 22 
        tech_shrink = (shrink^4) * shrink_fudge_22 * poly_orientation_shrink_factor;
        SA_shrink = SA_shrink_factor^5;
end

IO_HEIGHT = (IO90_HEIGHT-5) * tech_shrink + 5 * SA_shrink;
IO_AREA = IO_HEIGHT * MCW * SRAM_COLS;
%% Area of WL decoder block
% (Post decoder + 3 stage buffers that generate a active high WL)
% Base calculation for 256 rows & 90nm technology. Others are extrapolated.
% From our calculations, We get the following height calculations.
% ASSUMPTION : 4 row drivers laid out together.

if(SRAM_COLS<128)
    WL_DRIVERS90_WIDTH = 35; % 35 + 5 (for SA)
elseif(SRAM_COLS<256)
    WL_DRIVERS90_WIDTH = 35 + (SRAM_COLS-128) * (2/128);
else
    WL_DRIVERS90_WIDTH = 37 + (SRAM_COLS-256) * (6/256);
end

% shrink is less than ideal shrink
shrink_fudge_90 = 1; 
shrink_fudge_65 = shrink_fudge_90 * 1.05; 
shrink_fudge_45 = shrink_fudge_65 * 1.05; 
shrink_fudge_32 = shrink_fudge_45 * 1.05; 
shrink_fudge_22 = shrink_fudge_32 * 1.05; 
shrink_fudge_15 = shrink_fudge_22 * 1.05; 

switch(TECH)
    case 130 
        tech_shrink = 1/shrink;
    case 90 
        tech_shrink = 1 * shrink_fudge_90;
    case 65 
        tech_shrink = shrink * shrink_fudge_65;
    case 45 
        tech_shrink = (shrink^2) * shrink_fudge_45;
    case 32 
        tech_shrink = (shrink^3) * shrink_fudge_32;
    case 22 
        tech_shrink = (shrink^4) * shrink_fudge_22;
end

WL_DRIVERS_WIDTH = WL_DRIVERS90_WIDTH * tech_shrink;
WL_DRIVERS_AREA = WL_DRIVERS_WIDTH * SRAM_ROWS * MCH;

%% Area of Control logic
% (Predecoders, address flops, etc.)
% Simply assuming that we would be able to fit in the logic in the width of
% the WL Drivers and the height of the IO
% (A fair assumption, I guess)

AREA_CONTROL = WL_DRIVERS_WIDTH * IO_HEIGHT;

%% Area of Self timing block
% (Some extra columns + some logic to drive the SAEN into the IOs)
% Give "0" if self timed signal is generated in some other trivial fashion.
% Like generated from the falling edge of clock or some fixed delay, which
% would fit into the CONTROL Area.
SelfTime_COLS = 4; 
SelfTime_AREA = ((MCH * SRAM_ROWS) + IO_HEIGHT) * (SelfTime_COLS * MCW);

%% FINAL AREA CALCULATIONS:
% Sum of all the parts calculated above
SRAM_AREA = ARRAY_AREA + IO_AREA + WL_DRIVERS_AREA + AREA_CONTROL + SelfTime_AREA;
SRAM_WIDTH = WL_DRIVERS_WIDTH + (SRAM_COLS + SelfTime_COLS) * MCW;
SRAM_HEIGHT = IO_HEIGHT + SRAM_ROWS * MCH;
%SRAM_AREA_Sanity_Check = SRAM_WIDTH * SRAM_HEIGHT;

SRAM_AREA = SRAM_AREA     * USP_fudge_factor;
SRAM_WIDTH = SRAM_WIDTH   * USP_fudge_factor;
SRAM_HEIGHT = SRAM_HEIGHT * USP_fudge_factor;

%% END OF FILE
end
