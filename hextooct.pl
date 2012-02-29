#!/usr/local/bin/perl -w

# Script Name   : hextooct.pl

# Author        : Craig Richards
# Created       : 17th December 2007

# Version       : 1.0

# Modifications :

# Description   : Asks for a hexadecimal number and converts to decimal, then converts an octal to decimal
#		  i.e. FF is 255 for hex 377 octal is 255 decimal

# Instructions  :


use strict;

print "enter a hex number: ";
chomp(my $hexnum = <STDIN>);
print "converted to an int: ", hex($hexnum), "\n";

print "enter a octal number: ";
chomp(my $octal = <STDIN>);
print "converted to an int: ", oct($octal), "\n";

## End of Script
