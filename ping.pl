#!/usr/local/bin/perl

# Script Name		: ping.pl
# Author				: Craig Richards
# Created				: 17th December 2007
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Ping a certain subnet, ping all addresses

$subnet = 000;
while ($subnet <= 255) {
  system("ping 170.198.42.$subnet");
$subnet = $subnet + 1;}

## End of Script
