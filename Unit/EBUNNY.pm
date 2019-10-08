package Unit::EBUNNY;
use strict;
use warnings;

my @sound_names = (
    '(None)',
    'Nothing Outlasts...',
    'Still Going...',
    'Bass Drum',
    'Toy Drum',
    'Deep Sea Sounds',
    'Western Tune',
);

my @saver_names = (
    '(None)',
    '(Randomize)',
    'E.B. on Parade (small)',
    'Parachuting',
    'Watery World',
    'E.B. in the Old West',
    'Parachuting (small)',
    'E.B. on Parade',
    'Lasers'
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'EBUNNY',
        fullname => 'Energizer Bunny Screen Saver',
        author   => 'PC Dynamics',
        payload  => ['EBUNNY.zip'],
        files    => {
            'WINDOWS/WIN.INI' => \&edit_winini,
            'WINDOWS/BUNNY.INI' => \&edit_bunnyini,
        },

        weight => 7,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    # pick screensaver
    my $module = 2 + int( rand(7) );

    my $sound;
    if ( $module == 4 ) {
        # always use the custom sound for these modules
        $sound = 6;
    } elsif ( $module == 5 ) {
        $sound = 6;
    } elsif ( $module == 8 ) {
        $sound = 0;
    } else {
        # use a random sound for the others
        $sound = 1 + int( rand(4) );
    }

    my $self = {
        module => $module,
        sound  => $sound,
        dosbox => {
            start => 33000,

            #            cycles => 0
        },
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    my $description = "Module: " . $saver_names[ $self->{module} ];
    if ( $self->{sound} ) {
        $description .= ", Sound: " . $sound_names[ $self->{sound} ];
    }

    return $description;
}

##############################################################################
# Edit and Append functions
sub edit_winini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
        if ( $line =~ m/^load=(.*)$/i ) {
            $line = "load=C:\\BUNNY\\BUNNY.EXE $1";
        }
    } else {
        $line = "[Bunny]\nInstall=C:\\BUNNY\n";
    }

    return $line;
}

sub edit_bunnyini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
        if ( $line =~ m/^SaverSelection=/i ) {
            $line = 'SaverSelection=' . $self->{module};
        } elsif ( $line =~ m/^SaverSoundSel=/i ) {
            $line =
              'SaverSoundSel=' . ( $self->{sound} > 5 ? 5 : $self->{sound} );
        }
    }

    return $line;
}

1;

