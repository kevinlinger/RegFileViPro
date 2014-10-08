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
    
######################################
# Build a PDF Document from IMG Data #
######################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();
my $verbose=1;

#################
# Begin Program #
#################
print(" img2pdf\n");

open(HEAD, $usr . "/default.tex") or die("Could NOT open " . $usr . "/default.tex, failed");
my @latex = <HEAD>;
chomp @latex;
close HEAD;

# Generate LaTeX Code #
my @latex = findReplace($usr, @latex);
foreach my $argnum (0 .. $#ARGV) {
    print("  Compiling Report Data From: " . $ARGV[$argnum] . "\n");
    my $path = $usr . "/" . $ARGV[$argnum] . "/IMG";
    opendir(DIR, $path) or die("Can't opendir " . $path . ", failed");
    while (defined(my $file = readdir(DIR))) {
	if (($file ne '.') && ($file ne '..')) {
	    @latex = (@latex, configTex($file, $ARGV[$argnum], $usr));
	}
    }
    closedir(DIR);
}

# Write LaTeX File #
open(OUT, ">" . $usr . "/output.tex");
foreach my $line (@latex) {
    print OUT $line . "\n";
}
print OUT "\\end{document}\n";
close OUT;

# Build PDF #
buildPDF($usr);


#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################



#########################
# Configure LaTeX Files #
#########################
sub configTex {
    my $file = $_[0];
    my $name = $_[1];
    my $usr  = $_[2];
    my @sub  = '';

    @sub[0]  = "";
    @sub[1]  = "% RESULT PAGE %";
    @sub[2]  = "\\begin{figure}";
    @sub[3]  = "\\begin{center}";
    @sub[4]  = "\\framebox{";
    @sub[5]  = " \\epsfxsize=5in";
    @sub[6]  = " \\epsffile{" . $name . "/IMG/" . $file . "}";

    chop($file);chop($file);chop($file);chop($file);
    $name =~ s/_/-/g;
    $file =~ s/_/-/g;

    @sub[7]  = "}";
    @sub[8]  = "\\caption{" . $name . ": " . $file . "}";
    @sub[9] = "\\end{center}";
    @sub[10] = "\\end{figure}";
    @sub[11] = "\\clearpage";
    @sub[12] = "";

    return @sub;
}

############################
# Build the Final PDF File #
############################
sub buildPDF {
    my $usr = $_[0];

    chdir($usr);
    system("latex ./output.tex > latex.log") == 0
	or die("system call 'latex' on output.tex failed");
    system("latex ./output.tex > latex.log");
    system("dvips output.dvi -q > latex.log") == 0
	or die("System call 'dvips' on output.dvi failed");
    system("ps2pdf output.ps > latex.log") == 0
	or die("System call 'ps2pdf' on output.ps failed");
    #system("rm -f latex.log");
    chdir("..");
}

####################
# Extract PDK Data #
####################
sub findReplace {
    (my $usr, my @latex) = @_;
    open(MAP, $usr . "/config.ini") or die("Could NOT open config.ini, failed");
    my @lines = <MAP>;
    close MAP;
    
    my $pdk = '';
    chomp(@lines);
    foreach my $line (@lines) {
	my @words = split(" ", $line);
	if (@words[0] eq "<pdk>") {
	    $pdk = pop(@words);
	}
    }
    my $ver = cvsVersion("run.pl");

    foreach my $line (@latex) {
	$line =~ s/<pdk>/$pdk/;
	$line =~ s/-/\\-/;
	$line =~ s/<usr>/$usr/;
	$line =~ s/<ver>/$ver/;
    }
    
    return @latex;
}

##########################
# Get CVS Version Number #
##########################
sub cvsVersion {
    my $File = $_[0];
    my $ver = "";
    #my $Cvs =~ s/[^\/]+$//g;
    my $Cvs;
    $Cvs =~ s/[^\/]*$//g;
    $Cvs = $ENV{'DOCUMENT_ROOT'} . $Cvs . "CVS/Entries"; 
    my $Match = "";
    open(FILE,$Cvs);
    while (my $Line = <FILE>) {
	if ($Line =~ /$File/) {$Match = $Line; chomp $Line}
    }
    close FILE;

    if ($Match ne ""){
	my ($Junk,$File,$Version,$Date,@Junk) = split(/\//, $Match);
	$ver = "ACoP Version: " . $Version . "\\\\";
    }
    return $ver;
}
