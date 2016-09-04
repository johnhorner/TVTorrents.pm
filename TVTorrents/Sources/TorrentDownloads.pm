package TVTorrents::Sources::TorrentDownloads;
use strict;
use warnings;
my $config = {
    'url_prepend' =>
      'http://www.torrentdownloads.me/rss.xml?type=search&search=',
    'url_append'    => '',
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
    $munged_item->{'guid'}           = $item->{'info_hash'};
    $munged_item->{'peers'}          = ( $item->{'leechers'} + 0 );
    $munged_item->{'seeds'}          = ( $item->{'seeders'} + 0 );
    $munged_item->{'size'}           = $item->{'size'};
    $munged_item->{'title'}          = $item->{'title'};
    $munged_item->{'url_of_page'}    = 'http://www.torrentdownloads.me' . $item->{'link'};
    $munged_item->{'url_of_torrent'} = undef;
    $munged_item->{'url_of_magnet'}  = undef;
    return $munged_item;
}
1;


=head1 Example 28/08/2016, 2:26 PM

      <item>
        <title>Angie Tribeca S02E07 HDTV x264-LOL[ettv]</title>
        <pubDate>Tue, 19 Jul 2016 02:08:38 +0000</pubDate>
        <category><![CDATA[]]></category>
        <link>/torrent/1662179906/Angie+Tribeca+S02E07+HDTV+x264-LOL%5Bettv%5D</link>
        <description></description>
        <size>135156128</size>
        <seeders>551</seeders>
        <leechers>91</leechers>
        <info_hash>1022d667ec11b34024b0792d7dc5ba65680501da</info_hash>
    </item>

=cut