#!/usr/bin/perl -w
# usage: ./stupid_dates.pl ~/Dropbox/out.csv > ~/Dropbox/fixeddates.csv
use strict;

while(<>){
    chomp;
    my @fields = split(/;/);
    # fields 4 5 7 and 8 are dates
    print if /SUBJECT/;
    next if /SUBJECT/;
    for (4, 5, 7, 8){
	$fields[$_] =~ s/(.*\d\d\d\d).*/$1/;
	my $mo = substr($fields[$_], 0, 3);
	$mo =~ s/(.)/\U$1/g; #upcase
	my $dt = $fields[$_];
	$dt =~ s/^... (\d+),.*/$1/;
	my $yr = $fields[$_];
	$yr =~ s/.*, (\d\d\d\d).*/$1/;
	$fields[$_] = $dt . $mo . $yr;
    }
    print join(";", @fields) . "\n";
}
