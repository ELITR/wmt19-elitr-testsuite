#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Encode qw(decode_utf8);

sub escape_for_tex {
    my ($str) = @_;
    $str =~ s/\\/\\textbackslash/g;
    $str =~ s/&/\\&/g;
    $str =~ s/%/\\%/g;
    $str =~ s/\$/\\\$/g;
    $str =~ s/#/\\#/g;
    $str =~ s/_/\\_/g;
    $str =~ s/\{/\\{/g;
    $str =~ s/\}/\\}/g;
    $str =~ s/~/\\textasciitilde/g;
    $str =~ s/\^/\\textasciicircum/g;
    return $str;
}

sub decorate_with_sections {
    my ($line) = @_;
    return $line if ($line =~ /[.?!]$/);
    chomp $line;
    return "\n\n$line\n\n";
}

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my @param_names = qw/__TITLE__ __BODY-SRC__ __BODY-TRG__/;
my @param_values = ();

for (my $i = 0; $i < @param_names; $i++) {
    if ($param_names[$i] =~ /BODY/) {
        open my $f, "<:utf8", $ARGV[$i];
        my @lines = <$f>;
        close $f;
        @lines = map {escape_for_tex($_)} @lines;
        @lines = map {decorate_with_sections($_)} @lines;
        my $src_text = join "", @lines;
        push @param_values, $src_text;
    }
    else {
        push @param_values, decode_utf8($ARGV[$i], 1);
    }
}

while (my $l = <STDIN>) {
    for (my $i = 0; $i < @param_names; $i++) {
        my $name = $param_names[$i];
        my $value = $param_values[$i];
        $l =~ s/$name/$value/g;
    }
    print $l;
}
