package Unit::ADARK20;
use strict;
use warnings;

use Unit::Common::AfterDark20;

##############################################################################
# giant module settings meanings
my %controls = (
  'Aquatic Realm' => {
    sound => 1,
    cfg   => [
      [ 'Creatures'      => 100 ],
      [ 'Seaweed'        => 100 ],
      [ 'Show Sea Floor' => 1 ],
    ]
  },
  'Can of Worms' => {
    sound => 1,
    cfg   => [ [ 'Wiggle' => 100 ], [ 'Segments' => 100 ], [ 'Worms' => 100 ], ]
  },
  'Clocks' => {
    sound => 1,
    cfg   => [
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
    cfg   => [ [ 'Flying Things' => 100 ], [ 'Toast' => 100 ], ]
  },
  'GeoBounce' => {
    sound => 1,
    cfg   => [
      [ 'Shape' => 4 ],
      [ 'Size'  => 100 ],
      [ 'Speed' => 100 ],
      [ 'Faces' => 2 ],
    ]
  },
  'Globe'     => { cfg => [ [ 'Rotation' => 100 ], [ 'Speed' => 100 ], ] },
  'GraphStat' => { cfg => [ [ 'Delay'    => 100 ] ] },
  'Gravity'   => {
    sound => 1,
    cfg   => [
      [ 'Number Balls' => 100 ], [ 'Size' => 100 ], [ 'Clear Screen' => 1 ],
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
    cfg   => [
      [ 'Redraw Every' => 100 ], [ 'Pin Size' => 100 ], [ '# Pins' => 100 ],
    ]
  },
  'Messages' => { cfg => [ [ 'Move' => 2 ], [ 'Speed' => 100 ], ] },
  'Mondrian' =>
    { cfg => [ [ 'Speed' => 100 ], [ 'Clear Screen First' => 1 ], ] },
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
    cfg   => [ undef, undef, [ 'Color' => 1 ], [ 'Density' => 100 ], ]
  },
  'Penrose'   => { cfg => [ [ 'Tile' => 5 ], [ 'Delay' => 100 ], ] },
  'Punch Out' => {
    sound => 1,
    cfg   => [ [ 'Shape' => 4 ], [ 'Size' => 100 ], [ 'Speed' => 100 ], ]
  },
  'Puzzle' => {
    sound => 1,
    cfg =>
      [ [ 'Size' => 2 ], [ 'Speed' => 2 ], undef, [ 'Invert Screen' => 1 ], ]
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
    cfg =>
      [ [ 'Speed' => 100 ], [ 'Trail Length' => 100 ], [ 'Big Dots' => 1 ], ]
  },
  'Satori' => {
    cfg => [
      [ 'Display'     => 6 ],
      [ 'Colors'      => 13 ],
      [ 'End Clarity' => 100 ],
      [ 'Knots'       => 100 ],
    ]
  },
  'Shapes' => { cfg => [ [ 'Clear Screen First' => 1 ], [ 'Color' => 1 ], ] },

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
  'Spotlight'     => { cfg => [ [ 'Size' => 100 ], [ 'Speed' => 100 ], ] },
  'Stained Glass' => {
    cfg => [
      [ 'Complexity' => 100 ], [ 'Duplication' => 100 ], [ 'Color' => 100 ],
    ]
  },
  'Starry Night' => {
    sound => 1,
    cfg   => [
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
    cfg =>
      [ [ 'Speed' => 100 ], [ 'Num Swans' => 100 ], [ 'Synchronized', 1 ], ]
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
  'Zot!' =>
    { cfg => [ [ 'Forkiness' => 100 ], undef, [ 'How Often' => 100 ], ] },

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
    fullname => 'After Dark 2.0',
    author   => 'Berkeley Systems',
    payload  => [ 'ADARK20.zip', 'AD20BASE.zip' ],
    files    => {
      'WINDOWS/SYSTEM.INI'   => \&Unit::Common::AfterDark20::edit_systemini,
      'WINDOWS/WIN.INI'      => \&Unit::Common::AfterDark20::edit_winini,
      'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
    },
    files_custom => {
      'WINDOWS/ADMODULE.ADS' => \&extra_admodule,
      'WINDOWS/AD_MESG.ADS'  => \&extra_messages,
    },
    weight => scalar keys %controls,
  );
}

sub new {
  my $class    = shift;
  my $basepath = shift;

  # parse all AD module names
  my %modules
    = Unit::Common::AfterDark20::get_module_names(
    "$basepath/WINDOWS/ADMODULE.ADS",
    keys %controls );

  # Pick da winna
  my $module = _pick( keys %modules );

  # do configuration
  my ( $settings, $description, $sound )
    = Unit::Common::AfterDark20::configure( $controls{$module} );

  my $self = {
    module      => $module,
    module_file => $modules{$module},
    description => $description,
    settings    => $settings,
    sound       => $sound,
    dosbox      => \%Unit::Common::AfterDark20::dosbox
  };

  return bless( $self, $class );
}

sub detail {
  my $self = shift;

  return "Module: $self->{module}" . $self->{description};
}

sub edit_adprefsini {
  my ( $self, $line ) = @_;

  # AD_PREFS.INI to set up the desired module
  if ($line) {
    if ( $line =~ m/^\[After Dark\]$/i ) {

      # append extra info after the After Dark header
      $line .= "\nGlobeFile=C:\\AFTERDRK\\BITMAPS\\earth.bmp";
      $line .= "\nLogoFile=C:\\AFTERDRK\\BITMAPS\\adlogo.bmp";
    } elsif ( $line =~ m/^Module=/i ) {
      $line = "Module=\"$self->{module}\"";
    } elsif ( $line =~ m/^ModuleFile=/i ) {
      $line = "ModuleFile=$self->{module_file}";
    }
  }

  return $line;
}

sub extra_admodule {
  my ( $self, $input, $output ) = @_;

  Unit::Common::AfterDark20::set_admodule_ads( $input, $output,
    $self->{module}, $self->{settings} );
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
