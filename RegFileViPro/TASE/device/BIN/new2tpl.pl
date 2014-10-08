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
# Configure new user to prevent concurency #
# issues. This allows for multiple users   #
# to utilize the same tool.                #
############################################
# GLOBAL VARIABLES #
####################
my $usr = getlogin();
my @time = localtime(time);
my $verbose=1;
my $time_stamp = getTimeStamp(@time);

#################
# Begin Program #
#################
if($verbose){print(" new2tpl\n");}
if (-d $usr) {
  system("mv ".$usr . " ". $time_stamp);
}
system("mkdir " . $usr);

#########################
# Generate global files #
#########################
system("mv ../" . $usr . ".ini " . $usr . "/config.ini");
system("cp SRC/default.* " . $usr . "/");

########################
# Generate Test Copies #
########################
my $k=$#ARGV;
my $tests_path = "../TESTS/";
if($ARGV[-1] =~ /TESTS/){
  $k--;
  $tests_path = $ARGV[-1];
  print $tests_path;
}
  
foreach my $argnum (0 .. $k) {
    if($verbose){print("  Initializing test: " . $ARGV[$argnum] . "\n");}
    my $tar = $usr . "/" . $ARGV[$argnum];
    my $src = $tests_path . $ARGV[$argnum];

    if (-e $src && -d $src) {
	system("mkdir " . $tar);
	system("cp -r " . $src . "/* " . $tar);
    }
    else {
      print("Invalid test name: " . $ARGV[$argnum] . "\n");
    }
}
#########################################
##                                     ##
##   H E L P E R   F U N C T I O N S   ##
##                                     ##
#########################################
sub getTimeStamp {
   my $year = $_[5] + 1900;
   my $month = $_[4] + 1;
   my $date = $_[3];
   my $hour = $_[2];
   my $minute = $_[1];
   my $second = $_[0];
   if(length($_[4]) == 1) {
     $month = "0".$month;
   }
   if(length($_[3]) == 1) {
     $date = "0".$date;
   }
   if(length($_[2]) == 1) {
     $hour = "0".$hour;
   }
   if(length($_[1]) == 1) {
     $minute = "0".$minute;
   }
   if(length($_[0]) == 1) {
     $second = "0".$second;
   }

   return $usr."_".$year.$month.$date."_".$hour.$minute.$second;
}
