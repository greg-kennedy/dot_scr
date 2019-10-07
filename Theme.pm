package Theme;

# Special "theme" class that randomizes wallpaper and stuff

use strict;
use warnings;

use File::Spec;

# Helper
sub _pick { return $_[ rand @_ ] }
sub _trim { my $s = shift; $s =~ s/^\s+//; $s =~ s/\s+$//; return $s }

# Info routine: return basic details about this module
sub info {
  return (
    name  => 'Theme',
    files => {
      'WINDOWS/WIN.INI'     => \&edit_winini,
      'WINDOWS/CONTROL.INI' => \&edit_controlini,
    },
  );
}

sub new {
  my $class = shift;

  my $basepath = shift;

  # get list of possible BMP files from windows folder
  my @bmps;

  my $bmp_path = File::Spec->catdir( $basepath, 'WINDOWS' );
  if ( opendir( my $dh, $bmp_path ) ) {
    foreach my $file ( readdir($dh) ) {
      if ( $file =~ m/^.+\.bmp$/i ) {
        push @bmps, $file;
      }
    }
  } else {
    die "Could not opendir $bmp_path: $!";
  }

  # get themes and names from control.ini
  my %themes = ( 'Windows Default' => undef );
  my %patterns;

  my $ini_path = File::Spec->catfile( $basepath, 'WINDOWS', 'CONTROL.INI' );
  if ( open( my $fp, '<', $ini_path ) ) {
    my $section = '';
    while ( my $line = <$fp> ) {
      $line = _trim($line);
      if ( $line =~ m/^\[([^\]]+)\]$/i ) {
        $section = uc($1);
      } elsif ( $section eq 'COLOR SCHEMES' ) {
        if ( $line =~ m/^([^=]+)\s*=\s*([0-9A-F,\s]+)$/i ) {
          my $name   = $1;
          my @colors = split /\s*,\s*/, $2;
          $themes{$name} = \@colors;

          #print "Theme $name\n"
        }
      } elsif ( $section eq 'PATTERNS' ) {
        if ( $line =~ m/^([^=]+)\s*=\s*([0-9\s]+)$/i ) {
          my $name    = $1;
          my $pattern = $2;
          $patterns{$name} = $pattern;

          #print "Pattern $name\n"
        }
      }
    }
  } else {
    die "Could not open $ini_path: $!";
  }

  # Pick today's winner
  #  50% chance of "None" which lets the pattern show instead
  # choose winning theme and pattern too
  my $bmp          = _pick( "(None)", _pick(@bmps) );
  my $theme_name   = _pick( keys %themes );
  my $pattern_name = _pick( keys %patterns );

  # construct final Theme object
  my $self = {
    wallpaper    => $bmp,
    pattern_name => $pattern_name,
    pattern      => $patterns{$pattern_name},
    theme_name   => $theme_name,
    theme        => $themes{$theme_name},
  };

  return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
  my $self = shift;

  return
    "Wallpaper $self->{wallpaper}, Pattern $self->{pattern_name}, Theme $self->{theme_name}";
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_controlini {
  my ( $self, $line ) = @_;

  if ( $line && $line =~ m/^Color Schemes=/i ) {
    $line = "Color Schemes=$self->{theme_name}";
  }

  return $line;
}

sub edit_winini {
  my ( $self, $line ) = @_;

  if ( defined($line) ) {
    if ( $line =~ m/^Wallpaper=/i ) {
      $line = "Wallpaper=$self->{wallpaper}";
    } elsif ( $line =~ m/^Pattern=/i ) {
      $line = "Pattern=$self->{pattern}";
    }
  } else {
    if ( defined $self->{theme} ) {
      my @objects = (
        'Background',     'AppWorkspace',
        'Window',         'WindowText',
        'Menu',           'MenuText',
        'ActiveTitle',    'InactiveTitle',
        'TitleText',      'ActiveBorder',
        'InactiveBorder', 'WindowFrame',
        'Scrollbar',      'ButtonFace',
        'ButtonShadow',   'ButtonText',
        'GrayText',       'Hilight',
        'HilightText',    'InactiveTitleText',
        'ButtonHilight',
      );

      $line = "[Colors]\n";

      for ( my $i = 0; $i < scalar @objects; $i++ ) {
        my $color = sprintf( '%06s', substr( $self->{theme}[$i], -6 ) );
        $line .= sprintf( "%s=%d %d %d\n",
          $objects[$i],
          hex( substr( $color, 4, 2 ) ),
          hex( substr( $color, 2, 2 ) ),
          hex( substr( $color, 0, 2 ) ) );
      }
    }
  }
  return $line;
}

1;
