#!/usr/bin/env perl

###############
# Author: Satya
# This file converts the cell Gen output to a format acceptable by matlab and writes it to bitcellSizes.m
###############

use strict;

open(FILE, "./range.final") or die "ERROR: Could not open cell Gen ouput file for reading. Cell Generation may have failed\n $! \n";

open(OUT, ">./temp") or die "ERROR: Could not open temp file for writing\n $!\n";

# Strip the search details from output file
while (my $line = <FILE>) {

	if ($line =~ /^$/) {
		next;
	}

	if ($line !~ /RESULT SUMMARY/) {
		print OUT $line;
	}
	else {
		last;
	}
}
close(FILE);
close(OUT);

# Remove first line and sort by the 7th field (area) and get first line (min area cell out of all results)
system("grep -v LPG ./temp | sort -k7 | head -1 > ./cellGenOutput");
