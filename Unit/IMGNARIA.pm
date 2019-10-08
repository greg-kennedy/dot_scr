package Unit::IMGNARIA;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Imaginaria

# The only version I can find is the German...
my %modules = (
    'Die Firma' => 'The Associates',
    'Noten-Chaos' => 'ATM Gone Mad',
    'Speicherspuk' => 'Attic Antics',
    'Chemie' => 'Chem Lab',
    'Korallen' => 'Coral Reef',
    'Dinosauria' => 'Dinosauria',
    'Galaxy Tour' => 'Galaxy Tour',
    'Am  Leuchtturm' => 'Lighthouse (?)',
    'Hafenszene' => 'Monterey Bay',
    'Mondscheinsonate' => 'Moonlight Sonata',
    'Regenwald' => 'Rainforest (?)',
    'Omars  Detektei' => 'Swamio Investments',
    'Terrarium' => 'Terrarium',
    'Spielkameraden' => 'Young Associates',
    'Yosemite' => 'Yosemite',
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'IMGNARIA',
        fullname => 'Imaginaria',
        author   => 'Socha Computing',
        payload  => ['IMGNARIA.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'  => \&edit_winini,
            'IMGNARIA/IMGNARIA.INI'     => \&edit_imgnaria,
        },

        weight => scalar keys %modules,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    my $self = {
        module => _pick(keys %modules),
        sound => 1,
        dosbox => {
            start => 8000,

            #            cycles => 0
        },
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "Module: " . $modules{$self->{module}};
}

##############################################################################

sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\IMGNARIA.SCR";
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
      if ( $line =~ m/^load=(.*)$/i) {
        $line = "load=C:\\IMGNARIA\\imgnaria.exe $1";
      } elsif ( $line =~ m/^ScreenSaveActive=/i ) {
        $line = "ScreenSaveActive=1";
      }
    } else {
        $line="[Imaginaria]\nPath=C:\\IMGNARIA\n";
    }

    return $line;
}

sub edit_imgnaria {
    my ( $self, $line ) = @_;

    # Unfortunately there is more than one "Modul=" key in this file
    #  so we have to track if [Schoner] block came first
    if ($line) {
        if ( $line =~ m/^\[Schoner\]$/i ) {
            $self->{schoner} = 1;
        } elsif ( $self->{schoner} && $line =~ m/^Modul=/i ) {
            $line = "Modul=" . $self->{module};
        } else {
            delete $self->{schoner};
        }
    }

    return $line;
}

1;

