#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

my $split_path = $ARGV[0];
open my $split_fh, "<", $split_path;
my @splits = <$split_fh>;
chomp $_ for (@splits);
close $split_fh;

my $out_prefix = $ARGV[1];

binmode STDIN, ":utf8";

my $line_num = 0;
my $segm_border = 0;
my $segm_num = 0;
my $segm_fh;
while (my $line = <STDIN>) {
    if (defined $segm_border && $line_num == $segm_border) {
        if (defined $segm_fh) {
            close $segm_fh;
        }
        open $segm_fh, ">:utf8", sprintf("$out_prefix.segm_%02d.txt", $segm_num);
        $segm_border = shift @splits;
        $segm_num++;
    }
    print {$segm_fh} $line;
    $line_num++;
}
close $segm_fh;
