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
        dosbox => {
            start => 8000,

            #            cycles => 0
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
"What the fuck did you just fucking say about me, you little bitch? I'll have you know I graduated top of my class in the Navy Seals, and I've been involved in numerous secret raids on Al-Quaeda, and I have over 300 confirmed kills. I am trained in gorilla warfare and I'm the top sniper in the entire US armed forces. You are nothing to me but just another target. I will wipe you the fuck out with precision the likes of which has never been seen before on this Earth, mark my fucking words. You think you can get away with saying that shit to me over the Internet? Think again, fucker. As we speak I am contacting my secret network of spies across the USA and your IP is being traced right now so you better prepare for the storm, maggot. The storm that wipes out the pathetic little thing you call your life. You're fucking dead, kid. I can be anywhere, anytime, and I can kill you in over seven hundred ways, and that's just with my bare hands. Not only am I extensively trained in unarmed combat, but I have access to the entire arsenal of the United States Marine Corps and I will use it to its full extent to wipe your miserable ass off the face of the continent, you little shit. If only you could have known what unholy retribution your little \"clever\" comment was about to bring down upon you, maybe you would have held your fucking tongue. But you couldn't, you didn't, and now you're paying the price, you goddamn idiot. I will shit fury all over you and you will drown in it. You're fucking dead, kiddo.",
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
