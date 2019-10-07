package Unit::MSSCENE2;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Microsoft Scenes 2.0
#  This unit has quirks, see edit_scenesini()
# The other annoying thing is that ChangeDelay must be a multiple of 60

# list of sets with number of images in each
# Sierra Club is duplicated in MS Scenes 2.0 "Nature"
#  (with slightly higher resolution)
my %picsets = (
    'Brain Twister' => 40,
    'Flight' => 40,
    'Hollywood' => 40,
#    'Sierra Club Nature' => 48,
    'Sierra Club Wildlife' => 40,
    'Sports Extremes' => 40,
    'Stereogram' => 40,
    'Undersea' => 40,
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'MSSCENE2',
        fullname => 'Microsoft Scenes 2.0',
        author   => 'Microsoft',
        payload  => ['MSSCENE2.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'  => \&edit_winini,
            'WINDOWS/SCENES2.INI'     => \&edit_scenesini,
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
        picstart   => int( rand( $picsets{$picset} ) ) + 1,
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
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\MSSCENES.SCR";
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

    # MS Screens 2.0 allows multiple picture collections at once, and will
    #  choose randomly between them.  This is done by an entry in each
    #  picset's COLLECTN.SAC file: ScreenSaverUses=0 if it's deselected or
    #  =1 if it's available for screensaver rotation.
    # The "correct" way to select only one collection is to go through and
    #  change the values for all others to 0.
    # Instead I will simply hack scenes2.ini and comment out every picset
    #  that doesn't match this one :)
    if ($line) {
        if ( $line =~ m/^NextCollection=/i ) {
            $line = "NextCollection=" . $self->{picset};
        } elsif ( $line =~ m/^NextPicture=/i ) {
            $line = "NextPicture=" . $self->{picstart};
        } elsif ( $line =~ m/^([^=]+)=C:\\SCENES\\PICSETS\\/i &&
          $1 ne $self->{picset}) {
            $line = '; ' . $line;
        }
    }

    return $line;
}

1;

