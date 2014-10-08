#!/usr/bin/env perl
sub getMetalParasitics {
	my $tech = getParamFromUser('technology');
	(my $techNum) = ($tech =~ /(\d+)/);
	print "VIPRO:Getting Metal parasitic values for $tech\n";
	
	chdir("$toolPath/model");
	system("matlab -nodesktop -nosplash -r \"getParasitics(\'$toolPath\',$techNum)\"");
	die "Failed to get parasitics because getParasitics.m failed to execute: $!\n" if ( $? == -1 );
}

sub addCaps {
	my $ini = $_[0];
	open(PAR,"$toolPath/files/parasitics.txt") or die "Cannot open parasitics.txt $!\n";
	
	my @parInt = <PAR>;
	
	#2nd line is the intermediate level metal cap, which we will use for the WL and BL and parallel control signals
	my @pars = split(/\s+/,$parInt[1]);
	my $capInt = $pars[1];
	my $resInt = $pars[0];	
	
	my $bcHeight = getParamFromUser('height');
	my $bcWidth = getParamFromUser('width');
	my $rbl = $resInt*$bcHeight*1e6;
	my $cbl = $capInt*$bcHeight*1e6;
	my $cwl = $capInt*$bcWidth*1e6;


	open(INI,">>$ini") or die "Cannot open $ini for writing metal capacitance values.\n";
	print INI "\n####################\n";
	print INI "# Metal Parasitics\n";
	print INI "####################\n";
	print INI "<rbl>\t$rbl\n";
	print INI "<cbl>\t$cbl\n";
	print INI "<cwl>\t$cwl\n";
	close(INI);	
}

sub addGateCap {
	my $ini = $_[0];
	open(GATECAP, "$tasePath/device/BIN/$usr/RVP_Gate_Capacitance/data.txt") or die "Gate capacitance data.txt file not found in $usr/RVP_GATE_CAPACITANCE. $!\n";
	my @gateCap = <GATECAP>;
	my $cg = $gateCap[0];
	
	open(INI, ">>$ini") or die "Cannot open $ini for writing gate capacitance value.\n";
	print INI "<cg>\t$cg";
	close(INI);
}

sub getTmgBufChainParams {
	my $toolpath = "\'" . $toolPath . "\'";

	my $memSize = getParamFromUser('memSize');
	my $ws = getParamFromUser('wordSize');
	my $wdef = getParamFromUser('wdef');
	
	open(PAR,"$toolPath/files/parasitics.txt") or die "Cannot open parasitics.txt $!\n";
	my @parInt = <PAR>;
	my @pars = split(/\s+/,$parInt[1]);
	my $capInt = $pars[1];
	
	my $bcHeight = getParamFromUser('height');
	my $bcWidth = getParamFromUser('width');
	my $cbl = $capInt*$bcHeight*1e6;
	my $cwl = $capInt*$bcWidth*1e6;
	
	open(GATECAP, "$tasePath/device/BIN/$usr/RVP_Gate_Capacitance/data.txt") or die "Gate capacitance data.txt file not found in $usr/RVP_GATE_CAPACITANCE. $!\n";
	my @gateCap = <GATECAP>;
	my $cg = $gateCap[0];
	chomp $cg;
	
	chdir "$toolPath/model";
	system('matlab -nodesktop -nosplash -r "bufChainOpt(' . ${toolpath} . ',' . ${memSize} . ',' . ${ws} . ',' . ${cwl} . ',' . ${cbl} . ',' . ${cg} . ',' . ${wdef} . ')"');
}

sub genTmgBufChainTemplates {
	rmtree("$tasePath/device/TESTS/RVP_bufChains");
	system("cp -rf $tasePath/device/TESTS/RVPtpl_bufChains $tasePath/device/TESTS/RVP_bufChains");
	die "Failed to copy buffer chain template directory RVPtpl_bufChains to RVP_bufChains: $!\n" if ( $? == -1 );
	
	open(NTL,">$tasePath/device/TESTS/RVP_bufChains/netlist") or die "Cannot open file for writing netlist in RVP_bufChains\n";
	
	my @sigs = qw(CMUX PCH SAPCH SAE WEN);
	my @stages;
	my @fout;

	print NTL "//Auto generated netlist for buffer chain characterization\n\n";

	open(NSTG, "$toolPath/files/ctrlBufChains_n.txt") or die "not found\n";
	while(<NSTG>) {
		push @stages,[ split ];
	}
	close(NSTG);

	open(FOUT, "$toolPath/files/ctrlBufChains_f.txt") or die "not found\n";
	while(<FOUT>) {
		push @fout,[ split ];}
	close(FOUT);

	print NTL  "//============================================\n";
	print NTL  "// Define VDD and VSS\n";
	print NTL  "//============================================\n";
	print NTL  "VVDD (VDD 0) vsource dc=pvdd\n";
	print NTL  "VVSS (VSS 0) vsource dc=0\n\n";

	print NTL  "//Input voltages\n";
	for (my $i=0;$i<5;$i++) {
		for(my $j=0;$j<4;$j++) {
			print NTL  "V$sigs[$i]$j ($sigs[$i]_IN$j 0) vsource type=pulse val0=0 val1=pvdd rise=prise fall=pfall width=pwidth\n";
		}
		print NTL  "\n";
	}

	print NTL  "\n//Inverter subcircuit\n";
	print NTL  "subckt INV OUT IN VDD VSS\n";
	print NTL  "parameters i\n";
	print NTL  "MP (OUT IN VDD VDD) P_TRANSISTOR width=i*wdef length=ldef\n";
	print NTL  "MN (OUT IN VSS VSS) N_TRANSISTOR width=i*wdef length=ldef\n";
	print NTL  "ends INV\n\n";

	for (my $i=0;$i<5;$i++) {
		for (my $j=0;$j<4;$j++) {
			print NTL  "//$sigs[$i] inverter chain subckt for col-mux of ";
			print NTL  2**$j;
			print NTL  "\n";
			print NTL  "subckt INVCHAIN_$sigs[$i]$j OUT IN VDD VSS\n";
			my $num = $stages[$j][$i];
			if ($stages[$j][$i] % 2 == 0) {
				if ($stages[$j][$i] == 2) {
					print NTL "IO (X1 IN VDD VSS) INV i=1\n";
					print NTL "I1 (OUT X1 VDD VSS) INV i=";
					print NTL $fout[$j][$i];
					print NTL "\n";
				} else {
					print NTL  "I0 (X1 IN VDD VSS) INV i=1\n";
					print NTL  "I1 (X2 X1 VDD VSS) INV i=1\n";
					for(my $k=2;$k<$num-1;$k++) {
						print NTL  "I$k (X";
						print NTL  ${k}+1;
						print NTL  " X$k VDD VSS) INV i=";
						print NTL  $fout[$j][$i]**($k-1);
						print NTL  "\n";
					}
					print NTL  "I";
					print NTL  $num-1;
					print NTL  " (OUT X";
					print NTL  $num-1;
					print NTL  " VDD VSS) INV i=";
					print NTL  $fout[$j][$i]**($stages[$j][$i]-2);
					print NTL  "\n";
				}
			} else {
				print NTL  "I0 (X1 IN VDD VSS) INV i=1\n";
				for (my $k=1;$k<$num-2;$k++) {
					print NTL  "I$k (X";
					print NTL  ${k}+1;
					print NTL  " X$k VDD VSS) INV i=";
					print NTL  $fout[$j][$i]**$k;
					print NTL  "\n";
				}
				print NTL  "I";
				print NTL  $num-2;
				print NTL  " (OUT X";
				print NTL  $num-2;
				print NTL  " VDD VSS) INV i=";
				print NTL  $fout[$j][$i]**($stages[$j][$i]-2);
				print NTL  "\n";
			}
			print NTL  "ends INVCHAIN_$sigs[$i]$j\n\n";

		}
		print NTL  "\n";
	}

	for (my $i=0;$i<5;$i++) {
		for (my $j=0;$j<4;$j++) {
			print NTL  "I$sigs[$i]$j ($sigs[$i]_OUT$j $sigs[$i]_IN$j VDD VSS) INVCHAIN_$sigs[$i]$j\n";
		}
		print NTL  "\n";
	}
	print NTL  "\n";

	for (my $j=0;$j<4;$j++) {
		# CMUX energy has to be counted twice, once for each of CS and NCS
		print NTL  "CMUX$j (CMUX_OUT$j 0) capacitor c=(2**$j)*ws*cwl+2*ws*6*wdef*cg*1e6\n";
		print NTL  "CPCH$j (PCH_OUT$j 0) capacitor c=(2**$j)*ws*cwl+3*(2**$j)*ws*6*wdef*cg*1e6\n";
		print NTL  "CSAPCH$j (SAPCH_OUT$j 0) capacitor c=(2**$j)*ws*cwl+2*ws*5*wdef*cg*1e6\n";
		print NTL  "CSAE$j (SAE_OUT$j 0) capacitor c=(2**$j)*ws*cwl+7*ws*wdef*cg*1e6\n";
		print NTL  "CWEN$j (WEN_OUT$j 0) capacitor c=(2**$j)*ws*cwl+ws*4*wdef*cg*1e6\n";
		print NTL  "\n";
	}
	print NTL "\nmyOption options pwr=all\n";
	close(NTL);
}

sub appendTestsToIni {
	my @scsTestList;
	my @ocnTestList;
	my $testType;
	
	my $iniTpl = shift @_;
	my $ini = shift @_;
	
	$testType = shift @_;
	my @remArgs = @_;
	
	if ($testType eq 'scs') {
		while ($remArgs[0] ne 'ocn') {
			push (@scsTestList, shift @remArgs);
		}
		shift @remArgs;
		@ocnTestList = @remArgs;
	} else {
		while ($remArgs[0] ne 'scs') {
			push (@ocnTestList, shift @remArgs);
		}
		shift @remArgs;
		@scsTestList = @remArgs;
	}
	
	open(INITPL,"$iniTpl") or die "Exec file template $iniTpl doesn't exist\n";
	open(INI, ">$ini") or die "Exec file template $ini doesn't exist\n";
	
	while (my $line = <INITPL>) {
		print INI $line;
	}
	print INI "\n#############################\n";
	print INI "# TEST CASE SELECTION\n";
	print INI "#############################\n";
	
	if (@scsTestList) {
		print INI "<scs>\n";
		for (my $i=0; $i < scalar @scsTestList; $i++) {
			print INI "$scsTestList[$i]\n";
		}
		print INI "</scs>\n\n";
	}
	
	if (@ocnTestList) {
		print INI "<ocn>\n";
		for (my $i=0; $i < scalar @ocnTestList; $i++) {
			print INI "$ocnTestList[$i]\n";
		}
		print INI "</ocn>\n";
	}
	
	close(INI);
	close(INITPL);
}

sub checkCapSimStatus {
	return (-s "$tasePath/device/BIN/$usr/RVP_Gate_Capacitance/data.txt");
}

sub appendBitcell {
	my ($ini,$iniBC) = @_;
	open(CELL,"$toolPath/configuration/bitcellSizes.m") or die "bitcellSizes.m not found.$!\n";
	open(INI, "$ini") or die "Exec file template $ini doesn't exist\n";
	open(INIBC, ">$iniBC") or die "Exec file $iniBC cannot be opened for writing. $!\n";
	
	print INIBC "#############################\n";
	print INIBC "# Bitcell device dimensions\n";
	print INIBC "#############################\n";
	
	while (my $line = <CELL>) {
		$line =~ s/\s*=\s*/> /;
		$line =~ s/^\s*/</;
		$line =~ s/;//;
		print INIBC $line;
	}
	print INIBC "\n";
	
	while (my $line = <INI>) {
		print INIBC $line;
	}
	close(CELL);
	close(INI);
	close(INIBC);
	return;
}

sub modifyParams {
	my $ini = $_[0];
	my $char = $_[1];
	
	#map between user.m and template parameters
	my %paramMap = (
		'SAoffset'  =>  'BL_DIFF',
		'arbits'    => 'addrRow',
		'acbits'    => 'addrCol',
		'banks'    => 'numBanks',
		'cols'	=>	'NC_sweep',
		'rows' => 'NR_sweep',
        	'colMux' => 'colMux',
		'wordSize'   => 'ws',
        	'vdd'  => 'pvdd',
		'vsub' => 'pvbp',
		'temp' => 'temp',
		'memSize' => 'memsize'
	);
	my @userKeys = keys %paramMap;
	my @iniValues = values %paramMap;
	
	#Subsitute the corresponding parameters in the .ini file
	for (my $i=0; $i < scalar @userKeys; $i++) {
		my $paramValue=0;
		#print "$userKeys[$i]\n";
		if($userKeys[$i] eq 'arbits'){
			$paramValue = log(getParamFromUser('rows'))/log(2);
		}
		elsif($userKeys[$i] eq 'acbits'){
			$paramValue = log(getParamFromUser('colMux'))/log(2);
		}
		elsif($userKeys[$i] eq 'cols'){
			$paramValue = getParamFromUser('wordSize')*getParamFromUser('colMux');
		}
		else{
			$paramValue = getParamFromUser($userKeys[$i]);
		}		
		open(INI,"$ini");
		my @lines = <INI>;
		close(INI);

		open(INI,">$ini");
		foreach my $line (@lines) {
			chomp $line;
			$line =~ s/<$iniValues[$i]>\s+\S*/<$iniValues[$i]>\t$paramValue/;
			print INI "$line\n";
		}
		close(INI);	
	}
	
	#Add the char flag and set appropriately
	open(INI,">>$ini");
	if ($char == 0) {
		print INI "<char>\t0\n";
	}
	else {
		print INI "<char>\t1\n";
	}
	close(INI);
}

sub runChar {
	my $quiet = $_[0];
	my $iniBC = $_[1];
	
	chdir "$tasePath/device/BIN";
	print "VIPRO:Running characterizer\n";
	if ($quiet) {system("perl", "run.pl", "-nopdf", "-quiet", "-i", "$iniBC");}
	else {system("perl", "run.pl", "-nopdf", "-i", "$iniBC");}
	
	die "Characterizer run failed: $!\n" if ( $? == -1 );
}

1
