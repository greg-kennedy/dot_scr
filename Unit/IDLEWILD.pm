package Unit::IDLEWILD;
use strict;
use warnings;

##############################################################################
# giant module settings meanings

# IdleWild has a quirk where the delay before restarting the saver is the same
#  as the initial Windows delay before launching. So most of these are delayed
#  150 seconds to fit a full cycle in Twitter's limits.
# Some do not play the entire time (e.g. tinfoil, divide & conquer) and so
#  they have shorter times to force a repeat.  If left running they will just
#  revert to 'random', which spoils the effect.
# Alternate solution is to simply cut the vid at this point...
my %modules = (
  'Boat Race' => {
    runtime => 150,
    cfg   => {
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
  },
  'Bricks'           => { runtime => 150, },
  'Chomp'            => { runtime => 150, },
  'Dancing Lines'    => { runtime => 150, },
  'Divide & Conquer' => {
    runtime => 40,
    cfg   => {
      'Method' => {
        'Alternate Horizontal and Vertical' => 0,
        'Both Horizontal and Vertical'      => 1,
        'Horizontal Only'                   => 2,
        'Vertical Only'                     => 3,
      }
    }
  },
  'Dropout'      => { runtime => 150, },
  #'Fade Away'    => { runtime => 150, },
  'Fireworks'    => { runtime => 150, },
  'IconBownz!'   => { runtime => 30, },
  'Life'         => { runtime => 150, },
  'Mandelbrot'   => { runtime => 150, },
  'Oriental Rug' => {
    runtime => 150,
    cfg   => {
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
    }
  },

  #'Random' => { runtime => 150, },
  'Shuffle'    => { runtime => 150, },
  'Spider Web' => {
    runtime => 150,
    cfg   => {
      'Skill ID' => {
        'Rookie'       => 101,
        'Amateur'      => 102,
        'Semi-Pro'     => 103,
        'Professional' => 104,
        'Random'       => 105,
      }
    }
  },
  'Spotlights' => {
    runtime => 150,
    cfg   => {
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
    }
  },
  'Stars'   => { runtime => 150, },
  'Stretch' => { runtime => 40, },
  'Tinfoil' => { runtime => 30, },
  'Trails'  => {
    runtime => 150,
    cfg   => {
      'Snakes' => [ 1 .. 15 ],
      'Length' => [ 3 .. 10 ],
      'Width'  => [ 1 .. 8 ],
      'Twisty' => [ 1 .. 15 ],
    }
  },

  #'Wipe Out' => { runtime => 150, },
);
##############################################################################

sub _pick { return $_[ rand @_ ] }

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
  if ( $modules{$module}{cfg} ) {
    foreach my $setting_name ( keys %{ $modules{$module}{cfg} } ) {
      my $opt = $modules{$module}{cfg}{$setting_name};

      my $value;
      my $label;
      if ( ref $opt eq 'ARRAY' ) {

        # array types have no special name for their options
        $value = _pick( @{$opt} );
        $label = $value;
      } else {

        # hash types have name => value mapping
        $label = _pick( keys %{$opt} );
        $value = $opt->{$label};

        # special hack for timing of Divide & Conquer
        if ($setting_name eq 'Method') {
          if ($value > 0) {
            $modules{$module}{runtime} = 17;
          } else {
            $modules{$module}{runtime} = 34;
          }
        }
      }

      $cfg{$setting_name} = $value;

      #my $setting_name = $setting;
      $setting_name =~ s/ ID$//;
      $cfg_str .= ", $setting_name=$label";
    }
  }

  # calculate starting time based on runtime
  my $start = 3000 + ( 1000 * $modules{$module}{runtime} );

  my $self = {
    module       => $module,
    runtime      => $modules{$module}{runtime},
    settings     => \%cfg,
    settings_str => $cfg_str,
    dosbox       => { start => $start },
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
    if ( $line =~ m/^load=(.*)$/i ) {
      $line = "load=c:\\wep\\idlewild.exe $1";
    } elsif ( $line =~ m/^ScreenSaveActive=/i ) {
      $line = "ScreenSaveActive=1";
    } elsif ( $line =~ m/^ScreenSaveTimeout=/i ) {
      $line = "ScreenSaveTimeout=" . $self->{runtime};
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
