#!/usr/local/bin/perl

# Script Name		: printenv.pl
# Author				: Craig Richards
# Created				: 16th-July-2009
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Print the environment

print "Content-type: text/plain\n\n";
foreach $var (sort(keys(%ENV))) {
  $val = $ENV{$var};
  $val =~ s|\n|\\n|g;
  $val =~ s|"|\\"|g;
  print "${var}=\"${var}\"\n";
}

## End of Script
