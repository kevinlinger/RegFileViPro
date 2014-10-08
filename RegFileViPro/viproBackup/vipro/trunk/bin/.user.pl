#!/usr/bin/env perl

sub checkEnv {
	my @wares = ('spectre','ocean','matlab');
	foreach my $ware(@wares) {
		my $check = `which $ware`;
		if ($check eq '') {
			die "ERROR: Please setup $ware environment first. Exiting...\n";
		}
	}	
}

sub inBin {
	my $cwd = getcwd();
	return ($cwd =~ s/device\/BIN//i);
}

sub checkInputs {
	print "VIPRO:Checking sanity of user inputs\n";
	my %parameters = ();

	open(USR, "$toolPath/configuration/user.m") or die "user.m not found $!\n";
	
	# Extract parameters to be checked
#	while (my $line = <USR>) {
#		chomp $line;
#		if ((my $memBase, my $memExp) = ($line =~ /^\s*memSize\s*=\s*(\d+)\^(\d+)/i)) {
#			$parameters{'memSize'}=eval($memBase**$memExp);
#		}
#	}
	$parameters{'rows'} = getParamFromUser('rows');
	$parameters{'cols'} = getParamFromUser('cols');
	$parameters{'wordSize'} = getParamFromUser('wordSize');
	$parameters{'memSize'} = getParamFromUser('memSize');

	if ($parameters{'rows'}*$parameters{'cols'} != $parameters{'memSize'}) {
		die "ERROR: Memory size specified in user.m doesn't match the number of rows and columns specified. Exiting...\n";
	}
	
	if ($parameters{'wordSize'} > $parameters{'cols'} ) {
		die "ERROR: Number of cols is less than word-size. Exiting...\n";
	}

	if ($parameters{'wordSize'} > 32 || $parameters{'wordSize'} < 0) {
		die "ERROR: Word size must be an integer between 0 and 32. Exiting...\n";
	}
	
	if ($parameters{'cols'}/$parameters{'wordSize'} > 8 || $parameters{'cols'}/$parameters{'wordSize'} < 1) {
		die "ERROR: Column mux must be either 1,2,4 or 8. Exiting... \n";
	}
	
	if ($parameters{'rows'} > 512 || $parameters{'rows'} < 8) {
		die "ERROR: Number of rows must be between 8 and 512. Exiting... \n";
	}
}

sub getParamFromUser {
	my $param = $_[0];
	my $val = '';
	open(USR, "$toolPath/configuration/user.m") or die "Cannot open user.m $!\n";
	while (my $line = <USR>) { 
		if (($val) = ($line =~ /^\s*$param\s*=\s*('?.+'?)/i)) {
			$val =~ s/;//;
			return $val;
		}
	}
	die "Parameter $param has not been defined or commented out in user.m. Exiting...\n" if ($val eq '');
}

1
