package Unit::MSSCENE1;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Microsoft Scenes 1.0

# list of sets with number of images in each

my %picsets = (
    'Impressionists' => 48,
    'Sierra Club' => 48,
    'Outer Space' => 48,
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'MSSCENE1',
        fullname => 'Microsoft Scenes 1.0',
        author   => 'Microsoft',
        payload  => ['MSSCENE1.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'  => \&edit_winini,
            'WINDOWS/SCENES.INI'     => \&edit_scenesini,
        },
        dosbox => {
            start => 8000,

            #            cycles => 0
        },

        weight => scalar keys %picsets,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    my $picset = _pick(keys %picsets);

    my $self = {
        picset => $picset,
        picstart   => int( rand($picsets{$picset}) ) + 1,

        #        sound => 0,
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "Picture Set: $self->{picset}";
}

##############################################################################

sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSMSSCNS.SCR";
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    # not adding scenes.exe to load= line, it is not necessary and
    #  it also changes the wallpaper...
    if ( $line && $line =~ m/^ScreenSaveActive=/i ) {
        $line = "ScreenSaveActive=1";
    }

    return $line;
}

sub edit_scenesini {
    my ( $self, $line ) = @_;

    # the INI file lies: NextPicture is not 0-based, it's 1-based
    #  setting to 0 causes a marquee error "please reinstall Scenes"
    if ($line) {
        if ( $line =~ m/^CurrentPictureSet=/i ) {
            $line = "CurrentPictureSet=" . $self->{picset};
        } elsif ( $line =~ m/^NextPicture=/i ) {
            $line = "NextPicture=" . $self->{picstart};
        }
    }

    return $line;
}

1;

