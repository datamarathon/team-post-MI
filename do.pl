#!/usr/bin/perl -w
# Stupid script to save typing when running SQL file.
# usage: ./do.pl age_new.sql

use strict;
my $filename = shift;
system("psql -f $filename MIMIC2");
