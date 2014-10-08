#!/usr/bin/env perl

###############
# Author: Mudit Bhargava, Carnegie Mellon University, Jan 13, 2009
# This file generates the cell design points that satisfy a user-given criteria. All the criteria are given as input
# in the cellGen.ini file. This file then calls perl.pl across various design points and determines the sizes that 
# give FoMs in acceptable range.
###############

use strict;
#use Switch 'Perl6';
use File::Basename;
use File::Path;
use File::Copy;
use Cwd;

my $usr = getlogin();

#############
# Help text #
#############
my $help = "\n
This is the cell generator. It calls top.pl (which calls run.pl) to simulate various design points and determine 
the design points that satisfy the user specifications.

Usage:

> perl cellGen.pl 

The user specifications and constrainsts are defined in the file 'cellGen.ini'";

#############################
# Parse the constraints and make template files for multiple runs. 
##################################

# Device constraint variables
my $LPG_LO = -1;
my $LPG_HI = 1000;
my $LPD_LO = -1;
my $LPD_HI = 1000;
my $LPU_LO = -1;
my $LPU_HI = 1000;
my $WPG_LO = -1; 
my $WPG_HI = 1000;
my $WPD_LO = -1; 
my $WPD_HI = 1000;
my $WPU_LO = -1; 
my $WPU_HI = 1000;
my $AREA_LO = -1;
my $AREA_HI = 10000000;

# For printing
my $TOPROW = "LPG\tLPD\tLPU\tWPG\tWPD\tWPU";

# Tech dependent variables
my $CELL_TYPE;
my $LAMBDA;

# FoM constraints (default values given high; any constraint from cellGen.ini overrides them)
my $IREAD_LO = -1000;
my $RSNM_LO = -1000;
my $WM_SNM_LO = -1000;

# File structure
my $templatePath = '';
my @techfiles;
my @specs;
my @constraints;

#############################################################
# For debugging
# ############################################################
my $xt;

#############################################################
# For Output
# ############################################################
my $summary = "\n\n" . "\nRESULT SUMMARY\n" . "#" x40 . "\n";

##############################################################
# Reading and parsing the file
##############################################################

open(FILE,"cellGen.ini") or die("*Error: cellGen.ini could not be opened for read.");
my @filelines = <FILE>;
close FILE ;

chomp(@filelines);
my $line;
my $InSectionTech=0;
my $InSectionSpec=0;
my $InSectionCons=0;

foreach $line (@filelines){

  # Template Path
  if($line =~ /^templatePath\s+(.*)$/s){
    $templatePath = $1;
    next;
  }
  # Tech files
  if($line =~ /^<tech>$/){
    $InSectionTech=1;
    next;
  }
  if($line =~ /^<\/tech>$/){
    $InSectionTech=0;
    next;
  }
  if($InSectionTech==1 && $line =~ /^[^#]/){
    push(@techfiles,$line);
    next;
  }
  # Specs
  if($line =~ /^<spec>$/){
    $InSectionSpec=1;
    next;
  }
  if($line =~ /^<\/spec>$/){
    $InSectionSpec=0;
    next;
  }
  if($InSectionSpec==1 && $line =~ /^[^#]/){
    push(@specs,$line);
    next;
  }
  # Constraints
  if($line =~ /^<constraints>$/){
    $InSectionCons=1;
    next;
  }
  if($line =~ /^<\/constraints>$/){
    $InSectionCons=0;
    next;
  }
  if($InSectionCons==1 && $line =~ /^[^#]/){
    push(@constraints,$line);
    next;
  }
}

# Checks

if($templatePath eq ''){
  die("templatePath not correctly provided in cellGen.ini");
}

##########################################################
# Parsing the Constraints
##########################################################

my $conentry;
foreach $conentry(@constraints){
  my @con = split(/\s+/,$conentry);
  if(lc($con[0]) eq "alll"){
    $LPG_LO = ($con[2] >= $LPG_LO ? $con[2]:$LPG_LO);
    $LPU_LO = ($con[2] >= $LPU_LO ? $con[2]:$LPU_LO);
    $LPD_LO = ($con[2] >= $LPD_LO ? $con[2]:$LPD_LO);
    $LPG_HI = ($con[3] <= $LPG_HI ? $con[3]:$LPG_HI);
    $LPU_HI = ($con[3] <= $LPU_HI ? $con[3]:$LPU_HI);
    $LPD_HI = ($con[3] <= $LPD_HI ? $con[3]:$LPD_HI);
  }

  if(lc($con[0]) eq "allw"){
    $WPG_LO = ($con[2] >= $WPG_LO ? $con[2]:$WPG_LO);
    $WPU_LO = ($con[2] >= $WPU_LO ? $con[2]:$WPU_LO);
    $WPD_LO = ($con[2] >= $WPD_LO ? $con[2]:$WPD_LO);
    $WPG_HI = ($con[3] <= $WPG_HI ? $con[3]:$WPG_HI);
    $WPU_HI = ($con[3] <= $WPU_HI ? $con[3]:$WPU_HI);
    $WPD_HI = ($con[3] <= $WPD_HI ? $con[3]:$WPD_HI);
  }

  if(lc($con[0]) eq "lpg"){
    $LPG_LO = ($con[2] >= $LPG_LO ? $con[2]:$LPG_LO);
    $LPG_HI = ($con[3] <= $LPG_HI ? $con[3]:$LPG_HI);
  }

  if(lc($con[0]) eq "lpu"){
    $LPU_LO = ($con[2] >= $LPU_LO ? $con[2]:$LPU_LO);
    $LPU_HI = ($con[3] <= $LPU_HI ? $con[3]:$LPU_HI);
  }

  if(lc($con[0]) eq "lpd"){
    $LPD_LO = ($con[2] >= $LPD_LO ? $con[2]:$LPD_LO);
    $LPD_HI = ($con[3] <= $LPD_HI ? $con[3]:$LPD_HI);
  }

  if(lc($con[0]) eq "wpg"){
    $WPG_LO = ($con[2] >= $WPG_LO ? $con[2]:$WPG_LO);
    $WPG_HI = ($con[3] <= $WPG_HI ? $con[3]:$WPG_HI);
  }

  if(lc($con[0]) eq "wpu"){
    $WPU_LO = ($con[2] >= $WPU_LO ? $con[2]:$WPU_LO);
    $WPU_HI = ($con[3] <= $WPU_HI ? $con[3]:$WPU_HI);
  }

  if(lc($con[0]) eq "wpd"){
    $WPD_LO = ($con[2] >= $WPD_LO ? $con[2]:$WPD_LO);
    $WPD_HI = ($con[3] <= $WPD_HI ? $con[3]:$WPD_HI);
  }
  if(lc($con[0]) eq "area"){
    $AREA_LO = ($con[2] >= $AREA_LO ? $con[2]:$AREA_LO);
    $AREA_HI = ($con[3] <= $AREA_HI ? $con[3]:$AREA_HI);
  }

}

##########################################################
# For each tech file, create a different design solution
##########################################################

# Create a top-level directory where results would be stored
rmtree ("RESULTS");
mkpath ("RESULTS") or die("could not create RESULTS directory."); 

my $techentry;
foreach $techentry(@techfiles){
  my @tech = split(/\s+/,$techentry);
  mkpath("RESULTS/".$tech[0]) or die("could not create RESULTS/".$tech[0]." directory.");
  chdir("RESULTS/".$tech[0]);

  my $cell_type;
  if(lc($tech[1]) eq "drc"){
  $cell_type="DRC Compliant cell";
}elsif(lc($tech[1]) eq "subdrc"){
  $cell_type="subDRC cell";
}else{die("Error in <tech> entry in cellGen.ini");}

  print "\nBeginning cell generation for ",$tech[0]," ",$cell_type," and lambda=",$tech[2],"nm\n";
  open(TEMPFILE, '>>range.init');
  my $iLPG;
  my $iLPD;
  my $iLPU;
  my $iWPG;
  my $iWPD;
  my $iWPU;
  my $resolution = 3;
  for($iLPG=$LPG_LO; $iLPG <=$LPG_HI ; $iLPG = $iLPG + ($LPG_HI-$LPG_LO)/$resolution){
    for($iLPD=$LPD_LO; $iLPD <=$LPD_HI ; $iLPD = $iLPD + ($LPD_HI-$LPD_LO)/$resolution){
      for($iLPU=$LPU_LO; $iLPU <=$LPU_HI ; $iLPU = $iLPU + ($LPU_HI-$LPU_LO)/$resolution){
        for($iWPG=$WPG_LO; $iWPG <=$WPG_HI ; $iWPG = $iWPG + ($WPG_HI-$WPG_LO)/$resolution){
          for($iWPD=$WPD_LO; $iWPD <=$WPD_HI ; $iWPD = $iWPD + ($WPD_HI-$WPD_LO)/$resolution){
            for($iWPU=$WPU_LO; $iWPU <=$WPU_HI ; $iWPU = $iWPU + ($WPU_HI-$WPU_LO)/$resolution){
              my $entry = sprintf("%3.3f\t%3.3f\t%3.3f\t%3.3f\t%3.3f\t%3.3f\n",$iLPG,$iLPD,$iLPU,$iWPG,$iWPD,$iWPU);
              print TEMPFILE $entry;
            }
          }
        }
      }
    }
  }

  close(TEMPFILE);

  #################################################################################################################
  #                                             AREA CONSTRAINTS
  #################################################################################################################
  # Mudit: Create matlab file. Later, the calculations should be moved to this perl file.
  my $MATFILE = 'function area(cell_type,lambda)

%% MUDIT : Yet to be done:
%  1) Accurate formulas for other technologies


sizes = load(\'../range.init\');
%info = load(\'temp.temp\');
%cell_type = info(1);
%lambda = str2num(info(2));

% for indexing sizes
LPG=1;
LPD=2;
LPU=3;
WPG=4;
WPD=5;
WPU=6;

% All numbers in terms of LAMBDAS : Half-min L

if(lambda == 20)
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [3.6  5];         % Poly to poly distance
    poa     = [3.5  4.5];       % Poly extension over active
    a2n     = [2.25 4];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   4.5];       % Poly covering contact
    poc     = [-1   0.75];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.75 2.25];      % Contact to poly distance
    
end

if(lambda == 40) % These numbers are derived by extrapolating the 45nm numbers and DRC compliant rule numbers for 90nm
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [2.5  3.5];         % Poly to poly distance
    poa     = [2.7  3.5];       % Poly extension over active
    a2n     = [2.95 5.25];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   3.5];       % Poly covering contact
    poc     = [-1   0.25];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.36 1.75];      % Contact to poly distance
    
end

if(lambda == 90) % These numbers are derived by extrapolating the 45nm numbers and 90nm Assuming: 180nm->90nm->45nm by same factor
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [1.7  2.5];         % Poly to poly distance
    poa     = [2.1  2.7];       % Poly extension over active
    a2n     = [3.86 7.8];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   2.72];      % Poly covering contact
    poc     = [-1   0.10];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.05 1.36];      % Contact to poly distance
    
end

if(lambda == 65) % These numbers are derived by extrapolating the 45nm numbers and 90nm Assuming: 180nm->130nm->90nm->65nm->45nm by same factor
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [2.1  3.0];         % Poly to poly distance
    poa     = [2.4  3.1];       % Poly extension over active
    a2n     = [3.40 6.5];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   3.11];      % Poly covering contact
    poc     = [-1   0.15];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.20 1.56];      % Contact to poly distance
    
end

if(lambda == 30) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [3.05 4.25];         % Poly to poly distance
    poa     = [3.1  4.0];       % Poly extension over active
    a2n     = [2.60 4.63];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   4.0];       % Poly covering contact
    poc     = [-1   0.50];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.56 2.00];      % Contact to poly distance
    
end

if(lambda == 16) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [4.2  5.9];         % Poly to poly distance
    poa     = [4.1  5.0];       % Poly extension over active
    a2n     = [1.95 3.46];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   5.06];       % Poly covering contact
    poc     = [-1   1.10];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [1.96 2.53];      % Contact to poly distance
    
end

if(lambda == 11) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [4.9  6.96];         % Poly to poly distance
    poa     = [4.8  5.6];       % Poly extension over active
    a2n     = [1.69 3];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   5.7];       % Poly covering contact
    poc     = [-1   1.61];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [2.19 2.84];      % Contact to poly distance
    
end

if(lambda == 8) % These numbers are derived by extrapolating the 45nm numbers and 90nm numbers
    % Spacing rule variables
    % All variables are given for [subDRC DRCcomplinant]
    p2p     = [5.7  8.21];         % Poly to poly distance
    poa     = [5.6  6.25];       % Poly extension over active
    a2n     = [1.46 2.6];         % Active to N-well distance
    a2a     = [3.4  3.5];       % Active to Active distance
    pcc     = [-1   6.4];       % Poly covering contact
    poc     = [-1   2.35];      % Poly over contact - counted twice, so needs to be substracted
    c2c     = [-1   4];         % Contact to contact
    cw      = [2.7  3];         % Contact width
    c2p     = [2.44 3.19];      % Contact to poly distance
    
end

%% Most likely scenarios

% subDRC cell : Width governed by WPD and WPU (and not WPG) 
MCW0(:,1) = 2*(p2p(1)/2 + poa(1) + sizes(:,WPD) + 2*a2n(1) + sizes(:,WPU) + a2a(1)/2);
% DRC compliant cell: Width governed by WPD and WPU (and not WPG)
MCW0(:,2) = 2*(p2p(2)/2 + poa(2) + sizes(:,WPD) + 2*a2n(2) + sizes(:,WPU) + a2a(2)/2);

% subDRC cell: Height is governed by the NMOS stack (not the PMOS - mainly because of shared contacts)
MCH0(:,1) = cw(1)/2 + c2p(1) + sizes(:,LPD) + c2p(1) + cw(1) + c2p(1) + sizes(:,LPG) + cw(1)/2 + c2p(1);
% DRC compliant cell: Height governed by the PMOS stack in the center
MCH0(:,2) = p2p(2)/2 + pcc(2) - poc(2) + c2c(2) + cw(2) + c2p(2) + sizes(:,LPU) + c2p(2) + cw(2)/2;

% The following scenarios are unlikely to be chosen in a final cell, but need to be 
% considered for the generic bitcell generator/optimizer

% subDRC cell: Width governed by large WPG. 
%   Slightly tricky: As the PG increases, the poly over it nears the poly over the shared contact.
%   Both are equally strainted, when WPD-WPG=w1_pd_pg=60n for 45nm cell
w1_pd_pg_subDRC = 60/lambda;
MCW1(:,1) = MCW0(:,1) + 2* (sizes(:,WPG) - sizes(:,WPD) + w1_pd_pg_subDRC);

w1_pd_pg_DRC = 15/lambda;
MCW1(:,2) = MCW0(:,2) + 2* (sizes(:,WPG) - sizes(:,WPD) + w1_pd_pg_DRC);

% subDRC cell: Height governed by PMOS stack in the center
% Because of the shared contacts, a exact dimension IF the height is govened by PU is not exact.
% Defining height as: cw/2 + c2p + LPU + abp (active between polys) + LPU + c2p + cw/2

abp_subDRC = 120/lambda;    % Active between poly
MCH1(:,1) = cw(1)/2 + c2p(1) + sizes(:,LPU) + abp_subDRC + sizes(:,LPU) + c2p(1) + cw(1)/2;

% DRC cell : Governed by the PG/PD stack. Listed below from top to bot - 
MCH1(:,2) = cw(2)/2 + c2p(2) + sizes(:,LPD) + c2p(2) + cw(2) + c2p(2) + sizes(:,LPG) + c2p(2) + cw(2)/2;

% Max of sub-DRC calculations
flag = MCH0(:,1) >= MCH1(:,1);
MCH(:,1) = MCH0(:,1) .* flag + MCH1(:,1) .* (1-flag);
flag = MCW0(:,1) >= MCW1(:,1);
MCW(:,1) = MCW0(:,1) .* flag + MCW1(:,1) .* (1-flag);

% Max of DRC calculations
flag = MCH0(:,2) >= MCH1(:,2);
MCH(:,2) = MCH0(:,2) .* flag + MCH1(:,2) .* (1-flag);
flag = MCW0(:,2) >= MCW1(:,2);
MCW(:,2) = MCW0(:,2) .* flag + MCW1(:,2) .* (1-flag);



file_w = fopen(\'w_results\',\'w\');
file_h = fopen(\'h_results\',\'w\');


if(strcmpi(cell_type,\'subDRC\'))
    a = MCH(:,1).*MCW(:,1);
    fprintf(file_w,\'%5.3f\n\',MCW(:,1));
    fprintf(file_h,\'%5.3f\n\',MCH(:,1));
elseif(strcmpi(cell_type,\'DRC\'))
    a = MCH(:,2).*MCW(:,2);
    fprintf(file_w,\'%5.3f\n\',MCW(:,2));
    fprintf(file_h,\'%5.3f\n\',MCH(:,2));
elseif(strcmpi(cell_type,\'Xreg\'))
    a = 0 .*MCH(:,1);
end

file1 = fopen(\'area_results\',\'w\');
fprintf(file1,\'%5.3f \n\',a);
fclose(file1);
fclose(file_w);
fclose(file_h);

exit;
end';

~
  
  print "Design range generated. Checking for area constraints..\n";
  print "Calling matlab function area.. \n";
  mkpath("./AREA") or die "ERROR: Could not create directory for AREA\n";
  chdir("./AREA") or die "ERROR: Could not change directory into AREA\n";
  #copy("../../../area.m","./area.m");
  open(MATLABFILE,'>area.m');
  print MATLABFILE $MATFILE;
  close MATLABFILE;
  copy("../range.init","./range.init");
  #system("cp ../../../area.m .");
  #system("cp ../range.init .");

  my $cmd = "matlab -nojvm -nosplash -r \"area(\'$tech[1]\',$tech[2])\" > area.log";
  #print "Matlab command = $cmd\n";
  system($cmd)==0 or die "Couldn't execute area.m\n";
  print "Matlab done..\n";

  $TOPROW = "$TOPROW\tAREA\t\tHEIGHT\tWIDTH\t";

  # Prune the range based on area constraints
  {
    open(OLDFILE,'range.init');
    my @oldfile = <OLDFILE>;
    close(OLDFILE);
    chomp(@oldfile);

    open(AREAFILE,'area_results');
    open(HFILE,'h_results');
    open(WFILE,'w_results');
    my @areas   = <AREAFILE>;
    my @heights = <HFILE>;
    my @widths  = <WFILE>;
    chomp @areas;
    chomp @heights;
    chomp @widths;
    close(AREAFILE);
    close(HFILE);
    close(WFILE);
    
    open(NEWFILE,'>>range.after');

    my $row;
    my $rowindex;

    for ($rowindex=0;$rowindex<=$#areas;$rowindex++){
      if($areas[$rowindex] < $AREA_HI){
        # Select this design point
        print NEWFILE "$oldfile[$rowindex]\t$areas[$rowindex]\t$heights[$rowindex]\t$widths[$rowindex]\n";
      }else{next;}
    }
    close NEWFILE;

    open(NEWFILE,'range.after');
    my @newfile = <NEWFILE>;
    chomp(@newfile);
    close(NEWFILE);

    #print "Initial Range had ",$#oldfile," design points. After area constraints, we have ",$#newfile+1," design points.\n";
    my $textout = "Initial Range had ".$#oldfile." design points. After area constraints, we have ".($#newfile+1)." design points.\n";
    print $textout;
    $summary = $summary . $textout;

    #system("cp ./range.after ../range.temp") ==0 or die "ERROR: Could not copy range.after from AREA as range.temp\n";
    copy("./range.after", "../range.temp") or die "ERROR: Could not copy range.after from AREA as range.temp\n";

    chdir("..") or die "ERROR: Cannot move up 1 directory\n";

  }

  #################################################################################################################
  #                                             SPEC CONSTRAINTS
  #################################################################################################################
  # Specification Constraints
  {
    my $specrow;
    my $specIndex=0;
    my $run_type; # MC or nominal
    my @test_type; # Spectre or Ocean (scs/ocn)
    # Create directories and template files
    foreach $specrow (@specs){
      my @spec = split(/\s+/,$specrow);
      $TOPROW = sprintf("%s%15s",$TOPROW,$spec[0]);
      mkpath("./".$spec[0]."_".$specIndex) or die "Could not create directory for spec#",$specIndex,"\n";
      chdir("./".$spec[0]."_".$specIndex);
      my $cmd = "cp ".$templatePath."/".$tech[0]."\.ini ".$tech[0]."\.ini\.orig";
      system($cmd)==0 or die "template ini file not found";
      # Make changes in template.ini
      open(TEMPLATEFILE,$tech[0]."\.ini\.orig");
      my $templatecopy = join '',<TEMPLATEFILE>; #Entire file in 1 scalar variable
      close(TEMPLATEFILE);
      # Mudit: Process change - yet to figure out how to do this. Currently everything remains TT
      # Voltage & change
      $templatecopy =~ s/(<\w*vdd\w*>\s+)(.*)/$1 $spec[2]/igx;
      $templatecopy =~ s/(<temp>\s+)(.*)/$1 $spec[3]/ix;
      # no. of mc runs change
      if(lc($spec[4]) eq 'nom'){
        $run_type = 'nom';
        $templatecopy =~ s/(<mcrunNum>\s+)(\d+)/$1 1/ix;
        $templatecopy = ModificationsForNomRuns($templatecopy,$templatePath);
        #print $templatecopy;
      }elsif(lc($spec[4]) eq 'mc'){
        $run_type = 'mc';
        $templatecopy =~ s/(<mcrunNum>\s+)(\d+)/$1 $spec[5]/ix;
      }else{
        print $spec[4],"\n";
        die "Error in spec entry.\n";
      }
      # test type - ocn/scs : Modifying the template copy by writing the test
      if(-e $templatePath."/../device/TESTS/".$spec[0]."/ocnloader"){
        $templatecopy =~ s/(<ocn>) .* (<\/ocn>)/$1\n$spec[0]\n$2/six; # Writing the ocn test
        $templatecopy =~ s/(<scs>) .* (<\/scs>)/$1\n$2/six; # No scs tests
        push(@test_type , 'ocn');
      }elsif(-e $templatePath."/../device/TESTS/".$spec[0]."/".$spec[0]."\.scs"){
        $templatecopy =~ s/(<scs>) .* (<\/scs>)/$1\n$spec[0]\n$2/six; # Writing the scs test
        $templatecopy =~ s/(<ocn>) .* (<\/ocn>)/$1\n$2/six; # No ocn test
        push(@test_type , 'scs');
      }else{ die "Error: test type could not be determined.\n";}
      open(TEMPLATEFILE,">".$tech[0]."\.ini");
      print TEMPLATEFILE $templatecopy;
      close(TEMPLATEFILE);
      open(TECHIN,">techfile.in");
      print TECHIN $tech[0];
      close(TECHIN);
      chdir("../");
      $specIndex++;
    }# Directories created and template copies created.

    # Launching simulations

    $specIndex=0;
    foreach $specrow (@specs){
      my @spec = split(/\s+/,$specrow);
      chdir("./".$spec[0]."_".$specIndex) or die "ERROR: Couldn't chdir to spec# $specIndex dir\n";

      #system("mv ../range.temp ./range.init") or die "ERROR: Cannot move range.temp as range.init in spec#$specIndex\n";
      move("../range.temp","./range.init") or die "ERROR: Move did not work\n";
      open(DESIGNPOINTSINIT,'range.init') or die "ERROR: Cannot open range.init file in spec#$specIndex\n";
      my @designPoints = <DESIGNPOINTSINIT>;
      chomp @designPoints;
      close DESIGNPOINTSINIT ;
      
      my $dPointRow;
      my @dp;
      my $dpIndex=0;
      my @dpResults;
      if(@designPoints==0){
        print "!"x50,"\nNO DESIGN SOLUTION. THE CONSTRAINTS MAY BE TOO RESTRICTIVE. PLEASE RELAX THEM TO FIND A SOLUTION\n";
      }
      foreach $dPointRow (@designPoints){
        print "Starting Sim for Tech= $tech[0] Spec#$specIndex($spec[0]-$spec[4]) & Design Point # ". ($dpIndex+1)." of ". ($#designPoints+1) ."...";
        @dp = split(/\s+/,$dPointRow);
        # Modify template file with sizes of the design point
        open(TEMPLATEFILE,$tech[0]."\.ini");
        my $templatecopy = join '',<TEMPLATEFILE>;
        $templatecopy =~ s/(<lpg>\s+).*/$1$dp[0]\*$tech[2]nm/xi; #$tech[2] is lambda
        $templatecopy =~ s/(<lpd>\s+).*/$1$dp[1]\*$tech[2]nm/xi;
        $templatecopy =~ s/(<lpu>\s+).*/$1$dp[2]\*$tech[2]nm/xi;
        $templatecopy =~ s/(<wpg>\s+).*/$1$dp[3]\*$tech[2]nm/xi;
        $templatecopy =~ s/(<wpd>\s+).*/$1$dp[4]\*$tech[2]nm/xi;
        $templatecopy =~ s/(<wpu>\s+).*/$1$dp[5]\*$tech[2]nm/xi;
        open(TEMPLATEFILE,">".$tech[0]."\.ini");
        print TEMPLATEFILE $templatecopy;
        close(TEMPLATEFILE);

        #Now call top.pl
        my $pwd = `pwd`;
        chomp($pwd);
        my $cmd = "perl $templatePath/../device/BIN/top.pl";
        $cmd = "$cmd -f techfile\.in -t $pwd -noimgpdf -silent";
        system($cmd) == 0 or die "ERROR: Couldn't launch top.pl for a design point\n";
        # Capture and store the results of the simulation
        ## Mudit: Modify here if you want to capture data from some other file than mcdata
        if(@test_type[$specIndex] eq 'scs'){
          open(MCDATA,$templatePath."/../device/BIN/".$usr."_".$tech[0]."/".$spec[0]."/monteCarlo/mcdata") or die "ERROR: Could not open mcdata file\n";
        }elsif(@test_type[$specIndex] eq 'ocn'){
          if(-e $templatePath."/../device/BIN/".$usr."_".$tech[0]."/".$spec[0]."/OUT/DAT1/monteCarlo/mcdata"){
            open(MCDATA, $templatePath."/../device/BIN/".$usr."_".$tech[0]."/".$spec[0]."/OUT/DAT1/monteCarlo/mcdata") or die "ERROR: ocn file - Could not open mcdata file\n";
          }else{ print "file  $templatePath/../device/BIN/$usr"."_"."$tech[0]/$spec[0]/OUT/DAT1/monteCarlo/mcdata does not exist\n"; die;}
        }else{
          die "ERROR: mcdata file not found !\n";
        }

        my @SingledpResult = <MCDATA>;
        close(MCDATA);
        chomp(@SingledpResult);
        ## Mudit: Modify here if you want to capture data from mcdata is a different way
        foreach(@SingledpResult){
          #$_ =~ s/([\S]+)\s+.*/$1/; # Retaining the information in the first column
          #$_ =~ s/.*([\S]+)/$1/; # Retaining the information in the last column (we just need to make sure that all tests print the most imp value at the end)
          my @spl = split(/\s+/,$_);
          $_ = $spl[-1];
        }
        # If simulation failed, no value will be found from mcdata, so pushing a 'Undef' in @dpResults
        if(@SingledpResult == 0){
          push(@dpResults,'Undef');
          $dpIndex++;
          next;}
        my @processedData = split(/\s/,&MeanStdMinMax(@SingledpResult));
        if(@spec == 6){# Nominal run with spec : Nom > Spec_LO
          push(@dpResults,$processedData[0]);
        }elsif(@spec == 7){# MC runs with spec : wc-all-runs > Spec_LO
          push(@dpResults,$processedData[2]);
        }elsif(@spec == 8){# MC runs with spec : Mean - N * sigma > Spec_LO
          push(@dpResults,$processedData[0]-$spec[6]*$processedData[1]);
        }else{die "ERROR: Wrong no. of entries in spec # $specIndex\n";}
        $dpIndex++;
        print "done \n";
      }

      #Compare @dpResults vs. the specification and save design points that qualify the spec constraint
      print "Comparing the results of the design points with the spec constraint - \n\n";
      $dpIndex=0;
      my @dpAfter;
      foreach my $i (@dpResults){
        print "Comparing $i with $spec[-1]...";
        if($i >= $spec[-1]){#Design point satisfies criteria
          #print DESIGN_POINTS_AFTER $designPoints[$dpIndex]."\t".$i;
          my $k = sprintf("%10.3g",$i);
          push(@dpAfter,"$designPoints[$dpIndex]\t$k\n");
          print "Design Qualifies :) \n";
        }elsif($i eq 'Undef'){
          #print DESIGN_POINTS_AFTER $designPoints[$dpIndex]."\tUndef";
          push(@dpAfter,"$designPoints[$dpIndex]        Undef\n");
          print "Undef (Perhaps sim failed) :-| \n";
        }else{print "Design Fails :( \n";}
        $dpIndex++;
      }
      open(DESIGN_POINTS_AFTER,'>range.after');
      foreach(@dpAfter){
        printf DESIGN_POINTS_AFTER $_;
      }
      close(DESIGN_POINTS_AFTER);

      open(RESULTFILE,">>spec$specIndex\.results");
      foreach(@dpResults){
        print RESULTFILE "$_\n";}
      close(RESULTFILE);

      #system('cp range.after ../range.temp') or die "ERROR: Could not copy range.after from spec#$specIndex to a dir up\n";
      copy("./range.after","../range.temp") or die "ERROR: Could not copy range.after from spec#$specIndex to a dir up\n";

      chdir("../") or die "ERROR: Couldn't move up 1 dir from spec# $specIndex";
      $specIndex++;
      my $textout = "Initial Range had ". ($#designPoints+1) ." design points. After spec#$specIndex ($spec[0]) constraints, we have ". ($#dpAfter+1) ." design points.\n";
      print $textout;
      $summary = $summary . $textout;
    }

    #system('mv range.temp range.final');
    move("./range.temp","./range.final") or die "ERROR: Couldnt rename range.temp as range.final\n";
  }

  open(FINAL,"range.final");
  my $final = join '',<FINAL>;
  close(FINAL);
  my $final = "$TOPROW\n$final\n$summary";
  open(FINAL,">range.final");
  print FINAL $final;
  close(FINAL);
  move("./range.final","../..") or die "ERROR: Couldnt move range.final\n";


  chdir("../..");
}

sub MeanStdMinMax{
  #my @list = split(/\s+/,$_[0]);
  my @list = @_;
  my $sum=0;
  foreach my $i (@list){
    $sum += $i;
  }

  my $mean = $sum/@list;

  $sum=0;
  foreach my $i (@list){
    $sum += (($i-$mean)**2);
  }

  my $std = ($sum/@list) ** 0.5;
  @list = sort @list;
  my $min = $list[0];
  my $max = $list[-1];

  my $retValue = "$mean $std $min $max";
}

sub ModificationsForNomRuns{
  my $templatecopy = $_[0];
  my $templatePath = $_[1];
  my $CurrWD = &Cwd::cwd();
  my @modelPath = split (/$/,$templatecopy);
  chomp @modelPath;
  my $mP;
  foreach (@modelPath){
     if($_ =~ /<subN>\s+.*template\/(.*)subN.scs\s*/s){
      $mP = $1;
      }
  }
  mkpath ("$CurrWD/Models") or die "ERROR: Could not create directory Models for Nominal Runs\n";
  copy("$templatePath/$mP/subN.scs","$CurrWD/Models/subN.scs") or die "ERROR: Couldnt copy subN.scs\n";
  copy("$templatePath/$mP/subP.scs","$CurrWD/Models/subP.scs") or die "ERROR: Couldnt copy subP.scs\n";
  copy("$templatePath/$mP/include.scs","$CurrWD/Models/include.scs") or die "ERROR: Couldnt copy include.scs\n";

  open FILE, "$CurrWD/Models/subN.scs";
  my @filelines = <FILE>;
  close FILE;
  #chomp @filelines;
  foreach (@filelines){
    $_ =~ s/^(.*)mismatch=mmen(.*)/$1 mismatch=0 $2/;
  }
  open FILE, ">$CurrWD/Models/subN.scs";
  print FILE @filelines;
  close FILE;

  open FILE, "$CurrWD/Models/subP.scs";
  my @filelines = <FILE>;
  close FILE;
  #chomp @filelines;
  foreach (@filelines){
    $_ =~ s/^(.*)mismatch=mmen(.*)/$1 mismatch=0 $2/;
  }
  open FILE, ">$CurrWD/Models/subP.scs";
  print FILE @filelines;
  close FILE;

  $templatecopy =~ s/(.*)(<subN>\s+).*subN.scs(.*)/$1$2$CurrWD\/Models\/subN.scs$3/s;
  $templatecopy =~ s/(.*)(<subP>\s+).*subP.scs(.*)/$1$2$CurrWD\/Models\/subP.scs$3/s;
  $templatecopy =~ s/(.*)(<include>\s+).*include.scs(.*)/$1$2$CurrWD\/Models\/include.scs$3/s;
  $templatecopy = $templatecopy;
}
