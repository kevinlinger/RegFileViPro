#!/usr/bin/env perl

	my @val;
	my $usr = "./optOut_32k.txt";
	my $out = "./optOut_32k.dat";

	my $B;
	my $R;
	my $C;
	my $E;
	my $D;

	open(USR,"$usr") or die("Cant open $usr");
	open(OUT,">$out") or die("Cant open $out");
	while (my $line = <USR>) { 
		if ((@val) = ($line =~ /^\s*Change user.m, B=([0-9]+), R=([0-9]+), C=([0-9]+)/ ) ) {
			$B = shift @val;
			$R = shift @val;
			$C = shift @val;
		}
		$line = <USR>;
		if ((@val) = ($line =~ /\s*totalE:(\S*)\s*totalD:(\S*)/ ) ) {
			$E = shift @val;
			$D = shift @val;
			#print "E=$E, D=$D\n";
		}
		print OUT "$B $R $C $E $D\n";
	}
	close(USR);
	close(OUT);

