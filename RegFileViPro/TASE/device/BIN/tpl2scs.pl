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

############################################
# Template parser that will replace all    #
# flags in 'config.ini' found in the input #
# file with their respective values.       #
############################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();
my $cfg = $usr . "/config.ini";
my $dft = $usr . "/default.ini";
my $verbose = 1;

#################
# Begin Program #
#################
if($verbose){print(" tpl2scs\n");}
open(MAPA, $dft) or die("Could NOT open default.ini, failed");
my @linesA = <MAPA>;
close MAPA;
open(MAPB, $cfg) or die("Could NOT open config.ini, failed");
my @linesB = <MAPB>;
close MAPB;

# Concatenate with defaults first...
my @lines = (@linesA, @linesB);

####################
# Build Hash Table #
####################
my %map = ();
chomp(@lines);
foreach my $line (@lines) {
    my @words = split(" ", $line);
    if (($#words > 0) && (@words[0] !~ "#")) {
	$map{@words[0]} = pop(@words);
    }
}
    
##############################
# Call Parser for Each Input #
##############################
my $format = $ARGV[0];
die("Incorrect format '$format'") if($format ne 'scs' && $format ne 'ocn');

foreach my $argnum (1 .. $#ARGV) {
    if($verbose){print("  Building test: " . $ARGV[$argnum] . "\n");}
    my $path = $usr . "/" . $ARGV[$argnum] . "/";
    parseFile($path . "input.tpl", $path . "input.$format", %map);
    parseFile($path . "plotGen.tpl", $path . "plotGen.m", %map) if (-e ${path}."plotGen.tpl");
}



#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################



######################################
# Parse File and Replace Map Matches #
######################################
sub parseFile {
    (my $argIn, my $argOut, my %map) = @_;

    my $opened = open(IN, $argIn) or die("Could NOT open $_[0], failed");
    open(OUT, ">" . $argOut);
    my @lines = <IN>;
    close IN;

    foreach my $line (@lines) {
	foreach my $key (keys %map) {
            ## Convert the units to the scientific number 
            ##   since matlab doesn't recoginize those units
            if ($map{$key}=~ /^(\d+)(\.?)(\d*)f$/) {
                $map{$key}=~ s/f/e-15/;
            }
	    if ($map{$key}=~ /^(\d+)(\.?)(\d*)p$/) {
                $map{$key}=~ s/p/e-12/;
            }
            if ($map{$key}=~ /^(\d+)(\.?)(\d*)n$/) {
                $map{$key}=~ s/n/e-9/;
            }
	    if ($map{$key}=~ /^(\d+)(\.?)(\d*)u$/) {
                $map{$key}=~ s/u/e-6/;
            }
	    if ($map{$key}=~ /^(\d+)(\.?)(\d*)m$/) {
                $map{$key}=~ s/m/e-3/;
            }
	    $line =~ s/$key/$map{$key}/g;
	    if ($map{$key} eq "NULL"){
		close OUT;
		die("Undefined parameter - " . $key . " - in config.ini, failed");
	    }
	}
	print OUT $line;
    }
    close OUT;
}






