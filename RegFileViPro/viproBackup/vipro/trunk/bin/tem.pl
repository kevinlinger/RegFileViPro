# ViPro top-level script
# Satya Nalam
# 10/21/10

#!/usr/bin/env perl

require "user.pl";
require "char.pl";
require "optimizer.pl";
require "compiler.pl";

use strict;
use Getopt::Long;
use POSIX;
use Cwd;
use File::Copy;
use File::Path;
use Fcntl qw(:flock :seek);

our $usr = getlogin();
my ($cellGen,$char,$opt,$getMetrics,$genCustom,$compiler,$quiet,$clean);
my $runDir = getcwd();
(our $toolPath) = ($runDir =~ /(\/\S+\/trunk)/);
our $tasePath = getParamFromUser('tasePath');
$tasePath =~ s/'//g;


	#Calculate total energy and delay
	getED();

	open(TM, "$toolPath/files/topMetrics.txt") or die "Cannot open topMetrics.txt\n";
	my $freq;
	my $energy;
	my $val;
	while (my $line = <TM>) { 
		if (($val) = ($line =~ /^\s*(\S*)\s*Hz/i)) {
			$freq = $val;
		}
		if (($val) = ($line =~ /^\s*(\S*)\s*J/i)) {
			$energy = $val;
		}
	}
	#die "Parameter $param has not been defined or commented out in topMetrics.txt. Exiting...\n";

	chdir("$toolPath/files");
	open(OPT, ">>optOut.txt") or die("Cant open ./optOut.txt");
	#print OPT "R=$nRows, C=$nCols, Frequency = $freq, Energy = $energy\n";
	print OPT "Frequency = $freq, Energy = $energy\n";
	close(OPT);


