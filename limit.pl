#!/usr/bin/perl -w
# Stupid script to save typing when running SQL file.
# usage: ./do.pl age_new.sql

use strict;
my $filename = shift;
system("cp $filename deleteme.sql") == 0 or die "Failed to copy $filename: $!\n:";
system("echo limit 100 >> deleteme.sql") == 0 or die "Failed to append: $!\n:";
system("psql -f deleteme.sql MIMIC2") == 0 or die "Failed to run psql: $!\n:";
system("rm deleteme.sql") == 0 or die "Failed to remove: $!\n:";
