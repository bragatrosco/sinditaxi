#!/usr/bin/perl
#
# check hardware status - if anything is wrong then report it
use warnings;
use strict;

my $ERROR=1;
my $OK=0;

my $status=$OK;
my %ignore;

# check chassis status
#
# SEVERITY : COMPONENT
# Ok       : Fans
# Ok       : Intrusion
# Ok       : Memory
# Critical : Power Supplies
# Ok       : Processors
# Ok       : Temperatures
# Ok       : Voltages
# Ok       : Hardware Log
#
open( STATUS, "/opt/dell/srvadmin/bin/omreport chassis|grep :|grep -v COMPONENT|") || die;
%ignore = ( 'Power Supplies' => 1 );

while(<STATUS>) {
  chomp $_;
  my ($comp_status, $component) = split /\s*:\s*/;
  if ($comp_status ne "Ok") {
    if ( defined($ignore{$component}) ) {
      # do nothing
    }
    else {
      $status += $ERROR;
      print "$comp_status : $component\n";
    }
  }
}

close STATUS;


# check RAID status
#
# Controller PERC 4e/Si (Embedded)
# ID                        : 0:0
# Status                    : Ok
# Name                      : Array Disk 0:0
# State                     : Online
# Progress                  : Not Applicable
# Capacity                  : 68.24 GB (73274490880 bytes)
# Used RAID Disk Space      : 68.24 GB (73274490880 bytes)
# Available RAID Disk Space : 0.00 GB (0 bytes)
# Hot Spare                 : No
# Product ID                : ATLAS10K5_73SCA
# Revision                  : JNZM
# Vendor ID                 : MAXTOR
#
# ID                        : 0:1
# Status                    : Ok
# Name                      : Array Disk 0:1
# State                     : Online
# Progress                  : Not Applicable
# Capacity                  : 68.24 GB (73274490880 bytes)
# Used RAID Disk Space      : 68.24 GB (73274490880 bytes)
# Available RAID Disk Space : 0.00 GB (0 bytes)
# Hot Spare                 : No
# Product ID                : ATLAS10K5_73SCA
# Revision                  : JNZM
# Vendor ID                 : MAXTOR
#
#
open( STATUS, "/opt/dell/srvadmin/bin/omreport storage adisk controller=0|grep :|grep Status|") || die;

while(<STATUS>) {
  if ( ! /Ok/ ) {
    $status += $ERROR;
    print "$_\n";
  }
}

close STATUS;

exit $status;
