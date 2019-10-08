package Unit::ADMARVEL;
use strict;
use warnings;

##############################################################################
# ADMARVEL is an After Dark module, but it only does a slideshow, and
#  the config is stuff that would be not fun to change.

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'ADMARVEL',
        fullname => 'After Dark: Marvel Comics Screen Posters (2.0c)',
        author   => 'Berkeley Systems',
        payload  => ['ADMARVEL.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
            'WINDOWS/WIN.INI'      => \&edit_winini,
            #'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
        },
        weight => 1,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    my $self = {
        dosbox => {
            start  => 71000,
            cycles => 5000,
        },
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    return "(none)";
}

sub edit_systemini {
    my ( $self, $line ) = @_;

    # After Dark 2.0 has a 386Enh driver that needs loading.
    #  Append it immediately after the 386Enh header.
    if ( defined $line ) {
        if ( $line =~ m/^\[386Enh\]$/i ) {
            $line .= "\ndevice=ad.386";
        }
    }

    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line ) {
      if ( $line =~ m/^load=(.*)$/ ) {
        $line = "load=c:\\afterdrk\\ad.exe c:\\afterdrk\\adinit.exe $1";
      }
    }

    return $line;
}


sub edit_adprefsini {
    my ( $self, $line ) = @_;

    # AD_PREFS.INI to set up the desired module
    if ($line) {
        if ( $line =~ m/^Module=/i ) {
            $line = 'Module="Marvel Comics"';
        } elsif ( $line =~ m/^ModuleFile=/i ) {
            $line = "ModuleFile=marvel.ad";
        }
    }

    return $line;
}
=pod
sub extra_admodule {
    my ( $self, $input, $output ) = @_;

    # ADMODULE.ADS to make settings changes for our picks
    open( my $fpi, '<:raw', $input )  or die "Couldn't open $input: $!";
    open( my $fpo, '>:raw', $output ) or die "Can't open $output file: $!";
    until ( eof $fpi ) {
        read $fpi, my $buf, 49;
        my $realname = unpack 'x[13]Z[20]x[16]', $buf;
        if ( $self->{module} eq $realname ) {
            substr( $buf, 33, 8 ) = $self->{settings_bin};
        }
        print $fpo $buf;
    }
}
=cut
1;
