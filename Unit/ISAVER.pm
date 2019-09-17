package Unit::ISAVER;
use strict;
use warnings;

# https://winworldpc.com/product/intel-demos/10

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'ISAVER',
        fullname => 'iSaver',
        author   => 'Kent Forschmiedt / Intel Corporation',
        payload  => ['IGOODIES.zip'],
        files    => {
            'WINDOWS/WIN.INI' => \&edit_winini,
        },
        dosbox => {
            start => 65000,

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

    my $self = {};

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "(none)";
}

##############################################################################
sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^load=(.*)$/ ) {
        $line = "load=ISAVER.EXE $1";
    }

    return $line;
}

1;
