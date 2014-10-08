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

########################################
# Manage Plugins and Call if Necessary #
########################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();

#################
# Begin Program #
#################
foreach my $argnum (1 .. $#ARGV) {
    runPlug($ARGV[0], $usr, $ARGV[$argnum]);
}



#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################



#####################################
# Run default Spectre configuration #
#####################################
sub runPlug {
    my $time = $_[0];
    my $usr  = $_[1];
    my $test = $_[2];
    my $file = $usr . "/" . $test . "/plugin.ini";

    if (-e $file){
	open(IN, $file);
	my @input = <IN>;
	close IN;

	if ($#input < 1) {
	    die("Invalid plugin configuration file - see documentation for details, failed");
	}
	
	chomp(@input);
	my $pName = $input[0];
	my $pArgs = $input[1];
	my $pTime = getTime($pName);

	if ($pTime =~ m/$time/){
	    print(" Plugin Interjection\n  " . $pName . "\n");
	    system("perl PLG/" . $pName . " " . $pArgs) == 0
		or die("Invalid plugin information - " . $pName . " " . $pArgs . ", failed");
	}
    }
}



#############################
# Get Time Info From Plugin #
#############################
sub getTime {
    my $file = "PLG/" . $_[0];
    
    open (IN, $file);
    my @input = <IN>;
    close IN;

    chomp(@input);

    my $time = $input[0];
    $time =~ s/#//;

    return $time;
}






























