#!/usr/local/perl-5.6.1/bin/perl 

use strict;
use okcdefines;
use commPasswords;
use Getopt::Long;


#########################################################################################################

# Main processing Block
my $test='valence sendvalence download25';
my @script=`$test | awk '{print $3}'`;
print @script;