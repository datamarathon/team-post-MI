#!/usr/bin/perl -w
# Stupid script to save typing when running SQL file.
# usage: ./do.pl age_new.sql

use strict;

my $query =" ";
while(<>){
    chomp;
    s/;//g;
    $query = $query . $_ . " ";
}

print "COPY ($query) TO 'out.csv' WITH (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);";

