package Unit::AFTERDRK;
use strict;
use warnings;

##############################################################################
# giant module settings meanings
my %controls = (
    'Aquatic Realm' =>
      [ [ 'Creatures', 100 ], [ 'Seaweed', 100 ], [ 'Show Sea Floor', 1 ], ],
    'Can of Worms' => [
        [ 'Wiggle',   100 ],
        [ 'Segments', 100 ],
        [ 'Worms',    100 ],
        [ 'Sound',    1 ],
    ],
    'Clocks' => [
        [ 'Type',         2 ],
        [ 'Float Speed',  100 ],
        [ 'Show Seconds', 1 ],
        [ 'Sound',        1 ],
    ],
    'Down the Drain' => [
        [ 'Speed',      100 ],
        [ 'Direction',  100 ],
        [ 'Drops',      1 ],
        [ 'Show Drain', 1 ],
    ],
    'Fade Away'       => [ [ 'Style',          6 ], ],
    'Flying Toasters' => [ [ 'Flying Objects', 100 ], [ 'Toast', 100 ], ],
    'GeoBounce' =>
      [ [ 'Shape', 4 ], [ 'Size', 100 ], [ 'Speed', 100 ], [ 'Faces', 2 ], ],
    'Globe'     => [ [ 'Rotation', 100 ], [ 'Speed', 100 ], ],
    'GraphStat' => [ [ 'Delay',    100 ], ],
    'Gravity'   => [
        [ 'Number Balls', 100 ],
        [ 'Size',         100 ],
        [ 'Clear Screen', 1 ],
        [ 'Sound',        1 ],
    ],
    'Hard Rain' => [
        [ '# of Drops', 100 ],
        [ 'Drop Size',  100 ],
        undef,
        [ 'Clear Screen First', 1 ],
    ],
    'Lasers' => [
        [ 'Rays',               7 ],
        [ 'Width',              100 ],
        [ 'Color Speed',        100 ],
        [ 'Clear Screen First', 1 ],
    ],
    'Logo'  => [ [ 'Speed', 100 ], ],
    'Magic' => [
        [ 'Lines',       100 ],
        [ 'Line Speed',  100 ],
        [ 'Color Speed', 100 ],
        [ 'Mirror',      3 ],
    ],
    'Messages' => [ [ 'Move', 2 ], [ 'Speed', 100 ], ],
    'Mondrian' => [ [ 'Speed', 100 ], [ 'Clear Screen First', 1 ], ],
    'Mountains' => [
        [ 'View',       5 ],
        [ 'Planet',     9 ],
        [ 'Complexity', 100 ],
        [ 'Zoom',       100 ],
    ],
    'Nocturnes' => [ undef, undef, [ 'Color', 1 ], [ 'Density', 100 ], ],
    'Punch Out' =>
      [ [ 'Shape', 4 ], [ 'Size', 100 ], [ 'Speed', 100 ], [ 'Sound', 1 ], ],
    'Puzzle' => [
        [ 'Size', 2 ], [ 'Speed', 2 ], [ 'Sound', 1 ], [ 'Invert Screen', 1 ],
    ],
    'Rain Storm' => [
        [ 'Strength',  100 ],
        [ 'Lightning', 100 ],
        [ 'Drops',     100 ],
        [ 'Wind',      100 ],
    ],
    #  'Randomizer' => [
    #    [ 'Order', 1 ],
    #    [ 'Duration', 100 ],
    #    [ 'Clear Screen', 1 ],
    #],
    'Rose' => [ [ 'Speed', 100 ], [ 'Trail Length', 100 ], [ 'Big Dots', 1 ], ],
    'Satori' => [
        [ 'Display',     6 ],
        [ 'Colors',      13 ],
        [ 'End Clarity', 100 ],
        [ 'Knots',       100 ],
    ],
    'Shapes'     => [ [ 'Clear Screen First', 1 ],   [ 'Color',      1 ], ],
    'Slide Show' => [ [ 'Display Time',       100 ], [ 'Fade Speed', 100 ], ],
    'Spheres'    => [
        [ 'Max Size',           100 ],
        [ 'Offset',             100 ],
        [ 'Clear Every',        100 ],
        [ 'Clear Screen First', 1 ],
    ],
    'Spiral Gyra' =>
      [ [ 'Max Lines', 100 ], [ 'Min Lines', 100 ], [ 'Color Cycling', 100 ], ],
    'Spotlight' => [ [ 'Size', 100 ], [ 'Speed', 100 ], ],
    'Stained Glass' =>
      [ [ 'Complexity', 100 ], [ 'Duplication', 100 ], [ 'Color', 100 ], ],
    'Starry Night' => [
        [ 'Buildings',       100 ],
        [ 'Building Height', 100 ],
        undef,
        [ 'Lightning', 100 ],
    ],
    'String Theory' => [
        [ 'String Groups',      3 ],
        [ 'Strings',            100 ],
        [ 'Color Speed',        100 ],
        [ 'Clear Screen First', 1 ],
    ],
    'Vertigo' => [
        [ 'Palette',      2 ],
        [ 'Spiral Pitch', 100 ],
        [ 'Color Speed',  100 ],
        [ 'Delay',        100 ],
    ],
    'Warp!' =>
      [ [ 'Speed', 100 ], [ 'Stars', 100 ], [ 'Size', 2 ], [ 'Color', 1 ], ],
    'Wrap Around' =>
      [ [ 'Delay', 100 ], [ 'Number of Lines', 100 ], [ 'Color Speed', 100 ], ],
    'Zot!' => [ [ 'Forkiness', 100 ], undef, [ 'How Often', 100 ], ],
);
##############################################################################

sub _pick { return $_[ rand @_ ]; }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'AFTERDRK',
        fullname => 'After Dark 1.0',
        author   => 'Berkeley Systems',
        payload  => ['AFTERDRK.zip'],
        files    => {
            'WINDOWS/WIN.INI'      => \&edit_winini,
            'WINDOWS/AD_PREFS.INI' => \&edit_adprefsini,
        },
        files_custom => {
            'WINDOWS/ADMODULE.ADS' => \&extra_admodule,
            'WINDOWS/MESSAGES.ADS' => \&extra_messages,
        },
        dosbox => {
            start  => 76000,
            cycles => 3000,
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
        next if $realname eq 'Randomizer';
        $modules{$realname} = $filename;
    }

    # Pick da winna
    my $module = _pick( keys %modules );

    # Set config options
    my $sound   = 0;
    my $cfg     = '';
    my $cfg_str = '';
    for ( my $i = 0 ; $i < 4 ; $i++ ) {
        my $value;
        my $knob = $controls{$module}[$i];
        if ( defined $knob ) {
            if ( $knob->[0] eq 'Sound' ) {
                $value = 1;
                $sound = 1;
            }
            else {
                $value = int( rand( $knob->[1] + 1 ) );
                $cfg_str .=
                  ", $knob->[0]: $value" . ( $knob->[1] == 100 ? '%' : '' );
            }
        }
        else {
            $value = 0;
        }
        $cfg .= pack( 'v', $value );
    }

    my $self = {
        module       => $module,
        module_file  => $modules{$module},
        settings     => $cfg_str,
        settings_bin => $cfg,
	sound        => $sound,
    };

    return bless( $self, $class );
}

sub detail {
    my $self = shift;

    return "Module: $self->{module}" . $self->{settings};

#return { settings => "Module: $self->{module}" . $self->{settings}, sound => $self->{sound} };
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^load=(.*)$/ ) {
        $line = "load=c:\\afterdrk\\ad.exe c:\\afterdrk\\adinit.exe $1";
    }

    return $line;
}

sub edit_adprefsini {
    my ( $self, $line ) = @_;

    # AD_PREFS.INI to set up the desired module
    if ($line) {
        if ( $line =~ m/^Module=/i ) {
            $line = "Module=$self->{module}";
        }
        elsif ( $line =~ m/^ModuleFile=/i ) {
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

sub extra_messages {
    my ( $self, $input, $output ) = @_;

    # If MESSAGES is picked we have more work to do
    if ( $self->{module} eq 'Messages' ) {
        my $msgnum = int( rand(8) );
        open( my $fpi, '<:raw', $input )  or die "Couldn't open $input: $!";
        open( my $fpo, '>:raw', $output ) or die "Can't open $output file: $!";

        for ( my $i = 0 ; $i < 8 ; $i++ ) {
            read $fpi, my $buf, 246;
            substr( $buf, 44, 2 ) = pack( 'v', ( $i == $msgnum ) );
            print $fpo $buf;
        }
    }
}

1;
