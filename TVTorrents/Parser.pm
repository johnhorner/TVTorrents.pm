package TVTorrents::Parser;

use Regexp::Common qw(time);

sub extract_show_info {
    my $input_string = shift();
    my $result       = undef;

    if ( $result = extract_episode_data($input_string) ) {
        $result->{type} = 'se';
    } elsif ( $result = extract_season_data($input_string) ) {
        $result->{type} = 's';
    } elsif ( my @date = $input_string =~ /$RE{time}{ymd}{-keep}/ ) {
        $result = {
            type  => 'date',
            year  => $date[1],
            month => $date[2],
            day   => $date[3]
        };
	### special case for the post Jon Stewart daily show
	### people put the year in brackets for some reason
    } elsif ( $input_string =~ /\((\d\d\d\d)\) (\d\d) (\d\d)/ ) {
        $result = {
            type  => 'date',
            year  => $1,
            month => $2,
            day   => $3
        };

    }

    return $result;
}

sub extract_episode_data {
    my $input_string = shift();
    if (   $input_string =~ /s(\d+)\s*e(\d+)/i
        || $input_string =~ /s(\d+)\.e(\d+)/i
        || $input_string =~ /(\d+)x(\d+)/i
        || $input_string =~ /Season\s*(\d+),?\s*Ep\S*\s*(\d+)/i
        || $input_string =~ /Series\.(\d+)\.(\d+)/ )
    {
        my $episode_data = { season => ( $1 + 0 ), episode => ( $2 + 0 ) };
        return $episode_data;
    } else {
        return;
    }

}

sub extract_season_data {

    my $input_string = shift();

    if (
        $input_string =~ /complete/i
        && (

               $input_string =~ /s(?:eason)?\s*(\d{1,2}\s*\-\s*\d{1,2}\b)/i
            || $input_string =~ /s(?:eason)?\s*(\d+,\d+)/i
            || $input_string =~ /s(?:eason)?\s*(\d+\s*\&\s*\d+)/i
            || $input_string =~ /s(?:eason)?\s*(\d+\s*to\s*\d+)/i
            || $input_string =~ /(season\s*\d+\s*to\s*season\s*\d+)/i
        )

      )

    {
        my $data = { range => $1 };
        return $data;

    } elsif ( $input_string =~ /complete/i
        && $input_string =~ /s(?:eason)?\s*(\d+)/i )

    {
        my $data = { season => ( $1 + 0 ) };
        return $data;

    }

    else {
        return;
    }

}

1;

