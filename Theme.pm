package Theme;

# Special "theme" class that randomizes wallpaper and stuff

use strict;
use warnings;

use Unit::Common::Microsoft;

# Helper
sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name  => 'Theme',
        files => {
            'WINDOWS/WIN.INI'     => \&edit_winini,
            'WINDOWS/CONTROL.INI' => \&edit_controlini,
        },
    );
}

sub new {
    my $class = shift;

    my $basepath = shift;

    # get list of possible BMP files from windows folder
    opendir( my $dh, $basepath . '/WINDOWS' );
    my @files = readdir($dh);
    closedir($dh);

    my @bmps;
    foreach my $file (@files) {
        if ( $file =~ m/^.+\.bmp$/i ) {
            push @bmps, $file;
        }
    }

    # Pick today's winner
    my $bmp = _pick( "(None)", _pick(@bmps) );

    # themes too
    my $theme_name = _pick( keys %Unit::Common::Microsoft::themes );

    my $self = {
        wallpaper  => $bmp,
        pattern    => _pick(@Unit::Common::Microsoft::patterns),
        theme_name => $theme_name,
        theme      => $Unit::Common::Microsoft::themes{$theme_name},
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return
"Wallpaper $self->{wallpaper}, Pattern $self->{pattern}, Theme $self->{theme_name}";
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_controlini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^Color Schemes=/i ) {
        $line = "Color Schemes=$self->{theme_name}";
    }

    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( defined($line) ) {
        if ( $line =~ m/^Wallpaper=/i ) {
            $line = "Wallpaper=$self->{wallpaper}";
        } elsif ( $line =~ m/^Pattern=/i ) {
            $line = "Pattern=$self->{pattern}";
        }
    } else {
        my @objects = (
            'Background',     'AppWorkspace',
            'Window',         'WindowText',
            'Menu',           'MenuText',
            'ActiveTitle',    'InactiveTitle',
            'TitleText',      'ActiveBorder',
            'InactiveBorder', 'WindowFrame',
            'Scrollbar',      'ButtonFace',
            'ButtonShadow',   'ButtonText',
            'GrayText',       'Hilight',
            'HilightText',    'InactiveTitleText',
            'ButtonHilight',
        );

        $line = "[Colors]\n";

        for ( my $i = 0 ; $i < scalar @objects ; $i++ ) {
            my $color = sprintf( '%06s', substr( $self->{theme}[$i], -6 ) );
            $line .= sprintf( "%s=%d %d %d\n",
                $objects[$i],
                hex( substr( $color, 4, 2 ) ),
                hex( substr( $color, 2, 2 ) ),
                hex( substr( $color, 0, 2 ) ) );
        }

    }
    return $line;
}

1;
