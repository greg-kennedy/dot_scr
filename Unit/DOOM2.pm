package Unit::DOOM2;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Doom 2 (EnterAct modules)

my @modules = (
    [ 'Duel'          => { 'Stretch' => [ 1 .. 2 ] } ],
    [ 'Barrels-o-Fun' => { 'Barrels' => [ 0 .. 2 ] } ],
    [ 'Skeet Shoot'   => {} ],
    [ 'Fireworks'     => {} ],
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'DOOM2',
        fullname => 'DOOM II Screen Saver',
        author   => 'id Software',
        payload  => ['DOOM2.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/ENTERACT.INI' => \&edit_enteract,
        },

        weight => scalar @modules,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    my $mod_num = int( rand( scalar @modules ) );

    my @module = @{ $modules[$mod_num] };

    # build out module-specific config strings
    my $ini_setting = '';
    my $cfg_str     = '';

    foreach my $key ( keys %{ $module[1] } ) {
        my $value = _pick( @{ $module[1]{$key} } );
        $ini_setting .= sprintf( "%s=%d\n",  $key, $value );
        $cfg_str     .= sprintf( ", %s: %d", $key, $value );
    }

    # all modules have an Interlude setting
    my $percent = int( rand(101) );
    if ($percent) {
        $ini_setting .= "Interlude=1\nInterludePerCent=$percent\n";
    } else {
        $ini_setting .= "Interlude=0\n";
    }
    $cfg_str .= ", Interlude chance $percent%";

    # other settings for the ini: message enable, background style
    my $bg_style = _pick( 1, 2, 5 );
    my $bg_start = int( rand(0x1000000) );
    my $bg_end   = int( rand(0x1000000) );

    if ( $bg_style == 5 ) {
        $cfg_str .= ", Background: Desktop";
    } elsif ( $bg_style == 2 ) {
        $cfg_str .= sprintf( ", Background: Solid #%06x", $bg_start );
    } else {
        $cfg_str .= sprintf( ", Background: Gradient #%06x to #%06x", $bg_start,
            $bg_end );
    }

    my $message_enable = int( rand(2) );
    $cfg_str .= ", Message " . ( $message_enable ? "enabled" : "disabled" );

    my $self = {
        number => $mod_num,
        name   => $module[0],

        cfg_str => $cfg_str,
        ini_str => $ini_setting,

        bg_style => $bg_style,
        bg_start => $bg_start,
        bg_end   => $bg_end,
        message  => $message_enable,

        sound => 1,
        dosbox => {
            start => 12000,
            cycles => 10000
        },
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "Module: " . $self->{name} . $self->{cfg_str};
}

##############################################################################

sub edit_systemini {
    my ( $self, $line ) = @_;

    # EnterAct has a 386Enh driver that needs loading.
    #  Append it immediately after the 386Enh header.
    if ( defined $line ) {
        if ( $line =~ m/^\[386Enh\]$/i ) {
            $line .= "\ndevice=EnterAct.386";
        } elsif ( $line && $line =~ m/^SCRNSAVE\.EXE=/i ) {
            $line = "SCRNSAVE.EXE=C:\\WINDOWS\\ENTERACT.SCR";
        }
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    # EnterAct can run either through SCRNSAVE.EXE or
    #  it will launch itself from the background app.
    # unfortunately the background app needs an entry in Startup.grp
    #  not load= so we will just use the built-in method
    if ( $line && $line =~ m/^ScreenSaveActive=/i ) {
        $line = "ScreenSaveActive=1";
    }

    return $line;
}

sub edit_enteract {
    my ( $self, $line ) = @_;

    if (defined $line) {
        if ( $line =~ m/^UseMessage=/i ) {
            $line = "UseMessage=" . $self->{message};
        } elsif ( $line =~ m/^DesktopType=/i ) {
            $line = "DesktopType=" . $self->{bg_style};
        } elsif ( $line =~ m/^SolidColor=/i ) {
            $line = "SolidColor=" . $self->{bg_start};
        } elsif ( $line =~ m/^GradientColorTop=/i ) {
            $line = "GradientColorTop=" . $self->{bg_start};
        } elsif ( $line =~ m/^GradientColorBottom=/i ) {
            $line = "GradientColorBottom=" . $self->{bg_end};
        } elsif ( $line =~ m/^Module=/i ) {
            $line = sprintf( "Module=C:\\ENTERACT\\DOOMSAVE\\DOOMSV%02d.DLL",
                $self->{number} + 1 );
        } elsif ( $line =~ m/^NumModule=/i ) {
            $line = "NumModule=" . ($self->{number} + 1);
        }
    } else {
        $line =
            "[DOOM II Screen Saver."
          . $self->{name} . "]\n"
          . $self->{ini_str} . "\n";
    }

    return $line;
}

1;

