#!/usr/local/bin/perl -w

# Script Name		: check_environment.pl
# Author				: Craig Richards
# Created				: 16th-July-2009
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Print our some oracle information

print <<EOT;

This next Section displays some of the Oracle Settings currently set in your environment, it then
gathers some system information.

EOT

if ( ! $ENV{"ORACLE_HOME"} ) {
  print "Oracle Home has not been set !! \n";
  exit(1);
} else {
  print "Oracle Home is set to \t : $ENV{ORACLE_HOME} \n";
}
if ( ! $ENV{"ORACLE_SID"} ) {
  print "Oracle SID has not been set !! \n";
  exit(1);
} else {
  print "Oracle SID is set to \t : $ENV{ORACLE_SID} \n";
}
if ( ! $ENV{"ORACLE_BASE"} ) {
  print "Oracle BASE has not been set !! \n";
  exit(1);
} else {
  print "Oracle Base is set to \t : $ENV{ORACLE_BASE} \n";
}

$tns = $ENV{ORACLE_HOME};
$alertlog = $ENV{ORACLE_BASE};
$sid = $ENV{ORACLE_SID};
$tnsfile = "${tns}/network/admin/tnsnames.ora";
$listenerfile = "${tns}/network/admin/listener.ora";
$oratab = '/etc/oratab';
$alert_log = "${alertlog}/admin/${sid}/bdump/alert_${sid}.log";
print LOGFILE "open(INFO, $tnsfile)";
@lines = <INFO>;
close(INFO);
print @lines;
open(INFO, $listenerfile);
@lines = <INFO>;
close(INFO);
print @lines;
open(INFO, $oratab);
@lines = <INFO>;
close(INFO);
print @lines;

system ("uname -a");
system ("df -k");


warn "alert log is old!\n"
  if -M $alert_log > 10;

warn "alert was last modified\n";
  -C $alert_log;

use English;         # Let us say "$CHILD_ERROR" instead of "$?", etc.
use strict;          # Enforce strict variables, refs, subs, etc.

use File::Basename();
use lib &File::Basename::dirname($PROGRAM_NAME) . "/perl_modules";

# Command.pm initializes the command set and associated attributes.
use Command();

#my $copyright = "\nOracle Interim Patch Installer version " . 
#                &Command::version . "\n" .
#                &Command::copyright . "\n";
#opatchIO -> print_message_noverbose ( { message => $copyright } );
my $current_perl = $EXECUTABLE_NAME;
my $current_name = $PROGRAM_NAME;

#$user = system("whoami");
#if ( $user != "oracle" ) {
#  print "Run as another user except ROOT prefereably Oracle \n";
#  exit(1)
#} else {
#$logfile = '/tmp/system_settings.txt'
#open(LOGFILE, $logfile);
#close(LOGFILE);
#}

## End of Script
