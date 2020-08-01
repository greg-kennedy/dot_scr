package Unit::SSMARQUE;
use strict;
use warnings;

use Unit::Common::Microsoft;

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'SSMARQUE',
        fullname => 'Marquee',
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

    my $bgcolor = _pick( keys %Unit::Common::Microsoft::ext_palette );
    my $textcolor;
    do {
        $textcolor = _pick( keys %Unit::Common::Microsoft::palette );
    } while ( $bgcolor eq $textcolor );

    my $self = {
        text => substr(
	"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            0,
            253
        ),
        position  => int( rand(2) ),
        strikeout => int( rand(2) ),
        underline => int( rand(2) ),
        bold      => int( rand(2) ),
        italic    => int( rand(2) ),
        speed     => int( rand(30) ) + 1,
        bgcolor   => $bgcolor,
        textcolor => $textcolor,
        size      => _pick(@Unit::Common::Microsoft::font_sizes),
        font      => _pick(@Unit::Common::Microsoft::font_faces),

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

    my $description =
        'Position '
      . ( $self->{position} ? 'Centered' : 'Random' )
      . ', Speed '
      . $self->{speed} . "\n";
    $description .=
        'Text Color '
      . $self->{textcolor}
      . ', Background Color '
      . $self->{bgcolor} . "\n";
    $description .= 'Font '
      . $self->{size} . 'pt '
      . $self->{font}
      . ( $self->{bold}      ? ' Bold'       : '' )
      . ( $self->{italic}    ? ' Italic'     : '' )
      . ( $self->{strikeout} ? ', Strikeout' : '' )
      . ( $self->{underline} ? ', Underline' : '' );

    return $description;
}

sub followup {
    my $self = shift;

    return "Text: " . $self->{text};
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSMARQUE.SCR";
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
        my $attributes = sprintf(
            "%01d" x 5,
            $self->{underline}, $self->{strikeout}, $self->{italic},
            $self->{position},  $self->{bold}
        );

        my $bgcolor = $Unit::Common::Microsoft::ext_palette{ $self->{bgcolor} };
        my $textcolor = $Unit::Common::Microsoft::palette{ $self->{textcolor} };

        $line = <<"EOF";
[Screen Saver.Marquee]
Text=$self->{text}
Font=$self->{font}
Size=$self->{size}
BackgroundColor=$bgcolor
TextColor=$textcolor
Speed=$self->{speed}
Attributes=$attributes
CharSet=0
PWProtected=0
EOF
    }

    return $line;
}

1;
