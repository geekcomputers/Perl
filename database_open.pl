#!/usr/local/bin/perl -w

# Description : This is the program to analyze the alert log
#               file and print out diagnostics.
# Developer   : Manoj Murumkar
# Date        : 5/29/2001

format top =
                 Database Opening Report
                 +++++++++++++++++++++++
 Time                                    OPEN MODE
 __________________                      _________
.
format STDOUT =
@<<<<<<<<<<<<<<<<<<                      @<<<<<<<<<<<<
substr("$TEST",0,19), $SEQ[$#$SEQ]
.
print "Oracle Home : $ENV{ORACLE_HOME} \n";
print "Oracle Sid  : $ENV{ORACLE_SID} \n";

if ( ! $ENV{"ALERT"} ) {
  print "Set environment variable ALERT to Alert Log file location ! \n";
  exit(1);
}

open (FH,$ENV{"ALERT"});
while (<FH>) {
    if (/Mon|Tue|Wed|Thu|Fri|Sat|Sun/) {
       $TEST = $_;
       next;
    }
    # This is global variable , Global because we use it in format statement
    # Convert Input line into array and print last element which is sequence number
    # $var[$#$var] is like $NF in awk
    @SEQ = split / /;
    write if /Complete.*OPEN/;
    write if /Complete.*open/;
}
close(FH);

