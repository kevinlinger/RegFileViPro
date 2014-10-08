#!/usr/bin/env perl

my $start = time;
my $index;

for($index=0; $index < 100000000; $index++){
 my $r = 10 + $index;
}

my $t = time - $start;
print "Time Taken = $t\n";
