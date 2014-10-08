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
my ($write_d, $write_e, $read_d,$read_e);
my ($cellGen,$char,$opt,$getMetrics,$genCustom,$compiler,$quiet,$clean);
my $runDir = getcwd();
(our $toolPath) = ($runDir =~ /(\/\S+\/trunk)/);
print $toolPath;
our $tasePath = getParamFromUser('tasePath');
$tasePath =~ s/'//g;

our $vdd = getParamFromUser('vdd');
#our $memSize = getParamFromUser('memSize');
#our $rowAddr = log(getParamFromUser('rows'))/log(2);
our $rowAddr;
our $memSize;

# Change to TASE device/BIN
chdir("$tasePath/device/BIN");

# Options to enable/disable various tool steps
GetOptions(  'cellGen'		=> \$cellGen,
             'char'		=> \$char,
	     'opt'		=> \$opt,
	     'genCustom'	=> \$genCustom,
	     'help|h'		=> sub { HELP_MESSAGE(); },
	     'quiet'		=> \$quiet,
	     'clean'		=> \$clean,
	     'compiler'		=> \$compiler);

# Determine whether to run sweeps or not in the characterization. Sweeps are not run if getting metrics for a fixed configuration
$getMetrics = getParamFromUser('getMetrics');

# Run tool only from BIN directory - should relax this
#die "Please run the tool from device/BIN.\n" unless inBin();

# Check setup
checkEnv();
checkInputs();

# Remove old output directory and create new one to hold outputs and intermediate files
if ($clean) {
	rmtree("$toolPath/files");
	mkpath("$toolPath/files");
}

if ($cellGen) {
	runCellGen();ar
	getCellGenData();
}

# Determine capacitances for running sweeps or getting metrics for particular configuration
if ($char) {

	my $nWord = 16;
	$memSize = 16 * (2 ** 10); #16KB memory 

	for(my $nBanks = 1; $nBanks <= 2; $nBanks*=2)
	{
	   for(my $nColMux = 8; $nColMux <= 8; $nColMux*=2)
	   {	
		my $nRows = $memSize / ($nBanks * ($nColMux * $nWord));
		
		$rowAddr = log($nRows)/log(2);
			
		#Check $nRows is between 8-512
		if($nRows < 16 || $nRows > 512) {
			next;
		}

	my $usr = "$toolPath/configuration/user.m";
	open(USR,"$usr") or die("Cant open $usr");
	my @lines = <USR>;
	close(USR);

	# format has changed
	open(USR,">$usr");
        foreach my $line (@lines) {
	        chomp $line;
                $line =~ s/rows\s*=\s*[0-9]+/rows = $nRows/;
                $line =~ s/colMux\s*=\s*[0-9]+/colMux = $nColMux/;
                $line =~ s/banks\s*=\s*[0-9]+/banks = $nBanks/;
                $line =~ s/memSize\s*=\s*[0-9]+/memSize = $memSize/;
                $line =~ s/wordSize\s*=\s*[0-9]+/wordSize = $nWord/;
                print USR "$line\n";
        }
	close(USR);

	chdir("$toolPath/bin");
	open(OPT, ">>./optOut.txt");
	print OPT "Change user.m, B=$nBanks, R=$nRows, C=$nColMux\n";
	close(OPT);

	# Get metal parasitics
	getMetalParasitics();

	my $tech = getParamFromUser('technology');
	$tech =~ s/'//g;
	die "Technology string must be specified in user.m.\n" unless $tech;
	my $iniTpl = "$tasePath/template/RVPtpl_$tech.ini";

	# Characterization of MOS gate capacitance and inverter delay needed for timing block characterization
	my $ini = "$tasePath/template/RVP_$tech.ini";
	appendTestsToIni($iniTpl,$ini,'scs','','ocn','RVP_Gate_Capacitance');
	print "VIPRO:Running Gate capacitance characterization for $tech\n";
	runChar($quiet, $ini);	
	die "Unable to estimate gate capacitance for $tech. If the gate capacitance simulation was successful but the output file is empty, please adjust the sweep range for gate capacitance in $ini and retry. Exiting...\n" unless checkCapSimStatus();

	# Determine value of BL differential required based on 3-sigma offset and Iread/Ileak
	
	# Characterization of SRAM components
	my $iniBc = "$tasePath/template/RVPBC_$tech.ini";
	appendBitcell($iniTpl,$iniBc);

	# add the capacitances to the .ini file
	addCaps($iniBc);
	addGateCap($iniBc);
	
	my @scsTests = qw(RVP_Ileak_PU RVP_Ileak_PD RVP_Ileak_PG);
	my @ocnTests = qw(RVP_DFF  RVP_TIMING RVP_CD RVP_SA RVP_Bank_Mux RVP_Decoder); 


	# modify memory specs and make char flag zero. Append only relevant decoder test
	modifyParams($iniBc,0);
	
	appendTestsToIni($iniBc,$ini,'scs',@scsTests,'ocn',@ocnTests);
		
	#Run characterizer for user-specified configuration
	print "VIPRO:Running characterization for user configuration\n";
	runChar($quiet, $ini);

	($write_d, $write_e, $read_d, $read_e)=getED();
	
	my $energy = $write_e + $read_e;
	my $delay = max($write_d,$read_d);

	chdir "$toolPath/bin";
        open(OPT, ">>./optOut.txt");
	#print OPT "B=$nBanks, R=$nRows, C=$nColMux\n";
	print OPT "wdelay:$write_d\twenergy:$write_e\trdelay:$read_d\trenergy:$read_e\t\ttotalE:$energy\ttotalD:$delay\n";
	close(OPT);

	chdir "$tasePath/device/BIN";
	#system("rm -fr plb3qt*");
     }
    }
}

if ($opt) {
	runOptimizer();
	getOptData();
}

if ($compiler) {

	# If user wants to generate a completely specified memory then no need to generate the sizes.txt file. It should be provided by the user
	appendTmgChainsToSizesTxt() unless ($genCustom);

	runCompiler();
}

outputResults();

###################
sub HELP_MESSAGE {
	print "\nUSAGE:\n ";
	print "perl ViPro.pl [Options]\n\n";
	print "OPTIONS:\n";
	print "--cellGen	- Run bitcell generator\n\n";
	print "--char		- Run characterization This is done at least once whether performing optimizationor using in the get metrics mode.\n\n";
	print "--opt		- Run optimization engine. Currently inactive.\n\n";
	print "--compiler	- Run memory compiler. Currently the generator resides in the compiler/ directory but is not callable yet from ViPro.pl\n\n";
	print "--genCustom	- Only generate custom specified schematics and layout. Useful for just generating a completely specified memory skipping the characterization and optimization part. The sizes.txt file needs to be specified by the user\n\n";
	print "--h,--help	- Display help message\n\n";
	print "--quiet		- Reduce verbosity of screen output\n\n";
	print "--clean		- Remove files/ directory prior to starting a new run of ViPro.pl\n\n";
	print "Options are case-insensitive and can be used with '-' instead of '--' as well\n\n";
	exit;
}

