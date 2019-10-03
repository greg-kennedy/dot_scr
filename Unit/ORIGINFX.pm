package Unit::ORIGINFX;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
    'A Daily Quote'         => { cfg => [] },
    'Air Show             ' => { cfg => [ [ 'Clear Screen' => 1 ] ] },
    'Armageddon'            => {
        sound => 1,
        cfg   => [
            [ 'Explosivity'  => 2 ],
            [ 'Craters'      => 3 ],
            [ 'Clear Screen' => 1 ]
        ]
    },
    'Asteroid Field' => {
        cfg => [
            [ 'From Center'   => 1 ],
            [ 'Maximum Items' => [ 1 .. 15 ] ],
            [ 'Space Junk'    => 1 ],
        ]
    },
    'Avalanche' => {
        cfg => [
            [ 'Slide Speed' => [ 1 .. 15 ] ],
            [
                'Color Speed' =>
                  [ 50, 100, 150, 200, 250, 300, 350, 400, 450, 500 ]
            ],
            [ 'Add Color' => 1 ],
        ]
    },
    'Blaze' => {
        cfg => [
            [ 'Alarms'      => 4 ],
            [ 'Wind Speed'  => 2 ],
            [ 'Fuel'        => 2 ],
            [ 'Show Embers' => 1 ],
        ]
    },
    'Bouquet' => {
        sound => 1,
        cfg   => [
            [ 'Roses'        => 6 ],
            [ 'Pollination'  => 1 ],
            [ 'Fertilizer'   => 2 ],
            [ 'Clear Screen' => 1 ],
        ]
    },
    'Building Blox' =>
      { cfg => [ [ 'Random Color' => 1 ], [ 'Clear Screen' => 1 ], ] },
    'Claw And Scratch' => { sound => 1, cfg => [] },
    'Ghost Trax'       => {
        sound => 1,
        cfg   => [ [ 'Colored Feet' => 1 ], [ 'Clear Screen' => 1 ], ]
    },
    'Guardian ' => { cfg => [] },
    'Hypnosis'  => {
        sound => 1,
        cfg   => [
            [ 'Colors'         => 7 ],
            [ 'Bright Palette' => 1 ],
            [ 'Type'           => 3 ],
            [ 'Band Width'     => [ 1 .. 20 ] ],
        ]
    },
    'Magic Spheres' => {
        sound => 1,
        cfg   => [
            [ 'Clear Screen'    => 4 ],
            [ 'Number of Paths' => [ 2 .. 18 ] ],
            [ 'Color'           => 5 ],
            [ 'Size'            => 3 ],
        ]
    },
    'Main Street' => {
        sound => 1,
        cfg   => [ [ 'Add Planes' => 1 ], [ 'Add Cars' => 1 ], ]
    },
    'Mighty Forest' => {
        cfg => [
            [ 'Terrain'        => 3 ],
            [ 'Climate'        => 4 ],
            [ 'Rainfall'       => 2 ],
            [ 'Growth Pattern' => 1 ],
        ]
    },
    'Pixel Stix' => {
        cfg => [
            [ 'Stick Size' => 2 ],
            [
                'Stick Speed' => [
                    10,  20,  30,  40,  50,  60,  70,  80,  90,  100,
                    110, 120, 130, 140, 150, 160, 170, 180, 190, 200
                ]
            ],
            [ 'Color Group'        => 3 ],
            [ 'Clear Screen First' => 1 ],
        ]
    },
    'Prism' => {
        cfg => [
            [ 'Line Speed'   => [ 1 .. 50 ] ],
            [ 'Clean Screen' => 10 ],
            [ 'Color Speed'  => 25 ],
            [ 'Clear Screen' => 1 ],
        ]
    },
    'Psychedelia' => { cfg => [ [ 'Shapes' => 9 ], [ 'Colors' => 7 ], ] },
    'Pyroworx'    => {
        sound => 1,
        cfg   => [
            [ 'Clear Screen' => 4 ], undef,
            undef, [ 'Clear Screen First' => 1 ],
        ]
    },
    'Screen Writer' => { cfg => [ [ 'Font' => 3 ], [ 'Color' => 5 ], ] },
    'Serpent Isle'  => {
        sound => 1,
        cfg   => [ [ 'Show Subtitles' => 1 ], [ 'Show Finale' => 1 ], ]
    },
    'Silhouette' => {
        sound => 1,
        cfg   => [
            [ 'Species'      => 9 ],
            [ 'Size'         => 3 ],
            [ 'Food Supply'  => 2 ],
            [ 'Clear Screen' => 1 ],
        ]
    },
    'Stratosphere' => {
        sound => 1,
        cfg   => [ [ 'Item Type' => 9 ], [ 'Maximum Items' => [ 1 .. 10 ] ], ]
    },
    'Strike Commander'  => {
        sound => 1,
        cfg   => [ [ 'Soundtrack' => 4 ], ]
    },
    'T.C.S. Paradigm' => {
        cfg => [
            [ 'Ship Size'         => 7 ],
            [ 'Warp Speed'        => 9 ],
            [ 'Repaint With Ship' => 1 ]
        ]
    },
    'Ultimate Menagerie' => {
        sound => 1,
        cfg   => [
            [ 'Species'      => 9 ],
            [ 'Size'         => 3 ],
            [ 'Food Supply'  => 2 ],
            [ 'Clear Screen' => 1 ],
        ]
    },
    'Window Washer' => {
        sound => 1,
        cfg   => [ [ 'Speed' => [ 1 .. 6 ] ] ]
    },
    'Wing Commander II' => {
        sound => 1,
        cfg   => [ [ 'Show Subtitles' => 1 ], [ 'Show Logo' => 1 ] ]
    },
);
##############################################################################

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'ORIGINFX',
        fullname => 'Origin FX',
        author   => 'Origin Systems',
        payload  => ['ORIGINFX.zip'],
        files    => {
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/ORIGINFX.INI' => \&edit_originfxini,
        },
        files_custom => {
            'ORIGINFX/ORIGINFX.DAT' => \&extra_originfxdat,
        },
        dosbox => {
            start => 63000,
        },
        weight => scalar keys %controls,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    # parse all OriginFX module names
    my %modules;

    open( my $fpi, '<:raw', "$basepath/ORIGINFX/ORIGINFX.DAT" )
      or die "Couldn't open ORIGINFX.DAT: $!";
    until ( eof $fpi ) {
        read $fpi, my $buf, 60;
        my ( $filename, $realname ) = unpack 'Z[13]Z[30]x[17]', $buf;
        if ($realname) {
            if ( exists $controls{$realname} ) {
                $modules{$realname} = $filename;
            } else {
                print "Skipping unknown module $realname\n";
            }
        }
    }

    # Pick da winna
    my $module = _pick( keys %modules );

    # Set config options
    my $cfg     = '';
    my $cfg_str = '';
    for ( my $i = 0 ; $i < 4 ; $i++ ) {
        my $value;
        my $knob = $controls{$module}{cfg}[$i];
        if ( defined $knob ) {
            if ( ref $knob->[1] eq 'ARRAY' ) {
                $value = _pick( @{ $knob->[1] } );
            } else {
                $value = int( rand( $knob->[1] + 1 ) );
            }

            $cfg_str .= ", $knob->[0]: $value";
        } else {
            $value = 0;
        }
        $cfg .= pack( 'n', $value );
    }

    my $self = {
        module       => $module,
        module_file  => $modules{$module},
        settings     => $cfg_str,
        settings_bin => $cfg,
        sound        => $controls{$module}{sound},
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    # air show has funny spaces after
    my $name = $self->{module};
    $name =~ s/\s+$//;

    return "Module: $name" . $self->{settings};

#return { settings => "Module: $self->{module}" . $self->{settings}, sound => $self->{sound} };
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^load=(.*)$/i ) {
        $line = "load=c:\\originfx\\originfx.exe $1";
    }

    return $line;
}

sub edit_originfxini {
    my ( $self, $line ) = @_;

    if ($line) {
        if ( $line =~ m/^CurrentFile=/i ) {
            $line = "CurrentFile=" . $self->{module_file};
        } elsif ( $line =~ m/^CurrentTitle=/i ) {
            $line = "CurrentTitle=" . $self->{module};
        } elsif ( $line =~ m/^DisplayMode=/i ) {
            $line = "DisplayMode=0";
        }
    }

    return $line;
}

sub extra_originfxdat {
    my ( $self, $input, $output ) = @_;

    # ADMODULE.ADS to make settings changes for our picks
    open( my $fpi, '<:raw', $input )  or die "Couldn't open $input: $!";
    open( my $fpo, '>:raw', $output ) or die "Can't open $output file: $!";
    until ( eof $fpi ) {
        read $fpi, my $buf, 60;
        my $realname = unpack 'x[13]Z[30]x[17]', $buf;
        if ( $self->{module} eq $realname ) {
            substr( $buf, 43, 10 ) =
              ( $self->{settings_bin} . pack( 'n', 121 ) );
        }
        print $fpo $buf;
    }
}

1;
