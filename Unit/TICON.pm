package Unit::TICON;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Aristo-Soft's "Talking Icons" has a few screensavers
#  in addition to its main use: text-to-speech and other
#  weird Windows theme junk.
# Actually, they're After Dark modules.
# They use Video for Windows too.

my %modules = (
    'El Capitan' => {
      'filename' => 'ELCAP',
      'cfg' => [
        undef,
        [ 'Animal speed' => [0 .. 100] ],
      ]
     },
    'Lake' => {
      'filename' => 'LAKE',
      'cfg' => [
        [ 'Ducks' => [0 .. 5] ],
        [ 'Sound' => 1 ],
        [ 'Weather' => [0 .. 100] ],
        [ 'Wind' => [0 .. 100] ],
      ],
    },
    'Snow' => {
      'filename' => 'SNOW',
      'cfg' => [
        [ 'Snowfall' => [0 .. 100] ],
        [ 'Wind' => [0 .. 100] ],
      ]
    },
    'Waterfall' => {
      'filename' => 'WFALL',
      'cfg' => [
        [ 'Junk in Water' => [0 .. 10] ],
        [ 'Water Speed' => [0 .. 100] ],
      ],
    },
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'TICON',
        fullname => 'Talking Icons',
        author   => 'Aristo-Soft, Inc.',
        payload  => ['VFW11E.zip', 'TICON.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&append_controlini,
        },
        dosbox => {
            start => 8000,

            #            cycles => 0,
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
    };

    # Set config options
    for (my $i = 0; $i < 4; $i ++)
    {
        my $setting = $modules{$module}{cfg}[$i];
        if ($setting) {
            if ($setting->[0] eq 'Sound') {
              # sound enabled for this module
              $self->{sound} = 1;
              $self->{config} .= "Ctl$i=1\n";
            } else {
              # It's an array
              my $value = _pick( @{$setting->[1]} );

              $self->{description} .= ", $setting->[0] $value";
              $self->{config} .= "Ctl$i=$value\n";
            }
        } else {
          $self->{config} .= "Ctl$i=1\n";
        }
    }

    $self->{config} .= 'WakeUp=1';

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

    if (defined $line) {
        if ( $line =~ m/^ScreenSaveActive=/i ) {
            $line = "ScreenSaveActive=1";
        }
    } else {
        $line = "[Aristosoft]\nTICON=C:\\TICON";
    }

    return $line;
}

sub append_controlini {
    my ( $self, $line ) = @_;

    if ( !defined $line ) {

        $line = <<"EOF";
[Screen Saver.$self->{module}]
ModulePath=C:\\TICON\\$self->{filename}.AD
$self->{config}
EOF
    }
    return $line;
}

1;
