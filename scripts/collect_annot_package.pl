#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use List::Util qw/shuffle any sum/;
use List::MoreUtils qw/uniq/;
use File::Copy;
use Data::Printer;
use Text::Levenshtein qw/distance/;
use Graph::Undirected;

srand 1986;

my $lang_pair = shift @ARGV;
my ($src_lang, $trg_lang) = split /-/, $lang_pair;

my $annot_str = shift @ARGV;
my @annot_items = split /-/, $annot_str;
my @segm_per_annot_count = ();
my $overlap_count;
foreach my $annot_item (@annot_items) {
    if ($annot_item =~ /x/) {
        my ($annotators, $hours) = split /x/, $annot_item;
        push @segm_per_annot_count, $hours*4 foreach (1..$annotators);
    }
    else {
        $overlap_count = $annot_item;
    }
}
my $annot_count = scalar @segm_per_annot_count;

my $ids_path = shift @ARGV;
my @systems = @ARGV;

my $in_dir="tmp/splits/".$lang_pair;
my $out_dir="tmp/package/".$lang_pair.".".$annot_str;

open my $ids_fh, "<:utf8", $ids_path;
my @ids = <$ids_fh>;
chomp $_ foreach (@ids);
@ids = shuffle @ids;
close $ids_fh;

my @assigned_ids = ();

sub get_id {
    my $id = shift @ids;
    if (!defined $id) {
        print STDERR "No more ids. Assigned ids count: ".scalar(@assigned_ids)."\n";
        exit();
    }
    while (@assigned_ids and any {$_ < 2} distance($id, @assigned_ids)) {
        $id = shift @ids;
    }
    return $id;
}

my %segms_per_doc = ();
opendir(my $in_dh, $in_dir) || die "Can't opendir $in_dir: $!";
foreach my $doc (grep {$_ !~ /^\.\.?$/} readdir($in_dh)) {
    opendir(my $doc_in_dh, $in_dir."/".$doc);
    my @src_docs = grep {$_ =~ /^src_/} readdir($doc_in_dh);
    closedir $doc_in_dh;
    # $segms_per_doc{$doc} = [ shuffle 0..$#src_docs ];
    $segms_per_doc{$doc} = @src_docs;
}
closedir $in_dh;

my @segments = shuffle map { my $d = $_; map {[$d, $_];} (0..$segms_per_doc{$d}-1)} sort keys %segms_per_doc;

my %overlap_segms = ();
if ($overlap_count && $annot_count > 1) {
    my $g = Graph::Undirected->new();
    for (my $i = 0; $i < $overlap_count; $i++) {
        my ($v1, $v2, @annots12);
        do {
            my @annots = map {int(rand($annot_count)) + 1} (0, 1);
            my @segm4as = map {int(rand($segm_per_annot_count[$_-1])) + 1} @annots;
            ($v1, $v2) = map {sprintf "%02d:%02d", $annots[$_], $segm4as[$_]} (0, 1);
            my $v1_comp_idx = $g->connected_component_by_vertex($v1);
            my @v1_comp = defined $v1_comp_idx ? $g->connected_component_by_index($v1_comp_idx) : ();
            my $v2_comp_idx = $g->connected_component_by_vertex($v2);
            my @v2_comp = defined $v2_comp_idx ? $g->connected_component_by_index($v2_comp_idx) : ();
            @annots12 = map {my ($a, $s) = split /:/, $_; int($a)} (@v1_comp, @v2_comp);

        } while ($v1 eq $v2 or scalar(@annots12) > scalar(uniq @annots12));
        $g->add_edge($v1, $v2);
    }
    foreach my $v ($g->vertices) {
        my ($first) = sort {$a cmp $b} ($g->all_reachable($v), $v);
        $overlap_segms{$v} = $first if ($v ne $first);
    }
}
p(%overlap_segms);

my @used_ids = ();

mkdir $out_dir;

open my $log_fh, ">", "$out_dir/segment_align.txt";

my $segm_i = 0;
foreach my $annot_i (1..$annot_count) {
    mkdir sprintf "%s/annotator_%02d", $out_dir, $annot_i;
    foreach my $segm_annot_i (1..$segm_per_annot_count[$annot_i-1]) {
        my $segm_concat = $overlap_segms{sprintf "%02d:%02d", $annot_i, $segm_annot_i};
        my $segm_y;
        if (defined $segm_concat) {
            my ($annot_j, $segm_annot_j) = split /:/, $segm_concat;
            $segm_y = (sum ($annot_j > 1) ? @segm_per_annot_count[0..$annot_j-2] : 0) + ($segm_annot_j - 1);
            push @assigned_ids, $assigned_ids[$segm_y];
        }
        else {
            $segm_y = $segm_i;
            push @assigned_ids, get_id();
        }

        my $sys = $systems[$segm_y % scalar(@systems)];
        my ($doc, $segm) = @{$segments[$segm_y]};
        my $id = $assigned_ids[$segm_y];

        my $from_src_file = sprintf "%s/%s/src_%s.segm_%02d.txt", $in_dir, $doc, $src_lang, $segm;
        my $to_src_file = sprintf "%s/annotator_%02d/src.%02d-%s.txt", $out_dir, $annot_i, $segm_annot_i, $id;
        my $from_sys_file = sprintf "%s/%s/%s.segm_%02d.txt", $in_dir, $doc, $sys, $segm;
        my $to_sys_file = sprintf "%s/annotator_%02d/trg.%02d-%s.txt", $out_dir, $annot_i, $segm_annot_i, $id;
        print {$log_fh} "$from_sys_file\t$to_sys_file\n";
        copy $from_src_file, $to_src_file;
        copy $from_sys_file, $to_sys_file;
        
        $segm_i++;
    }
}
