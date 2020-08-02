package Unit::AD30TWST;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
  'TWISTED' => {
    'Bungee Roulette' => {
      cfg => [
        [ 'Jumper' => 5 ],
        [ 'Jumps' => 100 ],
        [ 'Equipment'  => 100 ],
      ]
    },
    'Chameleon' => {
      cfg => [
        [ 'Quantity' => 100 ],
        [ 'Zest' => 100 ],
        [ 'Vomiter'  => 100 ],
      ]
    },
    'ComingSoon!' => {
      cfg => [
        [ 'Pace' => 100 ],
        [ 'Show' => 1 ],
        undef,
        [ 'Music' => undef ],
      ]
    },
    'Flying Toilets' => {
      cfg   => [
        [ 'Crowd'       => 100 ],
        [ 'Paper'       => 3 ],
        [ 'Occupant'    => 4 ],
        [ 'Rude Sounds' => undef ],
      ]
    },
    'FrankenScreen' => {
      cfg   => [
        [ 'Coherence'   => 4 ],
        [ 'Blemishes'   => 100 ],
        [ 'Lifespan'    => 100 ],
        [ 'Music'       => undef ],
      ]
    },
    'Message Mayhem' => {
      # TODO: Custom message
      cfg   => [
        [ 'Duration'   => 100 ],
        [ 'Style'   => 3 ],
        [ 'Message'     => 11 ],
      ]
    },
    "Mike's So-called Life" => {
      cfg   => [
        [ 'Activity Level'   => 100 ],
      ]
    },
    'Mime Hunt' => {
      cfg   => [
        [ 'Mimes'     => 100 ],
        [ 'Weapon'    => 3 ],
        [ 'CyberMood' => 4 ],
        [ 'Music'     => undef ],
      ]
    },
    "Mowin' Boris" => {
      cfg   => [
        [ 'Mower Speed' => 100 ],
        [ 'Cats'    => 100 ],
        [ 'Revenge'   => 100 ],
        [ 'Mower Sound' => undef ],
      ]
    },
    'Phlegm Boy' => {
      cfg   => [
        [ 'Behavior' => 100 ],
        [ 'Mess'    => 100 ],
      ]
    },
    'Shock Clocks' => {
      cfg   => [
        [ 'Face' => 3 ],
        [ 'Drift Speed' => 100 ],
      ]
    },
    'Toxic Swamp' => {
      cfg   => [
        [ 'Critters' => 100 ],
        [ 'Lung Capacity' => 100 ],
        [ 'Fish Only' => 1 ],
      ]
    },
    'Voyeur' => { cfg => [] },
  },
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
    name     => 'AD30TWST',
    fullname => 'After Dark: Totally Twisted',
    author   => 'Berkeley Systems',
    payload  => ['AD30TWST.zip'],
    files    => {
      'WINDOWS/SYSTEM.INI'    => \&edit_systemini,
      'WINDOWS/WIN.INI'       => \&edit_winini,
      'AFTERDRK/AFTERDRK.INI' => \&edit_afterdrkini,
      'AFTERDRK/MODULES.INI'  => \&edit_modulesini,
    },
    files_custom => {
      'AFTERDRK/ADMODULE.AS3' => \&extra_admodule,
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

  if ( !$controls{$dir}{$module} ) {
    $cfg_str = " (MultiModule, no settings)";
    $cfg     = pack( 'v[4]', 0, 0, 0, 0 );
  } else {
    # Set config options
    for ( my $i = 0; $i < 4; $i++ ) {
      my $value;
      my $knob = $controls{$dir}{$module}{cfg}[$i];
      if ( defined $knob ) {
        if ( $knob->[0] eq 'Music' ) {

          # always play music
          $value = 100;
        } elsif ($knob->[0] eq 'Rude Sounds' || $knob->[0] eq 'Mower Sound') {
          # always play sound
          $value = 1;
        } else {
          $value = int( rand( $knob->[1] + 1 ) );
          $cfg_str .= ", $knob->[0]: $value" . ( $knob->[1] == 100 ? '%' : '' );
        }
      } else {
        $value = 0;
      }
      $cfg .= pack( 'v', $value );
    }
  }

  my $self = {
    module         => $module,
    folder         => $dir,
    settings       => $cfg_str,
    settings_bin   => $cfg,
    settings_extra => $cfg_extra,
    sound          => 1,
    sensitive      => 1,
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
}

sub edit_systemini {
  my ( $self, $line ) = @_;

  # AD3.0 uses a Driver addition and an entry in 386enh
  #  there is also a WaveMapper driver
  if ( defined $line ) {
    if ( $line =~ m/^drivers=(.*)$/i ) {
      $line = "drivers=$1 c:\\afterdrk\\adwrap.drv";
    } elsif ( $line =~ m/^\[386Enh\]$/i ) {
      $line .= "\ndevice=c:\\afterdrk\\adw30.386";
    } elsif ( $line =~ m/^\[drivers\]$/i ) {
      $line .= "\nadwrap=c:\\afterdrk\\adwrap.drv";
      $line .= "\nWaveMapper=msacm.drv";
      $line .= "\nMSACM.msadpcm=msadpcm.acm";
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

1;
