package Unit::MSSATURN;
use strict;
use warnings;

# https://winworldpc.com/product/microsoft-saturn-screensaver/1

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'MSSATURN',
        fullname => 'Saturn',
        author   => 'Microsoft / HyperDyne 2000 Software',
        payload  => ['MICROSOFT.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
        },
        dosbox => {
            start => 8000,
        },
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    my $self = {};

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "(none)";
}

##############################################################################
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SATURN.SCR";
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^ScreenSaveActive=/i ) {
        $line = "ScreenSaveActive=1";
    }

    return $line;
}

1;
