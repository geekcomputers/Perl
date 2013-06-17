#!/usr/local/bin/perl

# Script Name		: testDBI.pl
# Author				: Craig Richards
# Created				: 17th December 2007
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Tests DBI connection

use strict;
use DBI;

my $dbh = DBI->connect( 'dbi:Oracle:SID', 'scott', 'tiger',
                        {
                          RaiseError => 1,
                          AutoCommit => 0
                        }
                      ) || die "Database connection not made: $DBI::errstr";

## End of Script
