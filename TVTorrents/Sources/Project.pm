package TVTorrents::Sources::Project;
use strict;
use warnings;
my $config = {
    'url_prepend'   => 'https://torrentproject.se/rss/',
    'url_append'    => '/',
    'use_negations' => 1
};

sub get_config {
    return $config;
}

sub munge {
    shift();
    my $item = shift();
    my $meta = shift();
    if ( $item->{'category'} ne 'tv' ) {
        return;
    }
    my $munged_item;
    $munged_item->{'pubdate'}        = $item->{'pubDate'};
    $munged_item->{'description'}    = $item->{'description'};
    $munged_item->{'guid'}           = $item->{'guid'};
    $munged_item->{'size'}           = $item->{'enclosure'}->{'length'};
    $munged_item->{'title'}          = $item->{'title'};
    $munged_item->{'url_of_page'}    = $item->{'link'};
    $munged_item->{'url_of_torrent'} = $item->{'enclosure'}->{'url'};

    if ( $item->{'description'} =~ m|<seeds>(\d+)</seeds>| ) {
        $munged_item->{'seeds'} = $1;
    } else {
        warn "Can't get seeds for this torrent.";
    }
    if ( $item->{'description'} =~ m|<leechers>(\d+)</leechers>| ) {
        $munged_item->{'peers'} = $1;
    } else {
        warn "Can't get peers for this torrent.";
    }
    $munged_item->{'peers'} = $1;
    return $munged_item;
}
1;


