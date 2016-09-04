package TVTorrents::Sources::Lime;
use strict;
use warnings;
my $config = {
    'url_prepend'   => 'https://www.limetorrents.cc/searchrss/',
    'url_append'    => '/',
    'use_negations' => 0
};

sub get_config {
    return $config;
}

sub munge {
    shift();
    my $item = shift();
    my $meta = shift();
    if ( $item->{'category'} !~ /TV/ ) {
        return;
    }
    my $munged_item;
    $munged_item->{'pubdate'}        = $item->{'pubDate'};
    $munged_item->{'description'}    = $item->{'description'};
    $munged_item->{'guid'}           = $item->{'link'};
    $munged_item->{'title'}          = $item->{'title'};
    $munged_item->{'url_of_page'}    = $item->{'link'};
    $munged_item->{'url_of_torrent'} = $item->{'enclosure'}->{'url'};
    $munged_item->{'url_of_magnet'}  = undef;
    $munged_item->{'seeds'}          = undef;
    $munged_item->{'peers'}          = undef;

    if ( $item->{'description'} =~ m|Seeds[^\d]+(\d+)| ) {
        $munged_item->{'seeds'} = $1;
    } else {
        warn "Can't get seeds for this torrent.";
    }
    if ( $item->{'description'} =~ m|Leechers[^\d]+(\d+)| ) {
        $munged_item->{'peers'} = $1;
    } else {
        warn "Can't get peers for this torrent.";
    }
    return $munged_item;
}
1;

