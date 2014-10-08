#!/usr/bin/env perl

###### TERMS AND CONDITIONS ######
#Copyright 2010 Satyanand Nalam, Kyle Ringgenberg, Rob McNish, Mudit Bhargava
#This file is part of TASE.
#
#TASE is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#TASE is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with TASE.  If not, see <http://www.gnu.org/licenses/>.
################################

use strict;

###################################
# Build Matlab Plots of DAT files #
###################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();
my @out;
my $verbose=1;

#################
# Begin Program #
#################
if($verbose){print(" dat2img\n");}
@out[0] = "function plotGen ()";
@out[1] = "try";

# Concatinate m-files #
foreach my $argnum (0 .. $#ARGV) {
    if($verbose){print("  Building graphical data for: " . $ARGV[$argnum] . "\n");}
    my $path = $usr . "/" . $ARGV[$argnum] . "/";
    my @cur = buildM($path);
    @out = (@out, "", @cur, "");
    system("rm -rf " . $path . "IMG");
    system("mkdir " . $path . "IMG");
}

# Write global plotGen.m #
open(OUT, ">" . $usr . "/plotGen.m");
foreach my $line (@out) {
    print OUT $line . "\n";
}

# Write footer text #
print OUT "exit;\n";
print OUT "catch\n";
print OUT "fid = fopen('matlab.err','wt');\n";
print OUT "fprintf(fid,'Syntax Error: m-file');\n";
print OUT "fclose(fid);\n";
print OUT "exit;\n";
print OUT "end\n";
close OUT;

# Plot all graphs at once #
if($verbose){print("  Compiling global image sets\n");}
plotme("../", $usr);



#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################



#################################
# Build Single Inclusive M File #
#################################
sub buildM {
    my $path = $_[0];
    open(FILE, $path . "plotGen.m") or die ("Could NOT open m-file: " . $path . ", failed");
    my @content = <FILE>;
    chomp @content;
    close FILE;

    return @content;
}

###########################
# Run Matlab Files on All #
###########################
sub plotme {
    my $curDir = $_[0];
    my $tarDir = $_[1];
    my $cmd = "matlab -nosplash -nodesktop -r plotGen";

    chdir $tarDir;
    system($cmd . " > matlab.log") == 0
	or die "Invalid system configuration of Matlab, must be command-line runable, failed";
    system("reset"); #Temporary fix for vanishing text in terminal after command is executed
    system("rm -f matlab.log");
    if (-e "matlab.err"){
	die "Syntax error detected in global m-file, failed";
    }
    chdir $curDir;
}
















