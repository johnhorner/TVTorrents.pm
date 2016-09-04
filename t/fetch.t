#!/usr/local/bin/perl
use strict;
use warnings;
use 5.010;
use Test::Simple tests => 1;
use Data::Dumper::Simple;
$Data::Dumper::Indent = 1;
use TVTorrents;
my $tvt = TVTorrents->new('test');
my $torrents = $tvt->fetch( 'search_string' => 'show', 'debug' => 1 );
print "shows fetched:\n";

foreach ( my $i = 0 ; $i < 10 ; $i++ ) {
    if ($_) {
        if ( $_->{title} ) {
            print substr( $_->{title}, 0, 70 ), ' [...] ', $/;
        }
    }
}
ok( scalar( @{$torrents} ), '1 or more shows fetched' );


