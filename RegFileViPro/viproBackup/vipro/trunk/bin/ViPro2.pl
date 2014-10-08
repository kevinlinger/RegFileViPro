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
our $memSize = getParamFromUser('memSize');
our $rowAddr = log(getParamFromUser('rows'))/log(2);

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

    open(OUT, ">output.txt");

    # the probability
    my $alpha =0.999;
    my $temperature = 400.0;
    my $eps = 0.001;
    my $iteration = 0;
    my $curr_cost = 1e10;
    my $best_cost = 1e10;
    my $cur_var = 1;
   

    # while the temperature did not reach eps
    while ($temperature > $eps && $iteration < 100) {

        ++$iteration;
   
        # get the next random permutation of distances
    $ran = int(rand(2));

    # choose either to incr or decrement
        if ($ran == 0) {
           $ran = -1;
    }
        $new_var = $cur_var + $ran;

    if ($new_var > 20) {
      $new_var = 20;
   
    } elsif ($new_var < 1) {
          $new_var = 1;
    }
       
        $new_cost = getCost($new_var);   

        # compute the distance of the new permuted configuration
        $delta = $new_cost - $curr_cost;

        # if the new cost is smaller accept it and assign it
        if ($delta<0) {
         $cur_var = $new_var;
        $curr_cost = $new_cost;
        if ($new_cost < $best_cost) {
               $best_cost = $new_cost;           
        }
        } else {
            $proba = rand();
            # if the new cost is worse accept
            # it but with a probability level
            # if the probability is less than
            # E to the power -delta/temperature.
            # otherwise the old value is kept
            if ($proba < $e ** (-$delta/$temperature)) {
        $cur_var = $new_var;
            $curr_cost = $new_cost;
          }
     }

        # cooling process on every iteration
        $temperature = $temperature * $alpha;
   
    print OUT "iteration=$iteration, var=$cur_var, cur=$curr_cost, best=$best_cost\n";

   }

close(OUT);

	my $nWord = 16;
	my $memSize = 2 ** 10; #1KB memory 

	for(my $nBanks = 1; $nBanks <= 16; $nBanks*=2)
	{
	   for(my $nColMux = 1; $nColMux <= 8; $nColMux*=2)
	   {	
		my $nRows = $memSize / ($nBanks * ($nColMux * $nWord));
			
		#Check $nRows is between 8-512
		if($nRows < 16 || $nRows > 512) {
			next;
		}
	
	my $usr = "$toolPath/configuration/user.m";
	open(USR,"$usr") or die("Cant open $usr");
	my @lines = <USR>;
	close(USR);

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

	($write_d, $write_e, $read_d,$read_e)=getED();
	
        open(OPT, ">>./optOut.txt");
	print OPT "B=$nBanks, R=$nRows, C=$nColMux\n";
	print OPT "wdelay:$write_d\twenergy:$write_e\trdelay:$read_d\trenergy:$read_e\n";
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

