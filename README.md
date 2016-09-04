# TVTorrents.pm
Perl module to parse TV show RSS feeds from torrent sites

## Summary

    use TVTorrents;
    my $tvt = TVTorrents->new('live');
    $tvt->negations(
    'español', 'subtitulado', 'vostfr', 'swesub',
    'NLSub',   'Lektor PL',   'DKsubs'
    );

    my $search_string = 'angie tribeca';

    my $torrents = $tvt->fetch(
        'search_string' => $search_string,
        'meta'          => 1,
    );

I'm going to put up an Alpha version, not a full module, to get input from people. So just put the files into a folder and `use lib '<path to that folder>'`. You may also need to install [Regexp::Common::time](http://search.cpan.org/~roode/Regexp-Common-time-0.01/time.pm) and [XML::RSS](http://search.cpan.org/~shlomif/XML-RSS-1.59/lib/XML/RSS.pm).

What this module does is abstracts the process of fetching RSS feeds from one or more torrent sites looking for episodes of TV shows.

## Quick Start

Include the module:

    use TVTorrents;

pick a config (multiple configs are available for easy testing), included are `live` and `dev` versions:

    my $tvt = TVTorrents->new('live');

If necessary, include negation terms (those terms preceded by a minus which tell the search engine to skip results with certain strings):

    $tvt->negations(
    'español', 'subtitulado', 'vostfr', 'swesub',
    'NLSub',   'Lektor PL',   'DKsubs'
    ); ## skip spanish, french, swedish, polish, danish specialty subs

Search through all torrent sites listed as `active` in the config file:

    my $search_string = 'angie tribeca';
    my $torrents = $tvt->fetch(
        'search_string' => $search_string,
        'meta'          => 1,
    );

Where the `meta` attribute determines whether the title of each episode will be parsed for season/episode data.

Probably the best way to see what it does is just use `Data::Dumper` on the results to see the structure.

    use Data::Dumper;
    print Dumper($torrents);

## Included RSS-feed parsers

Included (and configured) are parser modules for:

* extratorrent.cc
* limetorrents.cc
* torrentproject.se
* zooqle.com

Obviously the whole point is that as torrent sites come and go, users will be able to create new modules for each one's RSS feed, and the same if the feed's format changes.
