#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Data::Printer;

use Statistics::Basic qw/mean stddev/;
use List::Util qw/min/;

my $SYSTEM_IDX = 0;
my $NAME_IDX = 2;
my $SCORE_IDX = 3;

sub aggregate_over_item {
    my ($stat_list, $item_idx) = @_;
    my %scores_for_system = ();
    foreach my $inst (@$stat_list) {
        my $scores = $scores_for_system{$inst->[$item_idx]};
        if (!defined $scores) {
            $scores = [ map {[]} (1..5) ];
        }
        for (my $i = 0; $i < 5; $i++) {
            push @{$scores->[$i]}, $inst->[$i + $SCORE_IDX]
        }
        $scores_for_system{$inst->[$item_idx]} = $scores;
    }
    return %scores_for_system;
}

sub transform_to_orders {
    my ($stat_list) = @_;
    my %systems = ();
    my %scores_for_annot = ();
    foreach my $inst (@$stat_list) {
        $systems{$inst->[$SYSTEM_IDX]}++;
        my $scores = $scores_for_annot{$inst->[$NAME_IDX]};
        if (!defined $scores) {
            $scores = [ map {{}} (1..5) ];
        }
        for (my $i = 0; $i < 5; $i++) {
            my $mini_scores = $scores->[$i]->{$inst->[$SYSTEM_IDX]};
            if (!defined $mini_scores) {
                $mini_scores = [];
            }
            push @$mini_scores, $inst->[$i + $SCORE_IDX];
            $scores->[$i]->{$inst->[$SYSTEM_IDX]} = $mini_scores;
        }
        $scores_for_annot{$inst->[$NAME_IDX]} = $scores;
    }
    my %all_ords_for_system = map {$_ => [ map {[]} (1..5) ]} keys %systems;
    for (my $i = 0; $i < 5; $i++) {
        foreach my $user (sort keys %scores_for_annot) {
            my %mean_for_system = map {$_ => mean(@{$scores_for_annot{$user}->[$i]->{$_}})} keys %{$scores_for_annot{$user}->[$i]};
            my %systems_for_mean;
            push @{$systems_for_mean{ $mean_for_system{$_} }}, $_ for keys %mean_for_system;
            my @sorted_systems = sort {$mean_for_system{$b} <=> $mean_for_system{$a}} keys %mean_for_system;
            my %auxord_for_system = map {$sorted_systems[$_] => $_+1} (0..$#sorted_systems);
            my %mean_to_ord = map {my $mean = $_; $mean => min(map {$auxord_for_system{$_}} @{$systems_for_mean{$mean}}) } keys %systems_for_mean;
            my %ord_for_system = map {$_ => $mean_to_ord{$mean_for_system{$_}}} keys %mean_for_system;

            push @{$all_ords_for_system{$_}[$i]}, $ord_for_system{$_} for keys %ord_for_system;
        }
    }
    return %all_ords_for_system;
}

sub print_means_stds {
    my ($scores) = @_;
    foreach my $sys (sort keys %$scores) {
        my @stats = map {[mean(@$_), stddev(@$_)]} @{$scores->{$sys}};
        printf "%s\n", join "\t", ($sys, map {sprintf "%.2f / %.2f", $_->[0], $_->[1]} @stats);
    }
}

my @stat_list = ();

while (my $line = <STDIN>) {
    chomp $line;
    my @cols = split /\t/, $line;
    push @stat_list, \@cols;
}

my %scores_for_system = aggregate_over_item(\@stat_list, $SYSTEM_IDX);
print_means_stds(\%scores_for_system);

print "\n\n";

my %orders_for_system = transform_to_orders(\@stat_list);
print_means_stds(\%orders_for_system);
