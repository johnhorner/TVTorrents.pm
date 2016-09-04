package TVTorrents::Configs;

use strict;
use warnings;

my $configs = {
    'live' => {
        'sources' => {
            'Lime'    => { 'status' => 'active' },
            'Extra'   => { 'status' => 'active' },
            'Zooqle'  => { 'status' => 'active' },
            'Project' => { 'status' => 'active' }
        },
    },
    'test' => {
        'sources' => {
            'Extra' => { 'status' => 'active' },
        }
    }
};

sub get_config {
    my $config_name = shift();
    if ( $configs->{$config_name} ) {
        return $configs->{$config_name};
    } else {
        warn "No config named `$config_name`";
        return;
    }

}

1;


