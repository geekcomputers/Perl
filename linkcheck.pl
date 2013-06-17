#!/usr/local/bin/perl -w
#
# SccsId[] = "%W% %G% (Link check Perl program)"
#
#----------------------------------------------------------------------#
#                            linkcheck.pl                              #
# -------------------------------------------------------------------- #
#        Program documentation and notes located at the bottom.        #
#----------------------------------------------------------------------#

   BEGIN { $diagnostics::PRETTY = 1 }

   $SIG{'INT'} = sub {print "\nExiting on $SIG{'INT'}\n";exit $SIG{'INT'}};

   use File::Find;
   use Getopt::Std;
   use Cwd;
   use POSIX qw(uname);
   my $host =  (uname)[1];

   use vars qw($opt_a $opt_H $opt_h $opt_l $opt_r $opt_v);
   my $options='aHhlrv';
   exit_usage("Invalid option!\n") unless (getopts($options));
   show_documentation()                 if ($opt_H); # Full documentation
   exit_usage()                         if ($opt_h); # or usage brief.
   exit_usage("Filesystem required.\n") if ($#ARGV < 0);

   if ($opt_v)
   {
      use diagnostics;
   }

 #---------------------------------------------------------#
 # Eliminate all but local filesystem searches right away. #
 #---------------------------------------------------------#
   my $local_fs;
   my @search;
   foreach (@ARGV)
   {
      if ($local_fs = `df -lk $_`)
      {
         push(@search, $_);
      }
      else
      {
         print "File system $_ must be local to $host, not NFS mounted.",
               "\nSkipping $_.\n";
         $_ = "";
      }
   }

 #-------------------------------------------------------------#
 # Ignore find command's stderr output (eliminates "Permission #
 # denied" and most--not ALL--other bothersome messages).      #
 #-------------------------------------------------------------#
   open(OLDERR, ">&STDERR");
   open(STDERR, ">/dev/null") or die "Can't redirect stderr: $!";

   my $q = 0; # Found counter
   my $r = 0; # Removed counter
   find sub # [Anonymous] subroutine reference (called a coderef).
   {
      return unless -l "$_"; # Skip all but links.
    #----------------------------------------------------------#
    # Skip nfs mounted links, and /proc and /cdrom pathnames.  #
    #----------------------------------------------------------#
      return if (
                   (lstat("$_"))[0] < 0
                ||
                   $File::Find::name =~ /\/proc/s
                ||
                   $File::Find::name =~ /\/cdrom/s
                );

    #----------------------------------------------------------#
    # Skip link if it's not on a local filesystem as well.     #
    #----------------------------------------------------------#
      my $dir = cwd;
      return unless ($local_fs = `df -lk $dir`);

      $! = 0; # Clear error message variable
      return unless defined(my $target = readlink("$_"));

      my $error  = "$!";
         $error  = "($error)" if (defined($error) && $error ne "");

      my $ls_out = ($opt_l)
        ? `ls -albd $File::Find::name 2> /dev/null`
        : "$File::Find::name -> $target";

      chomp($ls_out);

      unless (-e "$target") # Unless the link is OK, do the following.
      {
         $q++;
         print "Broken link: $ls_out $error\n";
         if ($opt_r)
         {
            print  "rm '$File::Find::name'\n";
            if (unlink("$File::Find::name") == 0) # Zero = none deleted.
            {
               print "Unable to remove $File::Find::name!\n";
               return;
            }
            $r++;
            print "Removed '$File::Find::name'\n" if ($opt_v);
         }
         return;
      }

    #----------------------------------------------------------#
    # Return unless user requests list of all links (-a).      #
    #----------------------------------------------------------#
      return unless ($opt_a);

      if    (-f "$target") { print "Linked file: $ls_out $error\n"; }
      elsif (-d "$target") { print "Linked dir:  $ls_out $error\n"; }
      elsif (-l "$target") { print "Linked link: $ls_out $error\n"; }
      elsif (-p "$target") { print "Linked pipe: $ls_out $error\n"; }
      elsif (-S "$target") { print "Linked sock: $ls_out $error\n"; }
      elsif (-b "$target") { print "Linked dev:  $ls_out $error\n"; }
      elsif (-c "$target") { print "Linked char: $ls_out $error\n"; }
      elsif (-t "$target") { print "Linked tty:  $ls_out $error\n"; }
      else                 { print "Linked ???:  $ls_out $error\n"; }

      $error = "";
      return;
   }, @search; # find sub

 #-------------------------------------------------------------#
 # Restore stderr.                                             #
 #-------------------------------------------------------------#
   close(STDERR) or die "Can't close STDERR: $!";
   open( STDERR, ">&OLDERR") or die "Can't restore stderr: $!";
   close(OLDERR) or die "Can't close OLDERR: $!";

   print "$host: Found $q broken links.  Removed $r.\n";
   exit 1;


#======================================================================#
#             S U B R O U T I N E S  /  F U N C T I O N S              #
#                       (in alphabetical order)                        #
#----------------------------------------------------------------------#
sub exit_usage # Exits with non-zero status.                           #
               # Global vars:   $main::notify                          #
               #                $main::support                         #
#----------------------------------------------------------------------#
{
   my $fn_name = "exit_usage";
   my $txt     ;

 #---------------------------------------------------------------#
 # Assign to private variable, $notify either $main::support or  #
 # $main::notify (takes $main::support over $main::notify).      #
 #---------------------------------------------------------------#
   my $notify;
   if (defined($ENV{LOGNAME} )) { $notify = $ENV{LOGNAME}; }
   else                         { $notify = $ENV{USER};    }

   $txt =  "Usage:   $0 -$options fs ...\n";
   $txt =  "$_[0]\n$txt" if ($#_ >= 0); # Prefix message arguments
   $txt .= "\n         -a = Display All links."
        .  "\n         -H = Displays full documentation."
        .  "\n         -h = Gives usage brief."
        .  "\n         -l = Long list (e.g. 'ls -al')."
        .  "\n         -r = Remove broken links (use with caution)."
        .  "\n         -v = Verbose output."
        .  "\n         fs = Required filesystem for search."
        .  "\n              (multiple filesystems may be specified)\n"
        .  "\nPurpose: Search filesystem (descending directories) for"
        .  "\n         broken links, optionally displaying all links"
        .  "\n         (-a) and/or removing (-r) them.\n";

 #---------------------------------------------------------------#
 # If running interactively, then give'm usage, else notify      #
 # program support person(s) because a cron'd job called usage.  #
 #---------------------------------------------------------------#
   print "$txt";

   exit 1;
} # sub exit_usage

#----------------------------------------------------------------------#
sub show_documentation # Display program documentation at bottom.      #
#----------------------------------------------------------------------#
{
   my $n = 0;
   foreach (my @doc_lines = <main::DATA>)
   {
      print "$_";
   }
   exit $n;
} # sub show_documentation


__END__ # Documentation section follows:
#======================================================================#
#                      D O C U M E N T A T I O N                       #
#======================================================================#
#                                                                      #
#      Author: Bob Orlando                                             #
#                                                                      #
#        Date: April 29, 2002                                          #
#                                                                      #
#  Program ID: linkcheck.pl                                            #
#                                                                      #
#     Purpose: Search local filesystem or systems                      #
#              (descending directories) for broken                     #
#              links, optionally displaying all links                  #
#              (-a) and/or removing (-r) them.                         #
#                                                                      #
#       Usage: linkcheck.pl -aHhlrv fs ...                             #
#                           -a = Display All links.                    #
#                           -H = Detailed documentation.               #
#                           -h = Usage brief.                          #
#                           -l = Long list (e.g. 'ls -al').            #
#                           -r = Remove broken links                   #
#                                (use with caution).                   #
#                           -v = Verbose output.                       #
#                           fs = Required filesystem for search        #
#                                (multiple filesystems may be          #
#                                specified)                            #
#                                                                      #
#    Examples: linkcheck.pl /        # Lists broken links (short list) #
#              linkcheck.pl -l /     # Lists broken links (long list)  #
#              linkcheck.pl -a /home # Lists all links in /home.       #
#              linkcheck.pl -r /usr  # Removes broken links from /usr. #
#                                                                      #
#     Returns: Zero on success.                                        #
#              Nonzero in failure.                                     #
#                                                                      #
#----------------------------------------------------------------------#

