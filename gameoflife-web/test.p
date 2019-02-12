#!/usr/local/perl-5.6.1/bin/perl

use strict;
use okcdefines;
use commPasswords;
use Sys::Hostname;
use Getopt::Long;

#########################################################################################################
# Main processing Block

# check for input file and if not present, exit
if (!(-e "input")){
	print "Please place input file in the directory and run again\n";
	exit 0;
}
# check and remove RunScript.sh file
if (-e "RunScript.sh"){
	unlink "RunScript.sh";
}
# check and remove Results file
if (-e "Results"){
	unlink "Results";
}
my $hostname = hostname();
open(FILE,"input") or die("unable to open file");
# create input_back file to write the modified line and rename it to input at last
open(FILE_NEW, ">>input_back") or die $!;
open(RH,">>Results") or die $!;
my @lines=<FILE>;

foreach $line (@lines){
	my ($payer,$payerType,$key,$value)=split(' ',$line);
	# remove leading and trailing spaces
	$payer = trim($payer);
	$payerType = trim($payerType);
	$key = trim($key);
	$value = trim($value);
	
	if ($key =~ /download/){
		my $rd = (split("]",((split("rd:",$value))[1])))[0];
		my $rf = (split("]",((split("rf:",$value))[1])))[0];
		my $ld = (split("]",((split("ld:",$value))[1])))[0];		
		
		# get latest series from passfor script and update
		my $temp = `passfor "$payerType" > temp`;
		my $downloadNumber = returnNextNumber("temp","download");
		$line =~ s/$key/download$downloadNumber/;
		$key = download$downloadNumber;
		# write it to input_back file
		print $FILE_NEW "$line\n";
		
		# adding password tool entry
		print "\nPassword Tool entries for download:";
		print "\n===================================================";
		print "\n$line";
		print "\n===================================================";
		addToDB($payer,$payerType,$key,$value);
		commit();
		print "\nPassword Tool entry is completed for \n$line";
		
		my $remoteDir="/u/spool/ftponly/clients/testmeto$rd"
		# Directory Creation
		if (! -e "$remoteDir")
		{
			print "\nMessage: $remoteDir is created!"
			mkdir $remoteDir;
		}
		
		my $directory = `pwd`;
		$directory =~ s/\n//g;
		$directory =~ s/\r//g;
		
		# write log to Results file
		print $RH "\nTest files in $remoteDir dir:";
		print $RH "\n---------------------------------------------";
		print $RH "\n[$hostname:$directory]\$ ls -lrt $remoteDir\n";
		my $val = `ls -lrt $remoteDir`;
		print $RH "\n---------------------------------------------";
		print $RH $val;
		
	}elsif ($key =~ /upload/){
		my $rd = (split("]",((split("rd:",$value))[1])))[0];
		my $rf = ((split("rf:",$value))[1]);
		chop($rf); # remove last charcter "]" in the string since there might be multiple occurance of it 
		my $ld = (split("]",((split("ld:",$value))[1])))[0];
		my $lf = (split("]",((split("lf:",$value))[1])))[0];
		
		# get latest series from passfor script and update
		my $temp = `passfor "$payerType" > temp`;
		my $uploadNumber = returnNextNumber("temp","upload");
		$line =~ s/$key/upload$upload/;
		$key = upload$uploadNumber;
		# write it to input_back file
		print $FILE_NEW "$line\n";
		
		# adding password tool entry
		print "\nPassword Tool entries for upload:";
		print "\n===================================================";
		print "\n$line";
		print "\n===================================================";
		addToDB($payer,$payerType,$key,$value);
		commit();
		print "\nPassword Tool entry is completed for \n$line";
		
		my $RemoteDir="/u/spool/ftponly/clients/testmeto$rd";		
		if (! -e "$RemoteDir"){
			print "\nMessage: $RemoteDir is created!";
			mkdir $RemoteDir;
		}
		
		my $directory = `pwd`;
		$directory =~ s/\n//g;
		$directory =~ s/\r//g;
		
		# write log to Results file
		print $RH "\nClaims in source Directory:";
		print $RH "\n---------------------------------------------";
		print $RH "\n[$hostname:$directory]\$ ls -lrt $ld\n";
		my $val = `ls -lrt $ld`;
		print $RH "\n---------------------------------------------";
		print $RH $val;
	}	
}

# -------------------------------------------------------------------------
# script execution


sub trim{
	my $s = shift; 
	$s =~ s/^\s+|\s+$//g;
	return $s;
}

sub returnNextNumber{
	my $file=$_[0];
	my $type=$_[1];
	
	# declare array
	my @numbers;
	my $line;
	my $num;
	open(FILE,$file) or die("unable to open file");
	my @lines=<FILE>;
	
	foreach $line (@lines){
		my $val = (split(" ",$line))[2];
		if ($val =~ /$type/){
			push(@numbers, (split($type,$val))[1]);
		}		
	}
	
	my @sorted = sort{ $a <=> $b } @numbers;
	return pop(@sorted) + 1;
}