use strict;
#use okcdefines;
#use commPasswords;
#use Getopt::Long;


#########################################################################################################

# Main processing Block
open(FILE,"input") or die("unable to open file");
my @lines=<FILE>;

foreach (@lines){
	my ($payer,$payerType,$key,$value)=split(' ',$_);
	# remove leading and trailing spaces
	$payer = trim($payer);
	$payerType = trim($payerType);
	$key = trim($key);
	$value = trim($value);
	
	if ($key =~ /download/){
		my $rd = (split("]",((split("rd:",$value))[1])))[0];
		my $rf = (split("]",((split("rf:",$value))[1])))[0];
		my $ld = (split("]",((split("ld:",$value))[1])))[0];
		print "$rf\n";
	}elsif ($key =~ /upload/){
		my $rd = (split("]",((split("rd:",$value))[1])))[0];
		my $rf = ((split("rf:",$value))[1]);
		chop($rf); # remove last charcter "]" in the string since there might be multiple occurance of it 
		my $ld = (split("]",((split("ld:",$value))[1])))[0];
		my $lf = (split("]",((split("lf:",$value))[1])))[0];
		print "$rf\n";
	}	
}

sub trim{
	my $s = shift; 
	$s =~ s/^\s+|\s+$//g;
	return $s;
};