package Unit::SCRANTIC;
use strict;
use warnings;

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'SCRANTIC',
        fullname => 'Johnny Castaway (Screen Antics)',
        author   => 'Sierra On-Line',
        payload  => ['SCRANTIC.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/SCRANTIC.INI' => \&append_scranticini,
        },

        #        weight => 1,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    my $now = time();
    my ( undef, undef, undef, $mday, $mon, $year, undef, undef, undef )
      = localtime($now);
    my $self = {
        current_year  => $year + 1900,
        current_month => $mon + 1,
        current_day   => $mday,
        day           => int( $now / ( 60 * 60 * 24 ) ) % 11 + 1,
        sound         => 1,
        dosbox => {
            start => 18000,

            #            cycles => 0,
        },
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    return sprintf("Date %04d-%02d-%02d (Day %d)",
      $self->{current_year}, $self->{current_month}, $self->{current_day}, $self->{day});
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SCRANTIC.SCR";
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

sub append_scranticini {

    my ( $self, $line ) = @_;

    if ( !defined $line ) {
        $line = <<"EOF";
[ScreenSaver.ScreenAntics]
SourceDir=C:\\SIERRA\\SCRANTIC
Background=1
Clouds=1
Waves=1
Sounds=1
NumDays=$self->{day}
Introduction=$self->{day}
CurrentYear=$self->{current_year}
CurrentMonth=$self->{current_month}
CurrentDay=$self->{current_day}
StartTime=800
Password=
EOF
    }
    return $line;
}

1;
