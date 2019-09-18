package Unit::IDLEWILD;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %modules = (
    'Boat Race' => {
        'Number of Boats ID' => {
            'Two'    => 100,
            'Three'  => 101,
            'Four'   => 102,
            'Random' => 103,
        },

        #'Number of Laps ID' => {
        #    'One' => 114,
        #}
    },
    'Bricks'           => undef,
    'Chomp'            => undef,
    'Dancing Lines'    => undef,
    'Divide & Conquer' => {
        'Method' => {
            'Alternate Horizontal and Vertical' => 0,
            'Both Horizontal and Vertical'      => 1,
            'Horizontal Only'                   => 2,
            'Vertical Only'                     => 3,
        }
    },
    'Dropout'      => undef,
    'Fade Away'    => undef,
    'Fireworks'    => undef,
    'IconBownz!'   => undef,
    'Life'         => undef,
    'Mandelbrot'   => undef,
    'Oriental Rug' => {
        'Pixel Size ID' => {
            '1'      => 101,
            '2'      => 102,
            '3'      => 103,
            '4'      => 104,
            '5'      => 105,
            '6'      => 106,
            'Random' => 107,
        },
        'Period ID=' => {
            '1'      => 111,
            '2'      => 112,
            '4'      => 113,
            '6'      => 114,
            '8'      => 115,
            '10'     => 116,
            'Random' => 117,
        }
    },

    #'Random' => undef,
    'Shuffle'    => undef,
    'Spider Web' => {
        'Skill ID' => {
            'Rookie'       => 101,
            'Amateur'      => 102,
            'Semi-Pro'     => 103,
            'Professional' => 104,
            'Random'       => 105,
        }
    },
    'Spotlights' => {
        'Shade' => {
            'Light'  => 104,
            'Medium' => 105,
            'Dark'   => 106,
            'Black'  => 107,

            #'Random' => 108,
        },
        'Shape' => {
            'Circle' => 109,
            'Square' => 110,
        },
        'Width'  => [ 2 .. 25 ],
        'Number' => [ 1 .. 4 ],
    },
    'Stars'   => undef,
    'Stretch' => undef,
    'Tinfoil' => undef,
    'Trails'  => {
        'Snakes' => [ 1 .. 15 ],
        'Length' => [ 3 .. 10 ],
        'Width'  => [ 1 .. 8 ],
        'Twisty' => [ 1 .. 15 ],
    },

    #'Wipe Out' => undef,
);
##############################################################################

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'IDLEWILD',
        fullname => 'IdleWild',
        author   => 'Microsoft (Bradford Christian et al)',
        payload  => ['IDLEWILD.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/IDLEWILD.INI' => \&edit_idlewild,
        },
        dosbox => {
            start => 8000,
        },
        weight => scalar keys %modules,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    # Pick da winna
    my $module = _pick( keys %modules );

    # Set config options
    my %cfg;
    my $cfg_str = '';
    if ( $modules{$module} ) {
        foreach my $setting ( keys %{ $modules{$module} } ) {

            my $value;
            my $label;
            if ( ref $modules{$module}{$setting} eq 'ARRAY' ) {

                # array types have no special name for their options
                $value = _pick( @{ $modules{$module}{$setting} } );
                $label = $value;
            } else {

                # hash types have name => value mapping
                $label = _pick( keys %{ $modules{$module}{$setting} } );
                $value = $modules{$module}{$setting}{$label};
            }

            $cfg{$setting} = $value;

            my $setting_name = $setting;
            $setting_name =~ s/ ID$//;
            $cfg_str .= ", $setting_name=$label";
        }
    }

    my $self = {
        module       => $module,
        settings     => \%cfg,
        settings_str => $cfg_str,
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    return "Module: $self->{module}" . $self->{settings_str};
}

##############################################################################
# IDLEWILD is a bit awkward because it needs to be loaded with load=
#  but it ALSO uses the built-in screensaver methods (SCRNSAVE.EXE,
#  ScreenSaveActive, ScreenSaveTimeout)

# helper: dump ini-format of cfg block
sub write_ini {
    my $self = shift;
    my $line = "[$self->{module}]\n";
    foreach my $key ( keys %{ $self->{settings} } ) {
        $line .= "$key=" . $self->{settings}{$key} . "\n";
    }
    return $line . "\n";
}

sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WEP\\IDLEWILD.EXE";
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
        if ( $line =~ m/^load=(.*)$/ ) {
            $line = "load=c:\\wep\\idlewild.exe $1";
        } elsif ( $line && $line =~ m/^ScreenSaveActive=/i ) {
            $line = "ScreenSaveActive=1";
        }
    } else {
        $line = <<"EOF";
[IdleWild]
BlankWith=$self->{module}
BlankMouse=0
HotCorners=2 3

EOF

        # A bug in "Trails" causes its settings to be written
        #  here instead of IDLEWILD.INI
        if ( $self->{module} eq 'Trails' ) {
            $line .= $self->write_ini();
        }
    }

    return $line;
}

# IDLEWILD.INI hacking: this file is 0 bytes in
#  the payload
sub edit_idlewild {
    my ( $self, $line ) = @_;

    if ( $self->{settings} && !defined $line ) {
        $line = $self->write_ini();
    }

    return $line;
}
