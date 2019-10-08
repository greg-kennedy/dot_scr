package Unit::MAGIC;
use strict;
use warnings;

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'MAGIC',
        fullname => 'Magic ScreenSaver',
        author  => 'Bill Stewart & Ian MacDonald / Dynamic Information Systems',
        payload => ['MAGIC.zip'],
        files   => {
            'WINDOWS/WIN.INI' => \&edit_winini,
        },

        #        weight => 1,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    my $self = {
        length => int( rand(2) ) ? 0 : int( rand(150) ) + 1,
        mirror => int( rand(4) ),
        speed  => int( rand(100) ) + 1,
        color  => int( rand(101) ),

        dosbox => {
            start  => 76000,
            cycles => 3000,
        },
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    my $description =
      "Trail Length " . ( $self->{length} ? $self->{length} : 'MAX' );
    $description .= ", Mirror "
      . ( 'None', 'Horizontal', 'Vertical', 'Both' )[ $self->{mirror} ] . "\n";
    $description .=
        "Moire Speed "
      . $self->{speed}
      . "%, Color Cycle Speed "
      . $self->{color} . "%";

    return $description;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
        if ( $line =~ m/^load=(.*)$/ ) {
            $line = "load=MAGIC.EXE $1";
        }
    } else {

        $line = <<"EOF";

[Magic]
iconState=static
ScreenSaverOn=1
timeout=1
moireLength=$self->{length}
MirrorMode=$self->{mirror}
moireSpeed=$self->{speed}
colourSpeed=$self->{color}
PasswordSwitch=0
Password=
EOF
    }
    return $line;
}

1;
