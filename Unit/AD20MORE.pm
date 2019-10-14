package Unit::AD20MORE;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
  'Bogglins' => {
    sound => 1,
    cfg   => [ [ 'Explosivity' => 100 ], [ 'Twanginess' => 100 ], ]
  },
  'Boris' => {
    sound => 1,
    cfg   => [ [ 'Number of Cats' => 100 ], [ 'Butterfly' => 100 ], ]
  },
  'Bulge' => {
    cfg => [ [ 'Size' => 100 ], [ 'Speed' => 100 ], [ 'Restore Bulges' => 1 ], ]
  },
  'ConfettiFactory' => {
    sound => 1,
    cfg =>
      [ undef, [ 'Ducks' => 100 ], [ 'Workshift' => 100 ], [ 'Type' => 2 ], ]
  },
  'Dominoes' => {
    sound => 1,
    cfg   => [ [ 'Speed' => 100 ], [ 'Type' => 3 ], ]
  },
  'Einstein' => {
    sound => 1,
    cfg   => [
      undef,
      [ 'Errors'     => 100 ],
      [ 'Neatness'   => 100 ],
      [ '# of Lines' => 100 ],
    ]
  },
  'Flocks' => {
    sound => 1,
    cfg   => [ [ 'Flock Size' => 100 ], [ 'Type' => 6 ], ]
  },
  'Fractal Forest' => {
    sound => 1,
    cfg   => [
      [ 'Num. of Trees' => 100 ],
      [ 'Type'          => 5 ],
      [ 'Season'        => 3 ],
      [ 'Seasons Last'  => 100 ],
    ]
  },
  'Guts' => { cfg => [ [ 'Shapes' => 4 ], [ 'Speed' => 100 ], ] },
  'Hallucinations' =>
    { cfg => [ [ 'Amount' => 100 ], [ 'Clear Screen' => 100 ], ] },
#  'Lunatic Fringe' => {
#    sound => 1,
#    cfg   => [ undef, undef, undef, [ 'Starting Level' => 100 ], ]
#  },
  'Mandelbrot' => { cfg => [ [ 'Delay' => 100 ], [ 'Colors' => 4 ], ] },
  'Meadow'     => { cfg => [ [ 'Season' => 3 ], [ 'Seasons Last' => 100 ], ] },
  'Modern Art' => { cfg => [ [ 'Style'  => 3 ], [ 'Idle Time'    => 100 ], ] },
  'Mosaic'     => {
    cfg =>
      [ undef, [ 'Clear Screen' => 1 ], [ 'Delay' => 100 ], [ 'Style' => 3 ], ]
  },
  "Mowin' Man" => {
    sound => 1,
    cfg   => [
      [ 'Speed'              => 3 ],
      [ 'Mow Every'          => 100 ],
      [ 'Clear Screen First' => 1 ],
      [ 'Growth Rate'        => 100 ],
    ]
  },
  'Om Appliances' => {
    sound => 1,
    cfg   => [
      [ 'Entities'     => 100 ],
      [ 'Life Energy'  => 100 ],
      [ 'Defrost'      => 100 ],
      [ 'Washer Karma' => 100 ],
    ]
  },
  'Origami' => {
    cfg => [
      [ 'Segments' => 100 ],
      [ 'Effect'   => 5 ],
      [ 'Symmetry' => 100 ],
      [ 'Length'   => 100 ],
    ]
  },
  'Pearls' =>
    { cfg => [ [ 'Shapes' => 10 ], [ 'Detail' => 100 ], [ 'Pause' => 100 ], ] },
  'Rain' => {
    sound => 1,
    cfg   => [ [ 'Rain Amount' => 100 ], [ 'Colors' => 2 ], ]
  },
  'Say What?' =>
    { cfg => [ [ 'Show Every' => 100 ], undef, [ 'Draw Border' => 1 ], ] },
  'Snake' => {
    cfg => [
      [ 'Solution Speed'  => 100 ],
      [ 'Maze Complexity' => 100 ],
      [ 'Pause When Done' => 100 ],
    ]
  },
  'Spin Brush' => {
    cfg => [
      [ 'Switch Every' => 100 ],
      [ 'Thickness'    => 100 ],
      [ 'Use Screen'   => 1 ],
      [ 'Spin'         => 4 ],
    ]
  },
#  'Starry Night' => {
#    sound => 1,
#    cfg   => [
#      [ 'Buildings'       => 100 ],
#      [ 'Building Height' => 100 ],
#      undef,
#      [ 'Lightning' => 100 ],
#    ]
#  },
  'Strange Attract' =>
    { cfg => [ [ 'Duration' => 100 ], [ 'Color Speed' => 100 ], ] },
  'Sunburst' => { cfg => [ [ 'Delay'     => 100 ], ] },
  'Tunnel'   => { cfg => [ [ 'Direction' => 1 ], [ 'Shape' => 2 ], ] },

);
##############################################################################

sub _pick { return $_[ rand @_ ] }

# Info routine: return basic details about this module
sub info {
  return (
    name     => 'AD20MORE',
    fullname => 'More After Dark (2.0c)',
    author   => 'Berkeley Systems',
    payload  => ['AD20MORE.zip'],
    files    => {
      'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
      'WINDOWS/WIN.INI'      => \&edit_winini,
      'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
    },
    files_custom => {
      'WINDOWS/ADMODULE.ADS' => \&extra_admodule,
      'WINDOWS/SAYING.ADS'   => \&extra_sayings,
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

  if ( !$controls{$module} ) {
    $cfg_str = " (MultiModule, no settings)";
    $cfg     = pack( 'v[4]', 0, 0, 0, 0 );
    $sound   = 1;
  } else {
    if ( $controls{$module}{sound} ) {
      $sound = 1;
    }

    # Set config options
    for ( my $i = 0; $i < 4; $i++ ) {
      my $value;
      my $knob = $controls{$module}{cfg}[$i];
      if ( defined $knob ) {
        $value = int( rand( $knob->[1] + 1 ) );
        $cfg_str .= ", $knob->[0]: $value" . ( $knob->[1] == 100 ? '%' : '' );
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
    dosbox       => {
      start  => 23000,
      cycles => 3000,
    },
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

  if ($line) {
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

sub extra_sayings {
  my ( $self, $input, $output ) = @_;

  # If MESSAGES is picked we have more work to do
  if ( $self->{module} eq 'Messages' ) {
    my $msgnum = int( rand(8) );
    open( my $fpi, '<:raw', $input )  or die "Couldn't open $input: $!";
    open( my $fpo, '>:raw', $output ) or die "Can't open $output file: $!";

    for ( my $i = 0; $i < 8; $i++ ) {
      read $fpi, my $buf, 246;
      substr( $buf, 44, 2 ) = pack( 'v', ( $i == $msgnum ) );
      print $fpo $buf;
    }
  }
}

1;
