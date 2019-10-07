package Unit::SWSE;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ] }
sub _trim { my $s = shift; $s =~ s/^\s+//; $s =~ s/\s+$//; return $s }

# Star Wars Screen Entertainment
#  powered by the Intermission engine

my %modules = (
  'Blueprints' => {
    cfg => {
      Sound     => 1,
      TextSound => 1,
      Music     => 4,
      Quality   => 1,
      TextSpeed => [ 1 .. 5 ],
    }
  },
  'Cantina' => {
    cfg => {
      Sound     => 1,
      TextSound => 1,
      Music     => 4,
      Quality   => 1,
      TextSpeed => [ 1 .. 5 ],
    }
  },
  'Character Biographies' => {
    cfg => {
      Sound     => 1,
      TextSound => 1,
      Music     => 4,
      Quality   => 1,
      TextSpeed => [ 1 .. 5 ],
    }
  },
  'Darth Vader' => {
    cfg => {
      Voice   => 1,
      Breath  => 1,
      Music   => 4,
      Quality => 1,
      Delay   => 30,
    }
  },
  'Death Star Trench' => {
    cfg => {
      Sound => 1,
      Music => 4,
      XWing => 1,
      Tie   => 1,
    }
  },
  'Hyperspace' => {
    cfg => {
      Sound    => 1,
      Music    => 4,
      Quality  => 1,
      Delay    => [ 5 .. 60 ],
      NumStars => [ 30 .. 400 ],
    }
  },
  'Imperial Clock' => {
    cfg => {
      Sound      => 1,
      ClockStyle => [ 0, 1 ],
    }
  },
  'Jawas' => {
    cfg => {
      Sound    => 1,
      NumJawas => [ 1 .. 10 ],
      JawaTime => [ 1 .. 5 ],
    }
  },
  'Lightsaber Duel' => {
    cfg => {
      Sound => 1,
      Music => 4,
      Blank => [ 0, 1 ],
    }
  },
  'Poster Art' => {
    cfg => {
      Sound     => 1,
      TextSound => 1,
      Music     => 4,
      Quality   => 1,
      Delay     => 10,
      Captions  => 1,
      TextSpeed => [ 1 .. 5 ],
    }
  },
  'Rebel Clock'    => { cfg => { Sound => 1, } },
  'Scrolling Text' => {
    cfg => {
      Distance    => [ 0 .. 7 ],
      ScrollSpeed => [ 0 .. 6 ],
      TextFile    => 'C:\\SAVER\\SWTEXT.TXT',
      FontInfo =>
        'E0FF000000000000000000000000000000004D532053616E7320536572696600000000000000000000000000000000000000',
      Music   => 4,
      UseEdit => 0,
      Align   => [ 1, 2, 4 ],
    }
  },
  'Space Battles' => {
    cfg => {
      Sound           => 1,
      Music           => 4,
      Viewport        => [ 0, 1 ],
      SmallDrift      => [ 0, 1 ],
      LargeDrift      => [ 0, 1 ],
      ShipDrift       => [ 0, 1 ],
      UseFullScreen   => 1,
      MaxLargePlanets => [ 0 .. 8 ],
      MaxSmallPlanets => [ 0 .. 11 ],
      MaxShips        => [ 2 .. 14 ],
      ChangeScene     => [ 0, 60 ]
    }
  },
  'Storyboards' => {
    cfg => {
      Sound     => 1,
      TextSound => 1,
      Music     => 4,
      Quality   => 1,
      TextSpeed => [ 1 .. 5 ],
      StartAt   => 2,
    }
  }
);

# Info routine: return basic details about this module
sub info {
  return (
    name     => 'SWSE',
    fullname => 'Star Wars Screen Entertainment',
    author   => 'LucasArts',
    payload  => [ 'WING10.zip', 'SWSE.zip' ],
    files    => {
      'WINDOWS/SYSTEM.INI' => \&edit_systemini,
      'WINDOWS/WIN.INI'    => \&edit_winini,
      'WINDOWS/ANTSW.INI'  => \&edit_antswini,
      'WINDOWS/SWSE.INI'   => \&edit_swseini,
    },
    dosbox => {
      start => 8000,

      #cycles => 5000
    },

    weight => scalar keys %modules,
  );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
  my $class    = shift;
  my $basepath = shift;

  # parse the module input file
  open( my $fpi, '<:crlf', "$basepath/WINDOWS/ANTSW.INI" )
    or die "Couldn't open antsw.ini: $!";
  my $section = '';
  my $id  = 0;
  while ( my $line = <$fpi> ) {
    $line = _trim($line);
    if ( $line =~ m/^\[([^\]]+)\]$/ ) {
        $section = uc($1);
    } elsif ( $section eq 'INTERMISSION EXTENSIONS' ) {
      if ( $line =~ m/^([^=]+)=([^~]+)~([^~]+)~/ ) {
        my $ini_modfilename = $1;
        my $ini_modname = $3;
        if ( exists $modules{$ini_modname} ) {
          $modules{$ini_modname}{id} = $id;
	  print $ini_modname . "=" . $id . "\n";
        } else {
          print "Skipping unknown module $ini_modname ($ini_modfilename)\n";
        }
        $id++;
      }
    }
  }
  close $fpi;

  # choose module (name)
  my $module = _pick( keys %modules );
  if ( !defined $modules{$module}{id} ) {
    die "Error: selected module $module but no ID exists!";
  }

  # Configuration only happens for non-MultiModule entries
  my $cfg     = '';
  my $cfg_str = '';
  my $sound;

  foreach my $ctl_name ( keys %{ $modules{$module}{cfg} } ) {
    my $value;
    my $control = $modules{$module}{cfg}{$ctl_name};
    if ( ref $control eq 'ARRAY' ) {

      # Array means there is a choice, so we should
      #  add detail to the tweet too
      $value = _pick( @{$control} );
      $cfg_str .= ", $ctl_name: $value";
    } else {

      # No array = hardcoded value, no sense adding to
      #  settings desc
      $value = $control;
    }

    $cfg .= "$ctl_name=$value\n";
  }

  my $self = {
    module      => $module,
    id          => $modules{$module}{id},
    settings    => $cfg,
    description => $cfg_str,
    sound       => 1,
  };

  return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
  my $self = shift;

  return "Module: " . $self->{module} . $self->{description};
}

##############################################################################

sub edit_systemini {
  my ( $self, $line ) = @_;

  # append the 386 driver
  if ( $line && $line =~ m/^\[386Enh\]$/i ) {
    $line .= "\ndevice=ANTHOOK.386";
  }
  return $line;
}

sub edit_winini {
  my ( $self, $line ) = @_;

  if ( $line && $line =~ m/^load=(.*)$/ ) {
    $line = "load=c:\\saver\\intermis.exe $1";
  }

  return $line;
}

sub edit_antswini {
  my ( $self, $line ) = @_;

  if ( $line && $line =~ m/^Saver Selected=/i ) {
    $line = "Saver Selected=$self->{id}";
  }

  return $line;
}

sub edit_swseini {
  my ( $self, $line ) = @_;

  if ( !defined $line ) {
    $line = "[$self->{module}]\n" . $self->{settings};
  }

  return $line;
}
1;

