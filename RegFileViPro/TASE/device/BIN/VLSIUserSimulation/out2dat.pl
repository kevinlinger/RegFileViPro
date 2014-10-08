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

#########################################
# Template parser that will replace all #
# flags in 'map.ini' found in the input #
# file with their respective values.    #
#########################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();
my $verbose = 1;
#################
# Begin Program #
#################
if($verbose){print(" out2dat\n");}

##############################
# Call Parser for each token #
##############################
foreach my $argnum (0 .. $#ARGV) {
    if($verbose){print("  Reading data from: " . $ARGV[$argnum] . "\n");}
    my $path = $usr . "/" . $ARGV[$argnum] . "/";
    system("rm -rf " . $path . "DAT");
    system("mkdir " . $path . "DAT");

    my @srcs = '';
    undef(@srcs);
    my @keys = tokenRead($path);
    foreach my $key (@keys){
	if ($key =~ /%/){
	    push(@srcs, substr($key, 1));  
	    undef $key;
	}
    }

    foreach my $src (@srcs){
	if($verbose){print("   Extracting: " . $src . "\n");}
	srcBuild($path, $src, @keys);
    }
}



#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################



############################
# Build data for given src #
############################
sub srcBuild {
    my ($path, $src, @keys) = @_;
    my ($out) = split('\.', $src);

    foreach my $key (@keys){
	if ($key){
	    parseFile($path . "OUT/" . $src,
		      $path . "DAT/" . clean($out) . "_" . clean($key) . ".dat",
		      "\"" . $key . "\"");
	}
    }
}

#####################################
# Find elements and build data file #
#####################################
sub parseFile {
    my $flag = $_[2];

    (my $flagA, my $flagB) = split(":", $flag);
    if ($flagB){
	$flagB = ":" . $flagB;
    }
    else {
	$flagB = " ";
    }

    my $opened = open(IN, $_[0]) or die("Could NOT open $_[0], failed");
    open(OUT, ">" . $_[1]);
    my @lines = <IN>;
    close IN;
    foreach my $line (@lines) {
	if (($line =~ /$flagA/) && ($line =~ /$flagB/)) {
	    my @words = split(" ", $line);
	    my $char = pop(@words);
	    if (($char !~ /[a-d]/) && ($char !~ /[f-z]/) && ($char !~ /[A-Z]/)) {
		print OUT $char . "\n";
	    }
	}
    }
    close OUT;
}

#############################
# Read tokens from data.ini #
#############################
sub tokenRead {
    open(DATA, $_[0] . "data.ini") or die("Could NOT open data.ini, failed");
    my @lines = <DATA>;
    chomp(@lines);
    close DATA;

    my @tokens;
    foreach my $line (@lines) {
	if ($line) {
	    push(@tokens, $line);
	}
    }
    return @tokens;
}

###########################
# Clean output file names #
###########################
sub clean {
    my $word = $_[0];
    $word =~ tr/:/_/;
    $word =~ tr/./_/;
    return $word;
}













