package Unit::ORIGINSS;
use strict;
use warnings;

##############################################################################
# Slide Show portion of OriginFX.

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'ORIGINSS',
        fullname => 'Origin FX',
        author   => 'Origin Systems',
        payload  => ['ORIGINFX.zip'],
        files    => {
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/ORIGINFX.INI' => \&edit_originfxini,
        },
        dosbox => {
            start => 63000,
        },
        weight => 1
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    return bless( {}, $class );
}

sub detail {
    my $self = shift;

    return "Slide Show";
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^load=(.*)$/i ) {
        $line = "load=c:\\originfx\\originfx.exe $1";
    }

    return $line;
}

sub edit_originfxini {
    my ( $self, $line ) = @_;

    if ($line) {
        if ( $line =~ m/^DisplayMode=/i ) {
            $line = "DisplayMode=1";
        }
    }

    return $line;
}

1;
