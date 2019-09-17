package Unit::SSFLYWIN;
use strict;
use warnings;

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'SSFLYWIN',
        fullname => 'Flying Windows',
        author   => 'Microsoft',
        payload  => ['MICROSOFT.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&append_controlini,
        },
        dosbox => {
            start => 8000,

            #            cycles => 0
        },

        #        weight => 1,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    my $self = {
        density => int( rand(191) ) + 10,
        speed   => int( rand(11) ),

        #        sound => 0,
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "Density $self->{density}, Warp Speed $self->{speed}";
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSFLYWIN.SCR";
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
[Screen Saver.Flying Windows]
Density=$self->{density}
WarpSpeed=$self->{speed}
PWProtected=0
EOF
    }

    return $line;
}

1;

