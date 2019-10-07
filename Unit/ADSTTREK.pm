package Unit::ADSTTREK;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
    ' Brain Cells' => [
        [ 'Max # Cells'     => 100 ],
        [ 'Clear Every' => 100 ],
        [ 'Clear Screen First' => 1 ],
    ],
    ' Communications' => [
        undef,
        [ 'Style' => 6 ],
        [ 'Message' => 9 ],
    ],
    ' Final Exam' => [
        [ 'Timer' => 100 ],
        [ 'Show Answer' => 1 ],
        [ 'Text Only' => 1 ],
    ],
    ' Final Frontier' => [
        [ 'Show Title' => 1 ],
        [ 'Spin Planets' => 1 ],
    ],
    ' Horta' => [
        [ '# Horta'     => 100 ],
        [ '# Red Shirts'     => 100 ],
        [ 'Fertility' => 100 ],
        [ 'Clear Screen First' => 1 ],
    ],
    ' Ion Storm' => [
        [ 'Color'      => 5 ],
        [ 'Color Speed' => 100 ],
        [ 'Trail Length' => 100 ],
        [ 'Big Dots' => 1 ],
    ],
    ' PlanetaryAtlas' => [
        [ 'Pause'      => 100 ],
        [ 'Planet Only'     => 1 ],
        [ 'Stars' => 1 ],
    ],
    " Scotty's Files" => [
        [ 'Pause'      => 100 ],
    ],
    ' Ship Panels' => [
        [ 'Display'      => 8 ],
        [ 'Redraw Every'      => 100 ],
    ],
    ' Sickbay' => [
        [ "McCoy's Quotes" => 1 ],
        [ 'Diagnostic Text' => 1 ],
    ],
    ' Space' => [
        [ 'Redraw Every'      => 100 ],
        [ '# Ships'      => 100 ],
        [ '# Nebulae'      => 100 ],
    ],
    ' Spock' => [
        [ 'Clear Screen First' => 1 ],
    ],
    ' The Mission' => [],
    ' Tholian Web' => [
        [ 'Ship Speed'      => 100 ],
        [ 'Clear Screen First' => 1 ],
    ],
    ' Tribbles' => [
        [ 'Reproduce'      => 100 ],
        [ 'Klingon' => 100 ],
        [ 'Clear Screen First' => 1 ],
    ],
    #'MultiModule'    => undef,
    #'Randomizer' => [
    #    [ 'Order'      => 1 ],
    #    [ 'Duration' => 100 ],
    #],
    #'Sounder' => {
    #    sound => 1,
    #    cfg => [
    #        [ 'Order' => 2],
    #        [ 'Delay' => 100 ],
    #        undef,
    #        [ 'Blank Screen' => 1 ],
    #    ]
    #},
    #'Starry Night' => [
    #    [ 'Buildings'       => 100 ],
    #    [ 'Building Height' => 100 ],
    #        undef,
    #    [ 'Lightning' => 100 ],
    #],
);
##############################################################################

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'ADSTTREK',
        fullname => 'After Dark: Star Trek (2.0c)',
        author   => 'Berkeley Systems',
        payload  => ['ADSTTREK.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
        },
        files_custom => {
            'WINDOWS/ADMODULE.ADS' => \&extra_admodule,
        },
        dosbox => {
            start  => 71000,
            cycles => 5000,
        },
        weight => scalar keys %controls,
    );
}

sub new {
    my $class    = shift;
    my $basepath = shift;

    # parse all AD module names
    my %modules;

    open( my $fpi, '<:raw', "$basepath/WINDOWS/ADMODULE.ADS" )
      or die "Couldn't open admodule.ads: $!";
    until ( eof $fpi ) {
        read $fpi, my $buf, 49;
        my ( $filename, $realname ) = unpack 'Z[13]Z[20]x[16]', $buf;
        if ( exists $controls{$realname} ) {
          $modules{$realname} = $filename;
        } else {
          print "Skipping unknown module $realname\n";
        }
    }

    # Pick da winna
    my $module = _pick( keys %modules );

    # Configuration only happens for non-MultiModule entries
    my $cfg     = '';
    my $cfg_str = '';

    # Set config options
    for ( my $i = 0 ; $i < 4 ; $i++ ) {
        my $value;
        my $knob = $controls{$module}[$i];
        if ( defined $knob ) {
            $value = int( rand( $knob->[1] + 1 ) );
            $cfg_str .=
              ", $knob->[0]: $value" . ( $knob->[1] == 100 ? '%' : '' );
        } else {
            $value = 0;
        }
        $cfg .= pack( 'v', $value );
    }

    my $self = {
        module       => $module,
        module_file  => $modules{$module},
        settings     => $cfg_str,
        settings_bin => $cfg,
        sound        => ($module eq ' Ion Storm' ? undef : 1),
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    return "Module: $self->{module}" . $self->{settings};

#return { settings => "Module: $self->{module}" . $self->{settings}, sound => $self->{sound} };
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
            $line = "Module=\"$self->{module}\"";
        } elsif ( $line =~ m/^ModuleFile=/i ) {
            $line = "ModuleFile=$self->{module_file}";
        }
    }

    return $line;
}

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

1;
