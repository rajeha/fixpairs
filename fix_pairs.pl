#!/usr/bin/env perl
use strict;
use warnings;

my $usage = 'fix_pairs.pl <r1.fq> <r2.fq> <output prefix>';

my $fnm1 = shift @ARGV or die $usage;
my $fnm2 = shift @ARGV or die $usage;
my $opref = shift @ARGV or die $usage;

sub getread {
	my $fh = shift;
	my @allread;

	if ($fh) {
		while (<$fh>) {
			push @allread, $_; 
			if (@allread == 4) {
				return \@allread;
			}
			return undef if eof;
		}
	}
}

open my $in1, '<', $fnm1 or die $!;
open my $in2, '<', $fnm2 or die $!;

open my $out1, '>', "${opref}1.fq";
open my $out2, '>', "${opref}2.fq";
open my $outun, '>', "${opref}_unpaired.fq";

my ($nm1, $nm2, %rd1, %rd2, @unpaired);

while (1) {
	my $r1 = getread($in1);
	my $r2 = getread($in2);
	last unless $r1 || $r2;

	if ($r1) {
		$nm1 = (split /\//, $r1->[0])[0]; # name of the read	
		$rd1{$nm1} = $r1;
	}

	if ($r2) {
		$nm2 = (split /\//, $r2->[0])[0];
		$rd2{$nm2} = $r2;
	}

	if ($r1 && $nm1 ~~ [ keys %rd2 ]) {
		print $out1 @{$rd1{$nm1}};
		print $out2 @{$rd2{$nm1}};
		delete $rd1{$nm1};
		delete $rd2{$nm1};
	}

	if ($r2 && $nm2 ~~ [ keys %rd1 ]) {
		print $out1 @{$rd1{$nm2}};
		print $out2 @{$rd2{$nm2}};
		delete $rd1{$nm2};
		delete $rd2{$nm2};
	}
}

print $outun @{$rd1{$_}} for keys %rd1;
print $outun @{$rd2{$_}} for keys %rd2;

