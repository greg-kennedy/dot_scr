package Unit::SSMYST;
use strict;
use warnings;

use Unit::Common::Microsoft;

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'SSMYST',
        fullname => 'Mystify',
        author   => 'Microsoft',
        payload  => ['MICROSOFT.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&append_controlini,
        },

        #        weight => 1,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    my $self = {
        'clear' => int( rand(2) ),
        'poly1' => {
            'active' => 1,
            'lines'  => int( rand(11) ) + 5,
            'random' => int( rand(2) ),
            'start'  => _pick( keys %Unit::Common::Microsoft::ext_palette ),
            'end'    => _pick( keys %Unit::Common::Microsoft::ext_palette ),
        },
        'poly2' => {
            'active' => int( rand(2) ),
            'random' => int( rand(2) ),
            'lines'  => int( rand(11) ) + 5,
            'start'  => _pick( keys %Unit::Common::Microsoft::ext_palette ),
            'end'    => _pick( keys %Unit::Common::Microsoft::ext_palette ),
        },
        dosbox => {
            start => 8000,

            #            cycles => 0
        },

        #        sound => 0,
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    my $settings = '';
    if ( !$self->{clear} ) { $settings = "Don't " }
    $settings .= "clear screen,\n";

    $settings .=
      "Polygon 1: active, $self->{poly1}{lines} lines, color "
      . ( $self->{poly1}{random}
        ? "randomized"
        : $self->{poly1}{start} . " to " . $self->{poly1}{end} )
      . "\n";

    $settings .= "Polygon 2: ";
    if ( !$self->{poly2}{active} ) { $settings .= "inactive"; }
    else {
        $settings .=
          "active, $self->{poly2}{lines} lines, color "
          . ( $self->{poly2}{random}
            ? "randomized"
            : $self->{poly2}{start} . " to " . $self->{poly2}{end} )
          . "\n";
    }

    return $settings;
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSMYST.SCR";
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
        my $color1start =
          $Unit::Common::Microsoft::ext_palette{ $self->{poly1}{start} };
        my $color1end =
          $Unit::Common::Microsoft::ext_palette{ $self->{poly1}{end} };
        my $color2start =
          $Unit::Common::Microsoft::ext_palette{ $self->{poly2}{start} };
        my $color2end =
          $Unit::Common::Microsoft::ext_palette{ $self->{poly2}{end} };
        $line = <<"EOF";
[Screen Saver.Mystify]
Clear Screen=$self->{clear}
Active1=$self->{poly1}{active}
Lines1=$self->{poly1}{lines}
WalkRandom1=$self->{poly1}{random}
StartColor1=$color1start
EndColor1=$color1end
Active2=$self->{poly2}{active}
Lines2=$self->{poly2}{lines}
WalkRandom2=$self->{poly2}{random}
StartColor2=$color2start
EndColor2=$color2end
PWProtected=0
EOF
    }

    return $line;
}

1;
