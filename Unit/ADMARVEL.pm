package Unit::ADMARVEL;
use strict;
use warnings;

use Unit::Common::AfterDark20;

##############################################################################
# ADMARVEL is an After Dark module, but it only does a slideshow, and
#  the config is stuff that would be not fun to change.

my %controls = ( 'Marvel Comics' =>
    { cfg => [ undef, undef, [ 'FX' => 9 ], [ 'Delay' => 100 ], ] } );

# Info routine: return basic details about this module
sub info {
  return (
    name     => 'ADMARVEL',
    fullname => 'After Dark: Marvel Comics Screen Posters (2.0)',
    author   => 'Berkeley Systems',
    payload  => [ 'ADARK20.zip', 'ADMARVEL.zip' ],
    files    => {
      'WINDOWS/SYSTEM.INI'   => \&Unit::Common::AfterDark20::edit_systemini,
      'WINDOWS/WIN.INI'      => \&Unit::Common::AfterDark20::edit_winini,
      'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
    },
    files_custom => { 'WINDOWS/ADMODULE.ADS' => \&extra_admodule, },
    weight       => 1,
  );
}

sub new {
  my $class    = shift;
  my $basepath = shift;

# parse all AD module names, this is mainly a formality because there should be only one
  my %modules
    = Unit::Common::AfterDark20::get_module_names(
    "$basepath/WINDOWS/ADMODULE.ADS",
    keys %controls );

  # Pick da winna
  #my $module = _pick( keys %modules );
  my $module = ( keys %modules )[0];

  # Don't do random configuration, just force some good values.
  my $settings = pack( 'v[5]', 0, 0, 9, 0, 5 );

  my $self = {
    module      => $module,
    module_file => $modules{$module},
    settings    => $settings,
    dosbox      => \%Unit::Common::AfterDark20::dosbox
  };

  return bless( $self, $class );
}

sub detail {
  my $self = shift;

  return "(none)";
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
