#!/usr/bin/env perl
use List::Util qw[min max];

sub appendTmgChainsToSizesTxt {

	chdir("$toolPath/compiler");

	# Get inverter LE params to calculate delay using Logical effort
	open(INV, "$tasePath/device/BIN/$usr/RVP_Inv_LEparams/data.txt") or die "Inverter LE params data.txt file not found in $usr/RVP_Inv_LEparams. $!\n";
	my @invLe = <INV>;
	my @invPars = split(/\s+/,$invLe[0]);
	my $tau = $invPars[0];
	my $p = $invPars[1];

	# Inverter single stage, single fanout delay
	my $invDelay = $tau*($p + 1)*1e-12;

	# optParams.txt is the file assumed to have the optimizer output. Assuming a format in which each line starts with a component name
	# followed by a list of numbers. E.g. for decoder, it is the address bits, n and k stages
	# For the buffer chains it is the number of stages and fanouts from the ctrl* data in files/
	open(OPT, "$toolPath/files/optParams.txt") or die "Optimizer output file optParams.txt not found in files/ $!\n";

	# Parse optimal decoder and buffer chain params
	my ($optAddr,$optN,$optK);
	my ($optCSEL,$optNPRECH,$optNSAPREC,$optSAE,$optWEN);
	my ($optCSELf,$optNPRECHf,$optNSAPRECf,$optSAEf,$optWENf);
	while (my $line = <OPT>) {
		$line =~ /^\s*decoder\s+(\d+)\s+(\d+)\s+(\d+)/;
		($optAddr,$optN,$optK) = ($1,$2,$3);
		
		$line =~ /^\s*ctrlBuf\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)/;
		($optCSEL,$optNPRECH,$optNSAPREC,$optSAE,$optWEN) = ($1,$2,$3,$4,$5);
		($optCSELf,$optNPRECHf,$optNSAPRECf,$optSAEf,$optWENf) = ($6,$7,$8,$9,$10);
	}
	#print "OY $optCSELf,$optNPRECHf,$optNSAPRECf,$optSAEf,$optWENf\n";
	#print "OY $optCSEL,$optNPRECH,$optNSAPREC,$optSAE,$optWEN\n";

	# Pre-decoder delay is one inverter + 2 and gates or 5 stages.
	#my $decDelay = $decP

	# Get DFF delay
	open(DFF, "$tasePath/device/BIN/$usr/RVP_DFF/data.txt") or die "DFF delay file $usr/RVP_DFF/data.txt not found. $!\n";
	my @dffDelayData = <DFF>;
	my @dffDelays = split(/\s+/,$dffDelayData[0]);
	my $dffDelay = $dffDelays[0];
	chomp($dffDelay);

	#Equivalent stage delay for DFF
	my $dffStages = floor($dffDelay/$invDelay);
	#print "DFF STAGES = $dffStages\n";

	# Get total number of stages between address and Predecode output of 3 LSB bits. THe predecode delay is 1 inverter and 2 ands or 5 stages in total. 
	my $totStages = roundEven($dffStages + 5);
	#print "TOTAL STAGES = $totStages\n";
	#my $totDecDelay = $dffDelay + $decDelay;

	# Total number of stages between CLK and final WL to bitcell
	#my $totStages = roundEven(floor($totDecDelay/$invDelay));

	# Get dlyWL stages using the WLEN path which is of known length except for the dlyWL buffer chain.
	# Each signal is buffered by 2 buffer chains, one of min-size and the other the actual buffer.
	# This is needed to equalize the total path lengths so that the control signals all come at roughly the same time to avoid glitches and functionality issues.
	# The min buffer chain is a token 2-stage (e.g. single buffer - smallest possible chain, since it can't be of zero length or the input of the second chain would be floating)
	# optN and optK have to be doubled as they are number of buffer stages
	my ($dlyWLstages,$dlySAEstages,$CSELstages,$NSAPRECstages,$SAEstages,$WENstages,$NPRECHstages);
	my $WLENstages = 2;
	if ($totStages > 6) {
		$dlyWLstages = $totStages-6;
	} else {
		$dlyWLstages = 2;
	}
	#print "DLYWL $dlyWLstages\n";

	# Calculate additional stages required for SAE delay chain
	$dlySAEstages = $dlyWLstages + roundEven(floor(200e-12/$invDelay));

	# Now deduce the lengths of the remaining buffer chains
	# Assuming that the SAE width is 200n - SHOULD CALCULATE THIS

	$CSELstages = $dlyWLstages + 10+2*($optK+$optN) - roundEven($dlyWLstages+6+$optCSEL);
	$NPRECHstages = $dlyWLstages + 10+2*($optK+$optN) - roundEven($dlyWLstages+2+$optNPRECH);
	$WENstages = $dlyWLstages + 10+2*($optK+$optN) - roundEven($dlyWLstages+4+$optWEN);
	my $minstages = min($CSELstages,$NPRECHstages,$WENstages);
	
	#If any of these turn out to be negative, add same number of extra stages to all so that the lowest one comes up to 2.
	if ($minstages <=0) {
		$WLENstages = roundEven($WLENstages + abs($minstages) + 2);
		$CSELstages = roundEven($CSELstages + abs($minstages) + 2);
		$NPRECHstages = roundEven($NPRECHstages + abs($minstages) + 2);
		$WENstages = roundEven($WENstages + abs($minstages) + 2);
	}
	
	## SAE and NSAPREC are dealt with differently
	## Get the SAE and NSAPREC buffer chain lengths by equalizing the total amount of buffering after the delay chains so that the SAE comes roughly at the end of the WL pulse
	if ( 9+2*$optK > 4+$optSAE ) {
		$SAEstages = roundEven((9+2*$optK) - (4+$optSAE));
	} else {
		$SAEstages = 2;
	}

	if ( 9+2*$optK > 6+$optNSAPREC ) {
		$NSAPRECstages = roundEven((9+2*$optK) - (6+$optNSAPREC));
	} else {
		$NSAPRECstages = 2;
	}

	#print to sizes.txt
	open(SIZ,">>$toolPath/files/sizes.txt") or die "Cannot open files/sizes.txt for writing timing buffer chain data. $!\n";

	print SIZ "dlyWL1stages $dlyWLstages\n";
	print SIZ "dlyWL1FanOut 1\n";
	print SIZ "dlyWL2stages 2\n";
	print SIZ "dlyWL2FanOut 4\n";
	print SIZ "dlySAEstages $dlySAEstages\n";
	print SIZ "dlySAEFanOut 1\n";
	print SIZ "NSAPREC1stages $NSAPRECstages\n";
	print SIZ "NSAPREC1FanOut 1\n";
	print SIZ "NSAPREC2stages $optNSAPREC\n";
	print SIZ "NSAPREC2FanOut $optNSAPRECf\n";
	print SIZ "WLEN1stages $WLENstages\n";
	print SIZ "WLEN1FanOut 1\n";
	print SIZ "WLEN2stages 2\n";
	print SIZ "WLEN2FanOut 4\n";
	print SIZ "SAE1stages $SAEstages\n";
	print SIZ "SAE1FanOut 1\n";
	print SIZ "SAE2stages $optSAE\n";
	print SIZ "SAE2FanOut $optSAEf\n";
	print SIZ "WEN1stages $WENstages\n";
	print SIZ "WEN1FanOut 1\n";
	print SIZ "WEN2stages $optWEN\n";
	print SIZ "WEN2FanOut $optWENf\n";
	print SIZ "NPRECH1stages $NPRECHstages\n";
	print SIZ "NPRECH1FanOut 1\n";
	print SIZ "NPRECH2stages $optNPRECH\n";
	print SIZ "NPRECH2FanOut $optNPRECHf\n";
	print SIZ "CSEL1stages $CSELstages\n";
	print SIZ "CSEL1FanOut 1\n";
	print SIZ "CSEL2stages $optCSEL\n";
	print SIZ "CSEL2FanOut $optCSELf\n";
	print SIZ "Nstages ".2*$optN."\n"; #optN and optK are in terms of buffer stages, so multiply by 2
	print SIZ "NFanOut 4\n";
	print SIZ "Kstages ".2*$optK."\n";
	print SIZ "KFanOut 4\n";

	close(SIZ); 
	close(INV);
	close(OPT);
	close(DEC);
}

# Function to round the number the number of stages to the next even number
sub roundEven {
	my $num = $_[0];
	$num = $num+1 if ($num%2 == 1);
	return $num;
}

sub convertTechFiles {
	my $techFile = $_[0];
	my $dispFile = $_[1];
	die "Tech file and Display.drf files must exist for layout generation\n" unless (-e $techFile && -e $dispFile);
	system(qq[cntechconv $techFile -o $toolPath/compiler/Santana.tech]) or die "ERROR: Ciranova Tech conversion cntechconv failed.$!\n";
	system(qq[cndispconv --cdstech=$techFile --cdsdisplay=$dispFile --santanatech=Santana.tech]) or die "ERROR: Ciranova Display conversion cndispconv failed.$!\n";
}

sub runCompiler {
	chdir "$toolPath/compiler"; 
	print "VIPRO:Running compiler\n";

	# Convert tech file and display file to Santana Format
	#my $tech = getParamFromUser('techFile');
        #my $display = getParamFromUser('displayFile');
	#convertTechFiles($tech,$display);
	
	# Call pycell to create library with SRAM layout
	#my $lib = "SRAM_ViPro";
	#system(qq[cngenlib --create --view --techfile "$tech" pkg:${lib}_source $lib $lib/]);
	
	# Call SKILL to create corresponding schematics
	# Now icfb will start & wrapper.il will execute and create all schematics.
	# These are created in the same library that pycell earlier created with layouts.
	#system('icfb -restore "./skill/darUvaEceSRAM_Schem.il"');

	# Generate Final GDS
	# oa2strm()????
}

sub outputResults {
	#print "Output the results\n";
}

1
