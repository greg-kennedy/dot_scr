package Unit::ADDISNEY;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
    '  101Dalmatians' => [
        [ 'Number of Dogs'      => 100 ],
        [ 'Bark Frequency' => 100 ],
        [ 'Clear' => 100 ],
        [ 'Clear Screen First' => 1 ],
    ],
    '  Beauty' => [
        [ 'Delay'      => 100 ],
        [ 'Shuffle Windows' => 1 ],
        [ 'Mode' => 1 ],
        [ 'Music' => 100 ],
    ],
    '  Captain Hook' => [
        [ 'Clear Screen First' => 1 ],
        [ 'Music' => 100 ],
    ],
    '  Cheshire Cat' => [
        [ 'Shyness'      => 100 ],
        [ 'Haste' => 100 ],
        [ 'Indecision' => 100 ],
        [ 'Clear Screen First' => 1 ],
    ],
    '  Digital Ink' => [],
    '  DisneyClocks' => [
        [ 'Clock'       => 6 ],
        [ 'Sounds'      => 3 ],
        [ 'Drift Interval' => 100 ],
        [ 'Clear Screen First' => 1 ],
    ],
    '  Donald Paints' => [
        [ 'Neatness'       => 100 ],
        [ 'Color'      => 3 ],
        [ 'Style' => 5 ],
        [ 'Clear Screen First' => 1 ],
    ],
    '  FallingFlower' => [
        [ 'Flowers' => 100 ],
        [ 'Music' => 100 ],
    ],
    '  Goofy' => [],
    '  Haunted' => [
        [ 'Screamishness' => 100 ],
    ],
    '  Jungle Book' => [
        [ 'Thunder' => 100 ],
    ],
    '  LittleMermaid' => [
        [ 'Creatures'      => 100 ],
        [ 'Visitors' => 100 ],
        [ 'Music' => 100 ],
        [ 'Sea' => 2 ],
    ],
    '  MagicKingdom' => [
        [ 'Castle'      => 2 ],
        [ '# of Fireworks' => 100 ],
        [ 'Delay' => 100 ],
    ],
    '  Pinocchio' => [
        [ 'Figaro'      => 100 ],
    ],
    '  Scrooge' => [
        [ 'Money'      => 100 ],
	[ 'Type'       => 2 ],
    ],
    '  The Sorcerer' => [
        [ 'Brooms'      => 100 ],
        [ 'Music' => 100 ],
    ],
    #'Randomizer' => [
    #    [ 'Order'      => 1 ],
    #    [ 'Duration' => 100 ],
    #],
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
        name     => 'ADDISNEY',
        fullname => 'After Dark: Disney Collection (2.0d)',
        author   => 'Berkeley Systems',
        payload  => ['ADDISNEY.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'   => \&edit_systemini,
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
        },
        files_custom => {
            'WINDOWS/ADMODULE.ADS' => \&extra_admodule,
        },
        dosbox => {
            start  => 63000,
            #cycles => 3000,
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
	    if ($knob->[0] eq 'Music') {
	        # always play music
		$value = 100;
	    } else {
                $value = int( rand( $knob->[1] + 1 ) );
                $cfg_str .=
                  ", $knob->[0]: $value" . ( $knob->[1] == 100 ? '%' : '' );
            }
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
	sound        => 1,
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
