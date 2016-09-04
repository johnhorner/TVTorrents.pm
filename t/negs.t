#!/usr/local/bin/perl
use strict;
use warnings;
use 5.010;
use Test::Simple tests => 2;
use Data::Dumper::Simple;
$Data::Dumper::Indent = 1;
use TVTorrents;
my $tvt = TVTorrents->new('test');
$tvt->negations('vostfr');
my @negs = $tvt->{'negations'};
ok( scalar(@negs) == 1, 'negation saved' );

