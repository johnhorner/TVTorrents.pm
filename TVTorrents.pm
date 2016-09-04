package TVTorrents;
our $VERSION = '0.1a';
use TVTorrents::Configs;
use TVTorrents::Parser;
use XML::RSS;
use LWP::UserAgent;
my $agent = LWP::UserAgent->new();
### an innocuous-looking UA string in case the server is set to reject Perl scrapers
$agent->agent(
'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
);
use Data::Dumper::Simple;
$Data::Dumper::Indent = 1;
use HTTP::Date qw (parse_date);
use URI::Escape;

sub negations {
    my $self      = shift;
    my @negations = @_;
    $self->{'negations'} = \@negations;
}

sub fetch {
    my $self = shift;
    my %args = @_;
    unless ( $args{'search_string'} ) {
        die "search string is required";
    }

    my @results = ();

    foreach my $source_name ( keys( %{ $self->{'sources'} } ) ) {
        my $source = $self->{'sources'}->{$source_name};
        my $rss    = new XML::RSS;
        if ( $args{'debug'} ) {
            print "Self -> negations " . $/;
            foreach ( @{ $self->{'negations'} } ) {
                print " * $_" . $/;
            }
        }
        if ( $args{'debug'} ) {
            print "Source -> use_negations " . $source->{'use_negations'} . $/;
        }
        if (   $self->{'negations'}
            && $source->{'use_negations'} )
        {
            if ( $args{'debug'} ) {
                print "Adding negation strings to main string\n";
            }
            $search_string .= ' -' . join( ' -', @{ $self->{'negations'} } );
        } else {
            if ( $args{'debug'} ) {
                print "negation strings not added for $source_name\n";
            }
        }
        if ( $args{'debug'} ) {
            print "Source: $source_name\n";
        }
        my $url =
            $source->{'url_prepend'}
          . uri_escape( $args{'search_string'} )
          . $source->{'url_append'};
        if ( $source->{'rss_prefix'} ) {
            $rss->add_module(
                prefix => '_prefix',
                uri    => $source->{'rss_prefix'}
            );
        }

        if ( $args{'debug'} ) { print 'RSS URL: ' . $url; }

        my $response = $agent->get($url);
        if ( $response->is_success() ) {
            if ( $args{'debug'} ) { print "RSS Success: \n"; }
            eval { $rss->parse( $response->content() ) };
            if ($@) {
                warn( 'Parse error: ' . $@ );
                next;
            }
            my $module_name = 'TVTorrents::Sources::' . $source_name;

            if ( $args{'debug'} ) { print "parsed RSS\n"; }

            foreach my $item ( @{ $rss->{'items'} } ) {
                if ( $args{'debug'} ) {
                    print 'TITLE: ' . $item->{'title'}, $/;
                }
                my $munged_item = $module_name->munge( $item, $args{'meta'} );

                ### if ( $args{'debug'} ) { print 'BEFORE: ' . Dumper($item); }
                ### if ( $args{'debug'} ) { print "Munged RSS Item: \n"; }

                if ( $args{trim_descriptions} ) {
                    $munged_item->{description} =
                      substr( $munged_item->{description}, 0, 25 ) . ' [...]';
                }

                if ( $args{'meta'} ) {

                    if ( my $metadata =
                        TVTorrents::Parser::extract_show_info( $item->{title} )
                      )
                    {
                        if ( $metadata->{'type'} eq 'se' ) {
                            $munged_item->{meta_type}   = 'season-episode';
                            $munged_item->{meta_season} = $metadata->{'season'};
                            $munged_item->{meta_episode} =
                              $metadata->{'episode'};
                        }
                        if ( $metadata->{'type'} eq 'date' ) {
                            $munged_item->{meta_type} = 'broadcast date';
                            $munged_item->{meta_broadcast_date} =
                              sprintf( "%d-%02d-%02d",
                                $metadata->{'year'}, $metadata->{'month'},
                                $metadata->{'day'} );
                        }
                        if ( $metadata->{'type'} eq 's' ) {
                            if ( $metadata->{'season'} ) {
                                $munged_item->{meta_type} = 'complete season';
                                $munged_item->{meta_complete_season} =
                                  $metadata->{'season'};
                            } else {
                                $munged_item->{meta_type} = 'multiple season';
                                $munged_item->{meta_multiple_season} =
                                  $metadata->{'range'};
                            }
                        }
                    }
                }

                push( @results, $munged_item );

            }
        } else {
            warn "Couldn't get RSS response from $source_name: "
              . $response->status_line();

        }

    }

    return \@results;

}

sub new {
    my $class       = shift();
    my $config_name = shift();
    unless ($config_name) {
        die
"A config name argument is required. Use 'test' if you don't know which one to use.";
    }
    my $self = {};
    $self->{'sources'} = ();
    my $config = TVTorrents::Configs::get_config($config_name);

    unless ($config->{sources}) {
        return;
    }

    foreach ( keys( %{ $config->{sources} } ) ) {
        next if $config->{sources}->{$_}->{'status'} ne 'active';
        my $module_name = 'TVTorrents::Sources::' . $_;
        eval "use $module_name; 1;";
        if ($@) {
            warn "Couldn't use $module_name: $@";
        } else {
            my $source_config = $module_name->get_config();
            ## print Dumper($source_config);
            if ($source_config) {
                $self->{'sources'}->{$_} = $source_config;
            } else {
                warn "couldn't get config from $module_name";
            }
        }
    }
    return bless( $self, $class );
}

1;


