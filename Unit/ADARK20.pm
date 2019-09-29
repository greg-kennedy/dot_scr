package Unit::ADARK20;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
    'Aquatic Realm' => {
        sound => 1,
        cfg => [
            [ 'Creatures'      => 100 ],
            [ 'Seaweed'        => 100 ],
            [ 'Show Sea Floor' => 1 ],
        ]
    },
    'Can of Worms' => {
        sound => 1,
        cfg => [
            [ 'Wiggle'   => 100 ],
            [ 'Segments' => 100 ],
            [ 'Worms'    => 100 ],
        ]
    },
    'Clocks' => {
        sound => 1,
        cfg => [
            [ 'Type'         => 2 ],
            [ 'Sound'        => 3 ],
            [ 'Float Speed'  => 100 ],
            [ 'Show Seconds' => 1 ],
        ]
    },
    'Down the Drain' => {
        cfg => [
            [ 'Speed'      => 100 ],
            [ 'Direction'  => 100 ],
            [ 'Drops'      => 1 ],
            [ 'Show Drain' => 1 ],
        ]
    },

    #'Fade Away'  => { cfg => [
    #    [ 'Style' => 6 ],
    #]},

    'Flying Toasters' => {
        sound => 1,
        cfg => [
            [ 'Flying Things' => 100 ],
            [ 'Toast'         => 100 ],
        ]
    },
    'GeoBounce' => {
        sound => 1,
        cfg => [
            [ 'Shape' => 4 ],
            [ 'Size'  => 100 ],
            [ 'Speed' => 100 ],
            [ 'Faces' => 2 ],
        ]
    },
    'Globe' => {
        cfg => [
            [ 'Rotation' => 100 ],
            [ 'Speed'    => 100 ],
        ]
    },
    'GraphStat' => { cfg => [ [ 'Delay' => 100 ] ] },
    'Gravity'   => {
        sound => 1,
        cfg => [
            [ 'Number Balls' => 100 ],
            [ 'Size'         => 100 ],
            [ 'Clear Screen' => 1 ],
        ]
    },
    'Hall of Mirrors' => {
        cfg => [
            [ 'Mirrors'     => 100 ],
            [ 'Mirror Size' => 3 ],
            [ 'Mirror Life' => 3 ],
            [ 'Speed'       => 100 ],
        ]
    },
    'Hard Rain' => {
        cfg => [
            [ '# of Drops' => 100 ],
            [ 'Drop Size'  => 100 ],
            undef,
            [ 'Clear Screen First' => 1 ],
        ]
    },
    'Lasers' => {
        cfg => [
            [ 'Rays'               => 7 ],
            [ 'Width'              => 100 ],
            [ 'Color Speed'        => 100 ],
            [ 'Clear Screen First' => 1 ],
        ]
    },
    'Logo'  => { cfg => [ [ 'Speed' => 100 ] ] },
    'Magic' => {
        cfg => [
            [ 'Lines'       => 100 ],
            [ 'Line Speed'  => 100 ],
            [ 'Color Speed' => 100 ],
            [ 'Mirror'      => 3 ],
        ]
    },
    'Marbles' => {
        sound => 1,
        cfg => [
            [ 'Redraw Every' => 100 ],
            [ 'Pin Size'     => 100 ],
            [ '# Pins'       => 100 ],
        ]
    },
    'Messages' => {
        cfg => [
            [ 'Move'  => 2 ],
            [ 'Speed' => 100 ],
        ]
    },
    'Mondrian' => {
        cfg => [
            [ 'Speed'              => 100 ],
            [ 'Clear Screen First' => 1 ],
        ]
    },
    'Mountains' => {
        cfg => [
            [ 'View'       => 5 ],
            [ 'Planet'     => 9 ],
            [ 'Complexity' => 100 ],
            [ 'Zoom'       => 100 ],
        ]
    },
    'Nocturnes' => {
        sound => 1,
        cfg => [
            undef,
            undef,
            [ 'Color'   => 1 ],
            [ 'Density' => 100 ],
        ]
    },
    'Penrose' => {
        cfg => [
            [ 'Tile'  => 5 ],
            [ 'Delay' => 100 ],
        ]
    },
    'Punch Out' => {
        sound => 1,
        cfg => [
            [ 'Shape' => 4 ],
            [ 'Size'  => 100 ],
            [ 'Speed' => 100 ],
        ]
    },
    'Puzzle' => {
        sound => 1,
        cfg => [
            [ 'Size'  => 2 ],
            [ 'Speed' => 2 ],
            undef,
            [ 'Invert Screen' => 1 ],
        ]
    },
    'Rainstorm' => {
        cfg => [
            [ 'Strength'  => 100 ],
            [ 'Lightning' => 100 ],
            [ 'Drops'     => 100 ],
            [ 'Wind'      => 100 ],
        ]
    },

    #'Randomizer' => { cfg => [
    #    [ 'Order' => 1 ],
    #    [ 'Duration' => 100 ],
    #]},
    'Rose' => {
        cfg => [
            [ 'Speed'        => 100 ],
            [ 'Trail Length' => 100 ],
            [ 'Big Dots'     => 1 ],
        ]
    },
    'Satori' => {
        cfg => [
            [ 'Display'     => 6 ],
            [ 'Colors'      => 13 ],
            [ 'End Clarity' => 100 ],
            [ 'Knots'       => 100 ],
        ]
    },
    'Shapes' => {
        cfg => [
            [ 'Clear Screen First' => 1 ],
            [ 'Color'              => 1 ],
        ]
    },

    #'Slide Show' => { cfg => [
    #    [ 'Order' => 2],
    #    [ 'Display Time' => 100 ],
    #    [ 'Fade Speed'   => 100 ],
    #]},

    #'Sounder' => {
    #    sound => 1,
    #    cfg => [
    #        [ 'Order' => 2],
    #        [ 'Delay' => 100 ],
    #        undef,
    #        [ 'Blank Screen' => 1 ],
    #    ]
    #},

    'Spheres' => {
        cfg => [
            [ 'Max Size'           => 100 ],
            [ 'Offset'             => 100 ],
            [ 'Clear Every'        => 100 ],
            [ 'Clear Screen First' => 1 ],
        ]
    },
    'Spiral Gyra' => {
        cfg => [
            [ 'Max Lines'     => 100 ],
            [ 'Min Lines'     => 100 ],
            [ 'Color Cycling' => 100 ],
        ]
    },
    'Spotlight' => {
        cfg => [
            [ 'Size'  => 100 ],
            [ 'Speed' => 100 ],
        ]
    },
    'Stained Glass' => {
        cfg => [
            [ 'Complexity'  => 100 ],
            [ 'Duplication' => 100 ],
            [ 'Color'       => 100 ],
        ]
    },
    'Starry Night' => {
        sound => 1,
        cfg => [
            [ 'Buildings'       => 100 ],
            [ 'Building Height' => 100 ],
            undef,
            [ 'Lightning' => 100 ],
        ]
    },
    'String Theory' => {
        cfg => [
            [ 'String Groups'      => 3 ],
            [ 'Strings'            => 100 ],
            [ 'Color Speed'        => 100 ],
            [ 'Clear Screen First' => 1 ],
        ]
    },
    'Swan Lake' => {
        cfg => [
            [ 'Speed'     => 100 ],
            [ 'Num Swans' => 100 ],
            [ 'Synchronized', 1 ],
        ]
    },
    'Vertigo' => {
        cfg => [
            [ 'Palette'      => 2 ],
            [ 'Spiral Pitch' => 100 ],
            [ 'Color Speed'  => 100 ],
            [ 'Delay'        => 100 ],
        ]
    },
    'Warp!' => {
        cfg => [
            [ 'Speed' => 100 ],
            [ 'Stars' => 100 ],
            [ 'Size'  => 2 ],
            [ 'Color' => 1 ],
        ]
    },
    'Wrap Around' => {
        cfg => [
            [ 'Delay'           => 100 ],
            [ 'Number of Lines' => 100 ],
            [ 'Color Speed'     => 100 ],
        ]
    },
    'Zot!' => {
        cfg => [
            [ 'Forkiness' => 100 ],
            undef,
            [ 'How Often' => 100 ],
        ]
    },

    # multimodules
    'Creepy Night'   => undef,
    'Kaleidoscope'   => undef,
    'MultiModule'    => undef,
    'Planetside'     => undef,
    'Psychomotor'    => undef,
    'Space Toasters' => undef,
    'Times Up'       => undef,
);
##############################################################################

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'ADARK20',
        fullname => 'After Dark 2.0c',
        author   => 'Berkeley Systems',
        payload  => ['ADARK20.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
        },
        files_custom => {
            'WINDOWS/ADMODULE.ADS' => \&extra_admodule,
            'WINDOWS/AD_MESG.ADS' => \&extra_messages,
        },
        dosbox => {
            start  => 23000,
            cycles => 3000,
        },
        weight => scalar keys %controls,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    # parse all AD module names
    my %modules;

    open( my $fpi, '<:raw', "$basepath/WINDOWS/ADMODULE.ADS" )
      or die "Couldn't open admodule.ads: $!";
    until ( eof $fpi ) {
        read $fpi, my $buf, 49;
        my ( $filename, $realname ) = unpack 'Z[13]Z[20]x[16]', $buf;
	if ( exists $controls{$realname} ) {
          $modules{$realname} = $filename;
	} else {
          print "Skipping unknown module $realname\n";
	}
    }

    # Pick da winna
    my $module = _pick( keys %modules );

    # Configuration only happens for non-MultiModule entries
    my $cfg     = '';
    my $cfg_str = '';
    my $sound;

    if (! $controls{$module}) {
        $cfg_str = " (MultiModule, no settings)";
        $cfg = pack('v[4]', 0, 0, 0, 0);
        $sound = 1;
    } else {
        if ($controls{$module}{sound}) {
            $sound = 1;
        }
        # Set config options
        for ( my $i = 0 ; $i < 4 ; $i++ ) {
            my $value;
            my $knob = $controls{$module}{cfg}[$i];
            if ( defined $knob ) {
                $value = int( rand( $knob->[1] + 1 ) );
                $cfg_str .=
                  ", $knob->[0]: $value" . ( $knob->[1] == 100 ? '%' : '' );
            } else {
                $value = 0;
            }
            $cfg .= pack( 'v', $value );
        }
    }

    my $self = {
        module       => $module,
        module_file  => $modules{$module},
        settings     => $cfg_str,
        settings_bin => $cfg,
	sound        => $sound,
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    return "Module: $self->{module}" . $self->{settings};

#return { settings => "Module: $self->{module}" . $self->{settings}, sound => $self->{sound} };
}

sub edit_systemini {
    my ( $self, $line ) = @_;

    # After Dark 2.0 has a 386Enh driver that needs loading.
    #  Append it immediately after the 386Enh header.
    if ( defined $line ) {
        if ( $line =~ m/^\[386Enh\]$/i ) {
            $line .= "\ndevice=ad.386";
        } elsif ( $line =~ m/^SCRNSAVE\.EXE=/i ) {
            $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSADARK.SCR";
        }
    }

    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line ) {
      if ( $line =~ m/^load=(.*)$/ ) {
        $line = "load=c:\\afterdrk\\ad.exe c:\\afterdrk\\adinit.exe $1";
      } elsif ( $line =~ m/^ScreenSaveActive=/i ) {
        $line = "ScreenSaveActive=1";
      }
    }

    return $line;
}

sub edit_adprefsini {
    my ( $self, $line ) = @_;

    # AD_PREFS.INI to set up the desired module
    if ($line) {
        if ( $line =~ m/^Module=/i ) {
            $line = "Module=$self->{module}";
        } elsif ( $line =~ m/^ModuleFile=/i ) {
            $line = "ModuleFile=$self->{module_file}";
        }
    }

    return $line;
}

sub extra_admodule {
    my ( $self, $input, $output ) = @_;

    # ADMODULE.ADS to make settings changes for our picks
    open( my $fpi, '<:raw', $input )  or die "Couldn't open $input: $!";
    open( my $fpo, '>:raw', $output ) or die "Can't open $output file: $!";
    until ( eof $fpi ) {
        read $fpi, my $buf, 49;
        my $realname = unpack 'x[13]Z[20]x[16]', $buf;
        if ( $self->{module} eq $realname ) {
            substr( $buf, 33, 8 ) = $self->{settings_bin};
        }
        print $fpo $buf;
    }
}

sub extra_messages {
    my ( $self, $input, $output ) = @_;

    # If MESSAGES is picked we have more work to do
    if ( $self->{module} eq 'Messages' ) {
        my $msgnum = int( rand(8) );
        open( my $fpi, '<:raw', $input )  or die "Couldn't open $input: $!";
        open( my $fpo, '>:raw', $output ) or die "Can't open $output file: $!";

        for ( my $i = 0 ; $i < 8 ; $i++ ) {
            read $fpi, my $buf, 246;
            substr( $buf, 44, 2 ) = pack( 'v', ( $i == $msgnum ) );
            print $fpo $buf;
        }
    }
}

1;
