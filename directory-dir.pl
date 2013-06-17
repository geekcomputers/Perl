#!/usr/local/bin/perl

# Script Name		: directory_dir.pl
# Author				: Craig Richards
# Created				: 17th December 2007
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Displays the contents of the dir shows the permissions you have to the file and if you are the owner 

use strict;

print "Contents of the current directory:\n";
opendir DH, "." or die "Couldn't open the current directory: $!";
while ($_ = readdir(DH)) {
    next if $_ eq "." or $_ eq "..";
    print $_, " " x (30 - length($_));
    print "d" if -d $_;
    print "r" if -r _;
    print "w" if -w _;
    print "x" if -x _;
    print "o" if -o _;
    print "\t";
    print -s _ if -r _ and -f _;
    print "\n";
}
closedir DH;

## End of Script
