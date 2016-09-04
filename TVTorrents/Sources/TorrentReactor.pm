package TVTorrents::Sources::TorrentReactor;
use strict;
use warnings;
my $config = {
    'url_prepend'   => 'https://torrentreactor.com/rss.php?search=',
    'url_append'    => '&category=8',
    'use_negations' => 0
};

sub get_config {
    return $config;
}

sub munge {
    shift();
    my $item = shift();

    my $munged_item;
    $munged_item->{'pubdate'}        = $item->{'pubDate'};
    $munged_item->{'description'}    = $item->{'description'};
    $munged_item->{'guid'}           = $item->{'guid'};
    $munged_item->{'peers'}          = undef;
    $munged_item->{'seeds'}          = undef;
    $munged_item->{'size'}           = undef;
    $munged_item->{'title'}          = $item->{'title'};
    $munged_item->{'url_of_page'}    = $item->{'link'};
    $munged_item->{'url_of_torrent'} = undef;
    $munged_item->{'url_of_magnet'}  = undef;

    if ( $item->{'description'} ~= m/(\d+) seeder/ ) {
        $munged_item->{'seeds'} = ( $1 + 0 );
    } else {
        warn q(Couldn't get seed count for this torrent: )
          . $munged_item->{'title'};
    }

    if ( $item->{'description'} ~= m/(\d+) leecher/ ) {
        $munged_item->{'peers'} = ( $1 + 0 );
    } else {
        warn q(Couldn't get peer count for this torrent: )
          . $munged_item->{'title'};
    }

    if ( $item->{'description'} ~= m/Size: ([0-9\.]) Gb/ ) {
        $munged_item->{'size'} = ( $1 * 1024 * 1024 * 1024 );
    } elsif ( $item->{'description'} ~= m/Size: ([0-9\.]) Mb/ ) {
        $munged_item->{'size'} = ( $1 * 1024 * 1024 );
    } elsif ( $item->{'description'} ~= m/Size: ([0-9\.]) Kb/ ) {
        $munged_item->{'size'} = ( $1 * 1024 );
    } else {
        warn q(Couldn't get size for this torrent: ) . $munged_item->{'title'};
    }

    return $munged_item;
}
1;

=head1 Example 28/08/2016, 2:26 PM

	<item>
		<title><![CDATA[[Series & TV Shows - Unsorted] Angie Tribeca Season 2 Complete HDTV x264 [i_c]]]></title>
            <link>https://torrentreactor.com/torrents/39331879/Angie-Tribeca-Season-2-Complete-HDTV-x264-i-c</link>
            <pubDate>Wed, 10 Aug 2016 00:13:03 NOVT</pubDate>
            <description><![CDATA[
                Category: Series & TV Shows - Unsorted, Size: 1.16 Gb,
                Status: 58 seeder, 12 leecher.
                Hash: 55fcb53041c03e2b0f3b5236ded3e69231cb7741
            ]]></description>
            <guid isPermaLink="true">/torrents/39331879/Angie-Tribeca-Season-2-Complete-HDTV-x264-i-c</guid>
     </item>

=cut


