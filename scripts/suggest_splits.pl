#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

my $TOKENS = $ARGV[0];

my $line_num = 0;
my $all_toks_num = 0;
my $is_split = 0;
while (<STDIN>) {
    chomp $_;
    my $toks_num = scalar split / /, $_;
    if ($all_toks_num + $toks_num > $TOKENS) {
        if (($TOKENS - $all_toks_num) < ($all_toks_num + $toks_num - $TOKENS)) {
            print $line_num."\n";
            $all_toks_num = $toks_num;
        }
        else {
            print ($line_num+1);
            print "\n";
            $all_toks_num = 0;
        }
    }
    else {
        $all_toks_num += $toks_num;
    }
    $line_num++;
}
