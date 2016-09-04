package TVTorrents::Sources::Zooqle;
use strict;
use warnings;
my $config = {
    'url_prepend'   => 'https://zooqle.com/search?q=',
    'url_append'    => '&fmt=rss',
    'rss_prefix'    => 'https://zooqle.com/xmlns/0.1/index.xmlns',
    'use_negations' => 1
};

sub get_config {
    return $config;
}

sub munge {
    shift();
    my $item        = shift();
    my $meta        = shift();
    my $munged_item;
    $munged_item->{'pubdate'}        = $item->{'pubDate'};
    $munged_item->{'description'}    = $item->{'description'};
    $munged_item->{'guid'}           = $item->{'link'};
    $munged_item->{'title'}          = $item->{'title'};
    $munged_item->{'url_of_page'}    = $item->{'link'};
    $munged_item->{'url_of_torrent'} = $item->{'enclosure'}->{'url'};
    $munged_item->{'size'}           = $item->{'enclosure'}->{'length'};
    $munged_item->{'url_of_magnet'}  = $item->{'_prefix'}->{'magnetURI'};
    $munged_item->{'seeds'}          = $item->{'_prefix'}->{'seeds'};
    $munged_item->{'peers'}          = $item->{'_prefix'}->{'peers'};
    $munged_item->{'verified'}       = $item->{'_prefix'}->{'verified'};
    return $munged_item;
}
1;

