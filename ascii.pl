#!/usr/local/bin/perl

# Script Name   : ascii.pl

# Author        : Craig Richards
# Created       : 17th December 2007

# Version       : 1.0

# Modifications :

# Description   : Print the ASCII chart

# Instructions  :

print "A # has ASCII value ", ord("#"), "\n";
print "A * has ASCII value ", ord("*"), "\n";

$ascii = 000;
while ($ascii <= 128) {
  print "Ascii for $ascii is ", chr("$ascii"), "\n";
$ascii = $ascii + 1;}

## End of Script
