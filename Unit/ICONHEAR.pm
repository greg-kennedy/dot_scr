package Unit::ICONHEAR;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Icon Hear-It isn't really multiple modules,
#  it's easier to pack them together though.

my %modules = (
    'Bubbles' => {
      'filename' => 'Bubbles',
      'cfg' => {
        'Max_Bubbles' => [1 .. 20],
        'Sound' => 1,
      },
     },
    'Bullet Holes' => {
      'filename' => 'Bullet',
      'cfg' => {
        'Max_Bullets' => [1 .. 10],
        'Sound' => 1,
      },
    },
#    'Dim the Screen' => {
#      'filename' => 'DimIt',
#      'cfg' => {
#        'Percent_Dim' => [1 .. 3],
#      },
#    },
    'Float the Screen' => {
      'filename' => 'Floater',
    },
    'Float a Bitmap' => {
      'filename' => 'FloatBMP',
      'cfg' => {
        'Bitmap' => undef,
      }
    },
    'Lines-O-Plenty' => {
      'filename' => 'Moire',
      'cfg' => {
        'Max_Lines' => [1 .. 4],
        'Sound' => 1,
      },
    },
    'Rip-It' => {
      'filename' => 'RipIt',
      'cfg' => {
        'Sound' => 1,
      },
    },
    'Splotches' => {
      'filename' => 'Splotch',
    },
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'ICONHEAR',
        fullname => 'Icon Hear-It',
        author   => 'Moon Valley Software',
        payload  => ['ICONHEAR.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&append_controlini,
        },

        weight => scalar keys %modules,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    # Pick da winna
    my $module = _pick( keys %modules );

    # create initial object
    my $self = {
        module      => $module,
        filename    => $modules{$module}{filename},
        description => 'Module: ' . $module,
        config      => '',
        dosbox => {
            start => 8000,

            #            cycles => 0,
        },
    };

    # Set config options

    if ( $modules{$module}{cfg} ) {
        foreach my $setting ( sort keys %{ $modules{$module}{cfg} } ) {
            if ($setting eq 'Sound') {
              # sound enabled for this module
              $self->{sound} = 1;
              $self->{config} .= "Sound=1\n";
            } elsif ($setting eq 'Bitmap') {
              # choose a random bitmap from Windows folder
              opendir( my $dh, $basepath . '/WINDOWS' );
              my @files = readdir($dh);
              closedir($dh);

              my @bmps;
              foreach my $file (@files) {
                  if ( $file =~ m/^.+\.bmp$/i ) {
                      push @bmps, $file;
                  }
              }

              # Pick today's winner
              my $bmp = _pick(@bmps);
              $self->{config} .= "Bitmap=C:\\WINDOWS\\$bmp.BMP\n";
              $self->{description} .= ", bitmap \"$bmp\"";
            } else {
              # It's an array
              my $value = _pick( @{$modules{$module}{cfg}{$setting}} );

              $self->{config} .= "$setting=$value\n";
              $self->{description} .= ", $setting $value";
            }
        }
    }

    $self->{config} .= 'PWProtected=0';

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    return $self->{description};
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\" . uc($self->{filename}) . ".SCR";
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^ScreenSaveActive=/i ) {
        $line = "ScreenSaveActive=1";
    }

    return $line;
}

sub append_controlini {
    my ( $self, $line ) = @_;

    if ( !defined $line ) {

        $line = <<"EOF";
[ScreenSaver.$self->{filename}]
$self->{config}
EOF
    }
    return $line;
}

1;
