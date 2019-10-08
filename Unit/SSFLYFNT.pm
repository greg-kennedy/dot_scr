package Unit::SSFLYFNT;
use strict;
use warnings;

use Unit::Common::Microsoft;

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'SSFLYFNT',
        fullname => 'Flying Fonts',
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
        text   => "TrueType",
        colors => int( rand(32767) ) + 1,

        # flying=1 spinning=2 rollercoaster=4
        effect => int( rand(3) ),
        bold   => int( rand(1) ),
        italic => int( rand(1) ),
        speed  => int( rand(100) ) + 1,
        font   => _pick(@Unit::Common::Microsoft::font_faces),

        dosbox => {
            start => 8000,
        },
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    my $description = 'Text "' . $self->{text} . "\"\n";
    $description .= ( "Flying", "Spinning", "Rollercoaster" )[ $self->{effect} ]
      . " Effect\n";
    $description .= 'Colors ' . $self->{colors} . ", Speed $self->{speed}\n";
    $description .= 'Font '
      . $self->{font}
      . ( $self->{bold}   ? ' Bold'   : '' )
      . ( $self->{italic} ? ' Italic' : '' );

    return $description;
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSFLYFNT.SCR";
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

        my $weight = ( $self->{bold}   ? 700 : 400 );
        my $italic = ( $self->{italic} ? 255 : 0 );
        my $effect = ( 1, 2, 4 )[ $self->{effect} ];

        $line = <<"EOF";
[ScreenSaver.Flying Fonts]
Effects=$effect
Colors=$self->{colors}
Speed=$self->{speed}
Duration=100
String=$self->{text}
lfFaceName=$self->{font}
lfWeight=$weight
lfItalic=$italic
lfCharSet=0
lfOutPrecision=3
lfClipPrecision=2
lfPitchAndFamily=0
PWProtected=0
EOF
    }
    return $line;
}

1;
