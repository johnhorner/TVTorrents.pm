#!/usr/local/bin/perl
use strict;
use warnings;
use 5.010;
use Test::Simple tests => 2;
use Data::Dumper::Simple;
$Data::Dumper::Indent = 1;
use TVTorrents;
my $tvt = TVTorrents->new('test');
print Dumper($tvt);
ok( defined($tvt) && ref $tvt eq 'TVTorrents', 'new() with good config' );
my $bad_tvt = TVTorrents->new('foo');
print Dumper($bad_tvt);
ok( !defined($bad_tvt), 'new() fails on bad config' );
