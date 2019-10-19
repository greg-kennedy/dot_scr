package Unit::ADDISNEY;
use strict;
use warnings;

use Unit::Common::AfterDark20;

##############################################################################
# giant module settings meanings
my %controls = (
  '  101Dalmatians' => {
    sound => 1,
    cfg   => [
      [ 'Number of Dogs'     => 100 ],
      [ 'Bark Frequency'     => 100 ],
      [ 'Clear'              => 100 ],
      [ 'Clear Screen First' => 1 ],
    ]
  },
  '  Beauty' => {
    sound => 1,
    cfg   => [
      [ 'Delay'           => 100 ],
      [ 'Shuffle Windows' => 1 ],
      [ 'Mode'            => 1 ],
      [ 'Music'           => 100 ],
    ]
  },
  '  Captain Hook' => {
    sound => 1,
    cfg   => [ [ 'Clear Screen First' => 1 ], [ 'Music' => 100 ], ]
  },
  '  Cheshire Cat' => {
    sound => 1,
    cfg   => [
      [ 'Shyness'            => 100 ],
      [ 'Haste'              => 100 ],
      [ 'Indecision'         => 100 ],
      [ 'Clear Screen First' => 1 ],
    ]
  },
  '  Digital Ink'  => { sound => 1, cfg => [] },
  '  DisneyClocks' => {
    sound => 1,
    cfg   => [
      [ 'Clock'              => 6 ],
      [ 'Sounds'             => 3 ],
      [ 'Drift Interval'     => 100 ],
      [ 'Clear Screen First' => 1 ],
    ]
  },
  '  Donald Paints' => {
    sound => 1,
    cfg   => [
      [ 'Neatness'           => 100 ],
      [ 'Color'              => 3 ],
      [ 'Style'              => 5 ],
      [ 'Clear Screen First' => 1 ],
    ]
  },
  '  FallingFlower' => {
    sound => 1,
    cfg   => [ [ 'Flowers' => 100 ], [ 'Music' => 100 ], ]
  },
  '  Goofy'   => { sound => 1, cfg => [] },
  '  Haunted' => {
    sound => 1,
    cfg   => [ [ 'Screamishness' => 100 ], ]
  },
  '  Jungle Book' => {
    sound => 1,
    cfg   => [ [ 'Thunder' => 100 ], ]
  },
  '  LittleMermaid' => {
    sound => 1,
    cfg   => [
      [ 'Creatures' => 100 ],
      [ 'Visitors'  => 100 ],
      [ 'Music'     => 100 ],
      [ 'Sea'       => 2 ],
    ]
  },
  '  MagicKingdom' => {
    sound => 1,
    cfg =>
      [ [ 'Castle' => 2 ], [ '# of Fireworks' => 100 ], [ 'Delay' => 100 ], ]
  },
  '  Pinocchio' => {
    sound => 1,
    cfg   => [ [ 'Figaro' => 100 ], ]
  },
  '  Scrooge' => {
    sound => 1,
    cfg   => [ [ 'Money' => 100 ], [ 'Type' => 2 ], ]
  },
  '  The Sorcerer' => {
    sound => 1,
    cfg   => [ [ 'Brooms' => 100 ], [ 'Music' => 100 ], ]
  },

  #'Randomizer' => { sound => 1, cfg => [
  #    [ 'Order'      => 1 ],
  #    [ 'Duration' => 100 ],
  #],
  #'Starry Night' => { sound => 1, cfg => [
  #    [ 'Buildings'       => 100 ],
  #    [ 'Building Height' => 100 ],
  #        undef,
  #    [ 'Lightning' => 100 ],
  #],
);
##############################################################################

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
  return (
    name     => 'ADDISNEY',
    fullname => 'After Dark: Disney Collection (2.0)',
    author   => 'Berkeley Systems',
    payload  => [ 'ADARK20.zip', 'ADDISNEY.zip' ],
    files    => {
      'WINDOWS/SYSTEM.INI'   => \&Unit::Common::AfterDark20::edit_systemini,
      'WINDOWS/WIN.INI'      => \&Unit::Common::AfterDark20::edit_winini,
      'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
    },
    files_custom => { 'WINDOWS/ADMODULE.ADS' => \&extra_admodule, },
    weight       => scalar keys %controls,
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

1;
