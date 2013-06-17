#!/usr/bin/perl -w

# Script Name		: check_message_nfs.pl
# Author				: Craig Richards
# Created				: 
# Last Modified		: 
# Version				: 1.0

# Modifications		: 

# Description			: Use this to check an NFS mount

#use strict;

$interval=60;             # How many seconds before we check to see if data has been written to the logfile;
$email_threshold=1;       # How many errors within the interval before an email gets sent;
$hostname=`uname -n`;     # Get the hostname from the OS
$file="/var/adm/messages"; # Get the path of the alert_log from the OS Environment

open(filePtr, $file) or die "Can't find $file\n";

for (;;) {  
@errors=("Subject: NFS Problems \n");  
$currTime = localtime(time);  
push(@errors,"Here are some errors found at $currTime for $hostname.\n");  
while (<filePtr>) {   
  chop $_;   
  if (/NFS/) {       
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
system ("mailx -s \"NFS Errors \" name\@hostname.com < /tmp/$rndFile");   
system ("rm /tmp/$rndFile");  
}  
sleep $interval;  
seek filePtr, 0, 1;
}

## End of Script

