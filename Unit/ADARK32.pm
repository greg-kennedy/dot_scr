package Unit::ADARK32;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
  'AD30' => {
    'Artist' => {
      # extra cfg hack
      cfg => [
        [ 'Medium' => 7 ],
        [ 'Detail' => 100 ],
        [ 'Delay'  => 100 ],
      ]
    },
    'Bad Dog!' => {
      sound => 1,
      cfg   => [ [ 'Discipline' => 100 ], ]
    },
    'Bugs' => {
      # extra cfg hack
      sound => 1,
      cfg   => [
        [ 'Bug Density' => 100 ],
        undef, # Bug Type
        [ 'Clear Screen First' => 1 ],
      ]
    },
    'Clocks 3.0' => {
      sound => 1,
      cfg   => [
        [ 'Type'          => 4 ],
        [ 'Drift Speed'   => 100 ],
        [ 'Sounds'        => 2 ],     # skipping 'None'
        [ 'Mutation Rate' => 100 ],
      ]
    },
    'Daredevil Dan' => {
      sound => 1,
      cfg   => [ [ 'Insurance Risk' => 100 ], ]
    },
    'DOS Shell' => {
      sound => 1,
      cfg   => [ undef, [ 'Color' => 4 ], [ 'Speed' => 100 ], ]
    },
    'Draw Morph' => { cfg => [ [ 'Morph' => 8 ], [ 'Speed' => 100 ], ] },
    'Fish Pro'   => {
      # extra cfg hack
      sound => 1,
      cfg   => [
        [ 'Fish' => 100 ],
        undef,
        undef,    # Fish Types
        [ 'Show Sea Floor' => 1 ],
      ]
    },
    'Flying Toasters Pro' => {
      sound => 1,
      cfg   => [
        [ 'Objects'   => 100 ],
        [ 'Song Type' => 1 ],
        [ 'Music'     => undef ],    # always 100%
        [ 'Karaoke'   => 1 ],
      ]
    },
    'Flying Toilets' => {
      sound => 1,
      cfg   => [
        [ 'Crowd'       => 100 ],
        [ 'Paper'       => 3 ],
        [ 'Occupant'    => 4 ],
        [ 'Rude Sounds' => 1 ],
      ]
    },
    'Frost and Fire' => {
      cfg =>
        [ [ 'Size' => 100 ], [ 'Palette' => 9 ], [ 'Maximize Speed' => 1 ], ]
    },
    'Guts' => { cfg => [ [ 'Shapes' => 4 ], [ 'Speed' => 100 ], ] },
#    'Logo' => {
#      # extra cfg hack
#      cfg => [
#        [ 'Speed' => 100 ],
#      ]
#    },
#    'Messages' => {
#      cfg => [
#        [ 'Move'  => 2 ],
#        [ 'Speed' => 100 ],
#
#        # TODO: message
#      ]
#    },
    'Nirvana' => {
      cfg => [
        [ 'Color'        => 8 ],
        [ 'Redraw Every' => 100 ],
        [ 'Activity'     => 100 ],
        [ 'Change Color' => 100 ],
      ]
    },
    'Nonsense' => {
      cfg => [
        [ 'How Many'           => 100 ],
        [ 'Delay'              => 100 ],
        [ 'Colored Background' => 1 ],
      ]
    },
    'Photon' => {
      cfg => [
        [ 'Length'          => 100 ],
        [ 'Burst Delay'     => 100 ],
        [ 'Always Centered' => 1 ],
        [ 'Burst'           => 4 ],
      ]
    },
#    'Puzzle' => {
#      sound => 1,
#      cfg =>
#        [ [ 'Size' => 2 ], [ 'Speed' => 2 ], undef, [ 'Invert Screen' => 1 ], ]
#    },
    'Rat Race' => {
      sound => 1,
      cfg   => [
        [ 'Training'   => 100 ],
        [ 'Race Track' => 1 ],
        [ 'Music'      => undef ],    # always 100%
      ]
    },
    'Ray' => {
      # extra cfg hack
      cfg => [
        [ 'Objects'  => 100 ],
        [ 'Shadows'  => 2 ],
        [ 'Backdrop' => 2 ],
	# undef - shapes
      ]
    },
    'Rebound' => {
      sound => 1,
      cfg   => [
        [ 'Ball Type'          => 2 ],
        [ 'Wobbly'             => 1 ],
        [ 'Clear Screen First' => 1 ],
        [ 'Balls'              => 100 ],
      ]
    },
#    'Rose' => {
#      cfg =>
#        [ [ 'Speed' => 100 ], [ 'Trail Length' => 100 ], [ 'Big Dots' => 1 ], ]
#    },
#    'Satori' => {
#      cfg => [
#        [ 'Display'     => 6 ],
#        [ 'Colors'      => 13 ],
#        [ 'End Clarity' => 100 ],
#        [ 'Knots'       => 100 ],
#      ]
#    },
#    'SlideShow' => {
#      # extra cfg hack
#      cfg => [
#        undef,
#        undef,
#        [ 'FX'    => 9 ],
#        [ 'Delay' => 100 ],
#      ]
#    },
#    'Spheres' => {
#      cfg => [
#        [ 'Max Size'           => 100 ],
#        [ 'Offset'             => 100 ],
#        [ 'Clear Every'        => 100 ],
#        [ 'Clear Screen First' => 1 ],
#      ]
#    },
#    'Spotlight' =>
#      { cfg => [ [ 'Size' => 100 ], [ 'Speed' => 100 ], [ 'Spots' => 100 ], ] },
#    'Warp!' => {
#      cfg => [
#        [ 'Speed' => 100 ],
#        [ 'Stars' => 100 ],
#        [ 'Size'  => 2 ],
#        [ 'Color' => 1 ],
#      ]
#    },
    'You Bet Your Head' => {
      sound => 1,
      cfg   => [
        [ 'Contestants'  => 100 ],
        [ 'Timer'        => 100 ],
        [ 'Music'        => 100 ],
        [ 'Show Answers' => 1 ],
      ]
    },
    'Zooommm!' => {
      cfg => [ [ 'Colors' => 20 ], [ 'Speed' => 100 ], [ 'Delay' => 100 ], ]
    },
  },
  'MULTI' => {

    # multimodules
    'Apocalypse'   => undef,
    'Clock Attack' => undef,
    'Kiss the Sky' => undef,
    'Make Sense'   => undef,
    'Mind Warp'    => undef,
  }
);
##############################################################################

sub _pick { return $_[ rand @_ ] }

# helper: iterate through a dir and find files matching ext
sub _dir_parse
{
  my $path = shift;
  my $ext = shift;

  my @matches;

  opendir( my $dh, $path ) or die "Couldn't open $path: $!";
  while (my $file = readdir($dh)) {
    if ( $file =~ m/^.+\.\Q$ext\E$/i ) {
      push @matches, $file;
    }
  }
  closedir($dh);

  return @matches;
}

# helper: safe read
sub _rd {
  my $bytes_read = read $_[0], my $buffer, $_[1];
  die "Short read on file: expected $_[1] but got $bytes_read: $!"
    unless $bytes_read == $_[1];
  return $buffer;
}

sub _rd_str {
  my $len = unpack 'C', _rd( $_[0], 1 );
  return unpack( "Z$len", _rd( $_[0], $len ) );
}

# Info routine: return basic details about this module
sub info {
  my $weight;
  foreach my $dir ( keys %controls ) {
    $weight += scalar keys %{ $controls{$dir} };
  }

  return (
    name     => 'ADARK32',
    fullname => 'After Dark 3.2',
    author   => 'Berkeley Systems',
    payload  => ['ADARK32.zip'],
    files    => {
      'WINDOWS/SYSTEM.INI'    => \&edit_systemini,
      'WINDOWS/WIN.INI'       => \&edit_winini,
      'AFTERDRK/AFTERDRK.INI' => \&edit_afterdrkini,
      'AFTERDRK/MODULES.INI'  => \&edit_modulesini,

      #'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
    },
    files_custom => {
      'AFTERDRK/ADMODULE.AS3' => \&extra_admodule,

      #'WINDOWS/AD_MESG.ADS' => \&extra_messages,
    },
    weight => $weight,
  );
}

sub new {
  my $class    = shift;
  my $basepath = shift;

  # parse all AD module names
  my %modules;

  open( my $fpi, '<:raw', "$basepath/AFTERDRK/ADMODULE.AS3" )
    or die "Couldn't open admodule.as3: $!";

  # as3 header
  my $mod_count = unpack 'x[2]vx[4]', _rd( $fpi, 8 );
  my $len       = unpack 'v',         _rd( $fpi, 2 );
  my $title     = unpack "Z$len",     _rd( $fpi, $len );

  until ( eof $fpi ) {
    my $realname = _rd_str($fpi);
    my $path     = _rd_str($fpi);
    my $unknown  = _rd( $fpi, 33 );

    # split filename into dir / name
    my ( $dirname, $filename ) = split /\\/, $path;
    if ( exists $controls{$dirname}{$realname} ) {
      $modules{$realname} = $dirname;

      #$modules{$realname}{filename} = $filename;
    } else {
      print "Skipping unknown module $dirname:$realname\n";
    }

    if ( !eof $fpi ) {
      _rd( $fpi, 2 );
    }
  }

  # Pick da winna
  my $module = _pick( keys %modules );
  my $dir    = $modules{$module};

  # Configuration only happens for non-MultiModule entries
  my $cfg     = '';
  my $cfg_str = '';
  my $cfg_extra;
  my $sound;

  if ( !$controls{$dir}{$module} ) {
    $sound   = 1;
    $cfg_str = " (MultiModule, no settings)";
    $cfg     = pack( 'v[4]', 0, 0, 0, 0 );
  } else {
    if ( $controls{$dir}{$module}{sound} ) {
      $sound = 1;
    }

    # Set config options
    for ( my $i = 0; $i < 4; $i++ ) {
      my $value;
      my $knob = $controls{$dir}{$module}{cfg}[$i];
      if ( defined $knob ) {
        if ( $knob->[0] eq 'Music' ) {

          # always play music
          $value = 100;
        } else {
          $value = int( rand( $knob->[1] + 1 ) );
          $cfg_str .= ", $knob->[0]: $value" . ( $knob->[1] == 100 ? '%' : '' );
        }
      } else {
        $value = 0;
      }
      $cfg .= pack( 'v', $value );
    }

    # extra cfg hacks for certain modules
    if ( $module eq 'Bugs' ) {
      my $bugs = int( rand(63) ) + 1;
      $cfg_str .= ", Bug Types: $bugs";
      $cfg_extra = "[Bugs]\nBugTypes=$bugs\n";
    } elsif ( $module eq 'Fish Pro' ) {
      my $fish = int( rand(1024) ) + 1024;
      $cfg_str .= ", Fish Types: $fish";
      $cfg_extra = "[Fish]\nFishTypes=$fish\n";
    } elsif ( $module eq 'Artist' ) {
      my @bmps = _dir_parse($basepath . '/AFTERDRK/BITMAPS', 'BMP' );

      my $bmp = _pick(@bmps);
      $cfg_str .= ", Bitmap: $bmp";
      $cfg_extra = "[The Artist]\nImage=C:\\AFTERDRK\\BITMAPS\\$bmp\n";
    } elsif ( $module eq 'Logo' ) {
      my @bmps = _dir_parse($basepath . '/AFTERDRK/BITMAPS', 'BMP' );

      my $bmp = _pick(@bmps);
      $cfg_str .= ", Bitmap: $bmp";
      $cfg_extra = "[Logo Section]\nLogoFile=C:\\AFTERDRK\\BITMAPS\\$bmp\n";
    } elsif ( $module eq 'Ray' ) {
      my @trcs = _dir_parse($basepath . '/AFTERDRK/TRACES', 'TRC' );

      my $trc = _pick(@trcs);
      $cfg_str .= ", Shape: $trc";
      $cfg_extra = "[Ray]\nRaySceneFile=C:\\AFTERDRK\\TRACES\\$trc\n";
    } elsif ( $module eq 'SlideShow' ) {
      $cfg_extra = "[Slide Show]\nCatalogName=BITMAPS\n";
    }
  }

  my $self = {
    module         => $module,
    folder         => $dir,
    settings       => $cfg_str,
    settings_bin   => $cfg,
    settings_extra => $cfg_extra,
    sound          => $sound,
    dosbox         => {
      start  => 68000,
      #cycles => 5000,
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

  # AD3.0 uses a Driver addition and an entry in 386enh
  if ( defined $line ) {
    if ( $line =~ m/^drivers=(.*)$/i ) {
      $line = "drivers=$1 c:\\afterdrk\\adwrap.drv";
    } elsif ( $line =~ m/^\[386Enh\]$/i ) {
      $line .= "\ndevice=c:\\afterdrk\\adw30.386";
    } elsif ( $line =~ m/^\[drivers\]$/i ) {
      $line .= "\nadwrap=c:\\afterdrk\\adwrap.drv";
    }
  }

  return $line;
}

sub edit_winini {
  my ( $self, $line ) = @_;

  if ( defined $line ) {
    if ( $line =~ m/^load=(.*)$/ ) {
      $line = "load=c:\\afterdrk\\adw30.exe $1";
    }
  } else {
    $line = <<'EOF';
[Berkeley Systems]
After Dark=C:\AFTERDRK
AD INI Files=C:\afterdrk
AD Data Files=C:\afterdrk

[Sound Palette]
Test=chimes.wav
Sound Output=PCSPEAKER
PC Volume=90
EOF
  }

  return $line;
}

sub edit_afterdrkini {
  my ( $self, $line ) = @_;

  # some junk to add to After Dark ini file
  #  Module selection is done via two keys
  if ( $line && $line =~ m/^\[After Dark\]$/i ) {
    $line
      .= "\nCurrentFolder=$self->{folder}\n$self->{folder}=\"$self->{module}\"\n";
  }

  return $line;
}

sub edit_modulesini {
  my ( $self, $line ) = @_;

  # MODULES.INI contains extra things (filepaths etc)
  #  which do not fit the usual config format
  if ( !defined $line && $self->{settings_extra} ) {
    $line = $self->{settings_extra};
  }

  return $line;
}

sub extra_admodule {
  my ( $self, $input, $output ) = @_;

  # ADMODULE.ADS to make settings changes for our picks
  open( my $fpi, '<:raw', $input )  or die "Couldn't open $input: $!";
  open( my $fpo, '>:raw', $output ) or die "Can't open $output file: $!";

  # as3 header
  print $fpo _rd( $fpi, 8 );
  my $len = _rd( $fpi, 2 );
  print $fpo $len;
  print $fpo _rd( $fpi, unpack( 'v', $len ) );

  # as3 module info
  until ( eof $fpi ) {

    # get Real Name
    $len = _rd( $fpi, 1 );
    my $name_len = unpack('C', $len);
    my $realname = _rd( $fpi, $name_len );
    print $fpo $len;
    print $fpo $realname;

    # FOR COMPARISON LATER
    my $module = unpack "Z$name_len", $realname;

    # filepath
    $len = _rd( $fpi, 1 );
    print $fpo $len;
    print $fpo _rd( $fpi, unpack( 'C', $len ) );

    # copy 4 unknown bytes
    print $fpo _rd( $fpi, 4 );

    # read a volume, write full blast instead
    _rd( $fpi, 2 );
    print $fpo pack( 'v', 100 );

    # copy 16 bytes
    print $fpo _rd( $fpi, 16 );

    # APPLY CONFIG
    if ( $module eq $self->{module} ) {
      _rd( $fpi, 8 );
      print $fpo $self->{settings_bin};
    } else {

      # COPY CONFIG
      print $fpo _rd( $fpi, 8 );
    }

    # copy 3 remaining unknowns
    print $fpo _rd( $fpi, 3 );

    # copy delimiter too
    if ( !eof $fpi ) {
      print $fpo _rd( $fpi, 2 );
    }
  }
}

sub extra_messages {
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
