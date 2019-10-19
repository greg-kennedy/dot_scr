package Unit::AD20MORE;
use strict;
use warnings;

use Unit::Common::AfterDark20;

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
    fullname => 'More After Dark (2.0)',
    author   => 'Berkeley Systems',
    payload  => [ 'ADARK20.zip', 'AD20MORE.zip' ],
    files    => {
      'WINDOWS/SYSTEM.INI'   => \&Unit::Common::AfterDark20::edit_systemini,
      'WINDOWS/WIN.INI'      => \&Unit::Common::AfterDark20::edit_winini,
      'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
    },
    files_custom => {
      'WINDOWS/ADMODULE.ADS' => \&extra_admodule,

      #'WINDOWS/SAYING.ADS'   => \&extra_sayings,
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
    if ( $line =~ m/^Module=/i ) {
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

# TODO - SAYING.DAT file
#sub extra_sayings {}

1;
