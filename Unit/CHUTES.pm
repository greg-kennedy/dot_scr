package Unit::CHUTES;
use strict;
use warnings;

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'CHUTES',
        fullname => 'Chutes',
        author   => 'Strange Software',
        payload  => ['CHUTES.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&append_controlini,
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

    my $self = {
        packer => int(rand(6)),
        passes => int(rand(10)) + 1,
        limit => int(rand(4)),
	fastoff => int(rand(2))
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    my @packer = ('Expert', 'Trainee', 'Summer Help', 'Back from the Pub', 'Saboteur', 'Psychopath');
    return "Packer: " . $packer[$self->{packer}] . ", Chutes Limit: " . $self->{limit} . ", " . ($self->{fastoff} ? "Skip Takeoff" : "Passes: " . $self->{passes});
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\CHUTE.SCR";
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
[ScreenSaver.Chutes]
Packer=$self->{packer}
Passes=$self->{passes}
Limit=$self->{limit}
FastOff=$self->{fastoff}
PWProtected=0
EOF
    }

    return $line;
}

1;
