package Unit::LEAKROOF;
use strict;
use warnings;

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'LEAKROOF',
        fullname => 'Leaking Roof',
        author   => 'Strange Software',
        payload  => ['STRANGE.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&append_controlini,
        },
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    my $self = {
        strength => int(rand 15) + 1,
        dosbox => {
            start => 8000,
        },
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "Maximum Droplets: " . $self->{strength};
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\LEAK.SCR";
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

sub append_controlini {
    my ( $self, $line ) = @_;

    if ( !defined $line ) {
        $line = <<"EOF";
[ScreenSaver.Leaking roof]
Strength=$self->{strength}
EOF
    }

    return $line;
}

1;
