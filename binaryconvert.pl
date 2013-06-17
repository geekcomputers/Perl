#!/usr/local/bin/perl -w

# Script Name		: binaryconvert.pl
# Author				: Craig Richards
# Created				: 17th December 2007
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Asks for a decimal number less than 256 and converts it to binary.

use strict;

print "Please enter a value less than 256: ";
chomp(my $bin = <STDIN>);

print((128 & $bin) / 128);
print((64 & $bin) / 64);
print((32 & $bin) / 32);
print((16 & $bin) / 16);
print((8 & $bin) / 8);
print((4 & $bin) / 4);
print((2 & $bin) / 2);
print((1 & $bin) / 1);
print "\n";

## End of Script
