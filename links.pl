#!/usr/local/bin/perl -w

# Script Name		: links.pl
# Author				: Craig Richards
# Created				: 17th December 2007
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Creates softlinks for files 

if ($#ARGV !=1) {
  die "Usage : links.pl filetolink linkname NOTE : REMEMBER TO USE FULL PATHNAMES.\n";
}

use strict;

my $filetolink = $ARGV[0];
my $linkname   = $ARGV[1];

symlink($filetolink, $linkname) or die "link creation failed: $!";

print "link created ok!\n";

my $readlinkresult = readlink($linkname);
print "$linkname is a sym link to $readlinkresult\n";

## End of Script
