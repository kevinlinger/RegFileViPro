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
# Call Spectre on all input paths #
###################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();
my $verbose = 1;
#################
# Begin Program #
#################
if($verbose){print(" scs2out\n");}
foreach my $argnum (0 .. $#ARGV) {
    if($verbose){print("  Executing test: " . $ARGV[$argnum] . "\n");}
    my $path = $usr . "/" . $ARGV[$argnum] . "/";
    spectre("../../", $path);
}



#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################



#####################################
# Run default Spectre configuration #
#####################################
sub spectre {
    my $curDir = $_[0];
    my $tarDir = $_[1];
    #my $cmd = "time spectre -env artist5.1.0 +log OUT/log.out -format psfascii -raw OUT/ input.scs";
    my $cmd = "spectre -env artist5.1.0 +log OUT/log.out -format psfascii -raw OUT/ input.scs";
    # TODO: need to make this time formatted to only be a single line - but "-f" doesn't work.

    chdir $tarDir;
    system("rm -rf OUT");
    system("mkdir OUT");
    system($cmd . " &> spectre.log") == 0
	or die "Spectre failed - check ${tarDir}spectre.log for details. If the file doesn't exist, Cadence environment may not be setup\n";
    system("rm -f spectre.log");
    chdir $curDir;
}
















