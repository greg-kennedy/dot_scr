package Unit::ADSTTREK;
use strict;
use warnings;

use Unit::Common::AfterDark20;

##############################################################################
# giant module settings meanings
my %controls = (
  ' Brain Cells' => {
    sound => 1,
    cfg   => [
      [ 'Max # Cells'        => 100 ],
      [ 'Clear Every'        => 100 ],
      [ 'Clear Screen First' => 1 ],
    ]
  },
  ' Communications' => {
    sound => 1,
    cfg   => [ undef, [ 'Style' => 6 ], [ 'Message' => 9 ], ]
  },
  ' Final Exam' => {
    sound => 1,
    cfg => [ [ 'Timer' => 100 ], [ 'Show Answer' => 1 ], [ 'Text Only' => 1 ], ]
  },
  ' Final Frontier' => {
    sound => 1,
    cfg   => [ [ 'Show Title' => 1 ], [ 'Spin Planets' => 1 ], ]
  },
  ' Horta' => {
    sound => 1,
    cfg   => [
      [ '# Horta'            => 100 ],
      [ '# Red Shirts'       => 100 ],
      [ 'Fertility'          => 100 ],
      [ 'Clear Screen First' => 1 ],
    ]
  },

  # no sound in Ion Storm...
  ' Ion Storm' => {
    cfg => [
      [ 'Color'        => 5 ],
      [ 'Color Speed'  => 100 ],
      [ 'Trail Length' => 100 ],
      [ 'Big Dots'     => 1 ],
    ]
  },
  ' PlanetaryAtlas' => {
    sound => 1,
    cfg   => [ [ 'Pause' => 100 ], [ 'Planet Only' => 1 ], [ 'Stars' => 1 ], ]
  },
  " Scotty's Files" => {
    sound => 1,
    cfg   => [ [ 'Pause' => 100 ], ]
  },
  ' Ship Panels' => {
    sound => 1,
    cfg   => [ [ 'Display' => 8 ], [ 'Redraw Every' => 100 ], ]
  },
  ' Sickbay' => {
    sound => 1,
    cfg   => [ [ "McCoy's Quotes" => 1 ], [ 'Diagnostic Text' => 1 ], ]
  },
  ' Space' => {
    sound => 1,
    cfg   => [
      [ 'Redraw Every' => 100 ],
      [ '# Ships'      => 100 ],
      [ '# Nebulae'    => 100 ],
    ]
  },
  ' Spock' => {
    sound => 1,
    cfg   => [ [ 'Clear Screen First' => 1 ], ]
  },
  ' The Mission' => { sound => 1, cfg => [] },
  ' Tholian Web' => {
    sound => 1,
    cfg   => [ [ 'Ship Speed' => 100 ], [ 'Clear Screen First' => 1 ], ]
  },
  ' Tribbles' => {
    sound => 1,
    cfg   => [
      [ 'Reproduce'          => 100 ],
      [ 'Klingon'            => 100 ],
      [ 'Clear Screen First' => 1 ],
    ]
  },

  #'MultiModule'    => undef,
  #'Randomizer' => { sound => 1, cfg => [
  #    [ 'Order'      => 1 ],
  #    [ 'Duration' => 100 ],
  #] },
  #'Sounder' => {
  #    sound => 1,
  #    cfg => [
  #        [ 'Order' => 2],
  #        [ 'Delay' => 100 ],
  #        undef,
  #        [ 'Blank Screen' => 1 ],
  #    ]
  #},
  #'Starry Night' => { sound => 1, cfg => [
  #    [ 'Buildings'       => 100 ],
  #    [ 'Building Height' => 100 ],
  #        undef,
  #    [ 'Lightning' => 100 ],
  #] },
);
##############################################################################

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
  return (
    name     => 'ADSTTREK',
    fullname => 'After Dark: Star Trek: The Screensaver (2.0)',
    author   => 'Berkeley Systems',
    payload  => [ 'ADARK20.zip', 'ADSTTREK.zip' ],
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
  if ( defined $line ) {
    if ( $line =~ m/^Module=/i ) {
      $line = "Module=\"$self->{module}\"";
    } elsif ( $line =~ m/^ModuleFile=/i ) {
      $line = "ModuleFile=$self->{module_file}";
    }
  } else {

    # Custom message for "Communications" module
    #  Use \\n to put a newline in the message.
    $line = "[Communications]\nMessageText=Mr. Scott:\\nTwo to beam up.\n";
  }

  return $line;
}

sub extra_admodule {
  my ( $self, $input, $output ) = @_;

  Unit::Common::AfterDark20::set_admodule_ads( $input, $output,
    $self->{module}, $self->{settings} );
}

1;
