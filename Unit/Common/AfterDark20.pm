package Unit::Common::AfterDark20;
use strict;
use warnings;

# Common tools for working with After Dark 2.0 modules
our %dosbox = (
  start  => 15000,
  cycles => 6000
);

# Do configuration and pack into ADMODULE.ADS format
sub configure {
  my $controls = shift;

  my $settings    = '';
  my $description = '';
  my $sound;

  # Configuration only happens for non-MultiModule entries
  if ( !$controls ) {
    $settings    = pack( 'v[5]', 0, 0, 0, 0, 5 );
    $description = " (MultiModule, no settings)";
    $sound       = 1;
  } else {

    # copy sound setting from parent
    if ( $controls->{sound} ) {
      $sound = 1;
    }

    # Set other 4 config options
    for my $i ( 0 .. 3 ) {
      my $value;

      my $knob = $controls->{cfg}[$i];
      if ( defined $knob ) {
        if ( $knob->[0] eq 'Music' ) {

          # Special case for Disney music slider,
          #  which should always play 100%
          $value = 100;
        } else {

          # Value is an array min/max
          #  Pick something in the range
          $value = int( rand( $knob->[1] + 1 ) );

          #  Add to the description
          $description .= ", $knob->[0]: $value";

          #  if peak is 100, this was a slider 0-100%
          if ( $knob->[1] == 100 ) { $description .= '%' }
        }
      } else {

        # Blank spot on the config menu
        $value = 0;
      }
      $settings .= pack( 'v', $value );
    }

    # always set volume to 5 (max)
    $settings .= pack( 'v', 5 );
  }

  return ( $settings, $description, $sound );
}

# Pull module name and filename from ADMODULE.ADS, return array of both.
#  An array of "known modules" is accepted and checked to ensure full coverage.
sub get_module_names {
  my $input = shift;

  my %known_modules = map { $_ => 1 } @_;

  my %modules;

  open( my $fpi, '<:raw', $input ) or die "Couldn't open '$input': $!";
  until ( eof $fpi ) {
    my $buf;
    my $bytes_read = read( $fpi, $buf, 49 );

    die "Short read on $input: expected 49, got $bytes_read"
      unless $bytes_read == 49;

    my ( $filename, $name ) = unpack 'Z[13]Z[20]x[16]', $buf;

    if ( exists $known_modules{$name} ) {
      delete $known_modules{$name};
      $modules{$name} = $filename;
    } else {
      print "Skipping unknown module '$name' in ADMODULES.ADS\n";
    }
  }

  foreach my $missed ( keys %known_modules ) {
    print "Expected module '$missed' not found in ADMODULES.ADS\n";
  }

  return %modules;
}

# Alters ADMODULE.ADS to make settings changes for our picks
#  Takes input and output path, module name, and settings string.
#  Writes and closes files as needed.
# Dies with error if module name was never matched.
sub set_admodule_ads {
  my ( $input, $output, $name, $settings ) = @_;

  my $matched;

  open( my $fpi, '<:raw', $input )  or die "Couldn't open input '$input': $!";
  open( my $fpo, '>:raw', $output ) or die "Couldn't open output '$output': $!";

  until ( eof $fpi ) {
    my $buf;
    my $bytes_read = read( $fpi, $buf, 49 );

    die "Short read on $input: expected 49, got $bytes_read"
      unless $bytes_read == 49;

    my $ads_name = unpack 'x[13]Z[20]x[16]', $buf;

    if ( $name eq $ads_name ) {
      substr( $buf, 33, length($settings) ) = $settings;
      $matched = 1;
    }

    print $fpo $buf;
  }

  die "Did not find module '$name' in $input" unless $matched;
}

# HELPER functions for editing config files
sub edit_systemini {
  my ( undef, $line ) = @_;

  # After Dark 2.0 has a 386Enh driver that needs loading.
  #  Append it immediately after the 386Enh header.
  if ( defined $line ) {
    if ( $line =~ m/^\[386Enh\]$/i ) {
      $line .= "\ndevice=ad.386";
    } elsif ( $line =~ m/^SCRNSAVE\.EXE=/i ) {
      # After Dark (core) has an SSADARK.SCR which can trigger the saver
      #  from the Windows control panel.  Use it, since it's faster than
      #  waiting for AD.EXE's full 1 minute delay.
      $line = "SCRNSAVE.EXE=C:\\WINDOWS\\SSADARK.SCR";
    }
  }

  return $line;
}

sub edit_winini {
  my ( undef, $line ) = @_;

  if ($line) {
    if ( $line =~ m/^load=(.*)$/ ) {
      $line = "load=c:\\afterdrk\\ad.exe c:\\afterdrk\\adinit.exe $1";
    } elsif ( $line =~ m/^ScreenSaveActive=/i ) {
      $line = "ScreenSaveActive=1";
    }
  }

  return $line;
}

1;
