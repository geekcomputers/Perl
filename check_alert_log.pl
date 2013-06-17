#!/usr/local/bin/perl -w

# Script Name		: check_alert_log.pl
# Author				: Craig Richards
# Created				: 12th December 2007
# Last Modified		: 2nd July 2008
# Version				: 1.2

# Modifications		: 1.1 - 12th December 2007 - CR Added the generic ORA- for error monitoring, also changed the threshold to 1
#							: 1.2 - 2nd July 2008 - CR Added ORACLE_SID to the Mail Output

# Description			: Check the Alert Log, used with the shell script check_alert_log.sh

$interval=60;              # How many seconds before we check to see if data has been written to the logfile;
$email_threshold=1;        # How many errors within the interval before an email gets sent;
$hostname=`uname -n`;      # Get the hostname from the OS
$file="$ENV{'ALERT'}";     # Get the path of the alert_log from the OS Environment
$sid="$ENV{'ORACLE_SID'}"; # Get the ORACLE_SID from the OS Environment

open(filePtr, $file) or die "Can't find $file\n";

for (;;) {  
@errors=("Subject: Alert Log Errors for $hostname\n");  
$currTime = localtime(time);  
push(@errors,"Here are some errors found at $currTime for $hostname.\n");  
while (<filePtr>) {   
  chop $_;   
  if (/ORA-00600/ || /ORA-01555/ || /ORA-/) {       
  push(@errors, "$_\n");    
  }  
}  

if ($#errors > $email_threshold)  {   
$rndExt = time;   
$rndFile = "alert_errors_$rndExt";   
open (TMPFILE, ">/tmp/$rndFile");   

foreach $error (@errors) {        
print TMPFILE $error;   
}   
close(TMPFILE);   
system ("mailx -s \"Alert log Errors for $hostname \: Database $sid\" username\@host.com < /tmp/$rndFile");   
system ("rm /tmp/$rndFile");  
}  
sleep $interval;  
seek filePtr, 0, 1;
}

## End of Script

