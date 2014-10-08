#!/usr/bin/env perl
sub runCellGen {
	print "VIPRO:Running Cell Generator\n";
}

sub getCellGenData {
	print "VIPRO:Getting cell generator data\n";
}

sub optimizeBruteForce{
	chdir "$toolPath/model";
	print "Running brute force optimization\n";
	
	system("matlab -nodesktop -nosplash -r \"optimizeBruteForce($energyConstraint,$delayConstraint)\"");

}
#function [write_delay, write_energy, read_delay, read_energy] = getED(tasePath, userid, vdd, memSize,numRows,breakDown)
sub getED {
	my $write_d, $write_e, $read_d,$read_e;
	chdir "$toolPath/optimizer";
	print "VIPRO:Getting E and D for user-specified SRAM configuration\n";
	
	system("matlab -nodesktop -nosplash -r \"getED(\'$tasePath\',\'$usr\',\'$vdd\',\'$memSize\',\'$rowAddr\',0)\"");
	die "Failed to get metrics because getED.m failed to execute: $!\n" if ( $? == -1 );
 	open (FILE, 'data.txt');
	while (<FILE>) {
		chomp;
		($write_d, $write_e, $read_d,$read_e) = split("\t");
	}
	close (FILE);	
	return($write_d, $write_e, $read_d,$read_e);
}

sub runOptimizer {
	print "VIPRO:Running Optimizer\n";
}

sub getOptData {
	print "VIPRO:Getting optimization results\n";
}

1
