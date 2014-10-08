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

#################################
# Call Ocean on all input paths #
#################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();
my $verbose=1;

#################
# Begin Program #
#################
if($verbose){print(" ocn2out\n");}
foreach my $argnum (0 .. $#ARGV) {
    if($verbose){print("  Executing test: " . $ARGV[$argnum] . "\n");}
    my $path = $usr . "/" . $ARGV[$argnum] . "/";
    ocean("../../", $path);
}



#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################



###################################
# Run default Ocean configuration #
###################################
sub ocean {
    my $curDir = $_[0];
    my $tarDir = $_[1];
    #my $cmd = "spectre -env artist5.1.0 +log OUT/log.out -format psfascii -raw OUT/ input.scs";
    #my $cmd = "time ocean -nograph < ocnloader";
    my $cmd = "ocean -nograph < ocnloader";

    chdir $tarDir;
    system("rm -rf OUT");
    system("mkdir OUT");
    system($cmd . " > ocean.log") == 0
	or die "Ocean failed. Setup the cadence environment first\n";
    system("tail -10 ocean.log > ocean_tail.log");
    my $data_file = "ocean_tail.log";
    open CHK_ARRAY, $data_file;
    my @chk_array = <CHK_ARRAY>;
    close CHK_ARRAY;
    if (grep(/error while loading file/,@chk_array) eq 0) {
	system("rm -f ocean.log ocean_tail.log");
	chdir $curDir;
    } else {
    	die "Ocean failed. Check the log at ${tarDir}ocean.log for details\n";
    }
}

