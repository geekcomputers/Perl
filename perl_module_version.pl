#!/usr/local/bin/perl -w

# Script Name		: perl_module_version.pl
# Author				: Craig Richards
# Created				: 12th December 2007
# Last Modified		: 
# Version				: 1.0

# Modifications		: 
# Description			: Shows the version of the perl modules, when the module is passed to the script

use strict;

##########################################################################################
# The code below checks to see if a perl module was passed to it, if not the script dies #
##########################################################################################

if ($#ARGV !=0) {
  die "Usage: perl_module_version.pl PERL_MODULE     eg perl_module_version.pl DBI.\n";
}

foreach my $module ( @ARGV ) {
  eval "require $module";
  printf( "%-20s: %s\n", $module, $module->VERSION ) unless ( $@ );
}

## End of Script
