package TVTorrents::Sources::Extra;
use strict;
use warnings;
my $config = {
    'url_prepend'   => 'https://extratorrent.cc/rss.xml?type=search&search=',
    'url_append'    => '',
    'use_negations' => 1
};

sub get_config {
    return $config;
}

sub munge {
    shift();
    my $item = shift();
    my $meta = shift();
    if ( $item->{'category'} ne 'TV' ) {
        return;
    }
    my $munged_item;
    $munged_item->{'pubdate'}     = $item->{'pubDate'};
    $munged_item->{'description'} = $item->{'description'};
    $munged_item->{'guid'}        = $item->{'link'};

    ### Extratorrent puts '---' for blank seed/peer numbers
    if ( $item->{'leechers'} =~ /\d/ ) {
        $munged_item->{'peers'} = ( $item->{'leechers'} + 0 );
    } else {
        warn "Can't get peers for this torrent: $item->{'title'}";
    }

    if ( $item->{'seeders'} =~ /\d+/ ) {
        $munged_item->{'seeds'} = ( $item->{'seeders'} + 0 );
    } else {
        warn "Can't get seeds for this torrent: $item->{'title'}";
    }
    $munged_item->{'size'}           = $item->{'size'};
    $munged_item->{'title'}          = $item->{'title'};
    $munged_item->{'url_of_page'}    = $item->{'link'};
    $munged_item->{'url_of_torrent'} = $item->{'enclosure'}->{'url'};
    $munged_item->{'url_of_magnet'}  = undef;
    return $munged_item;
}
1;


