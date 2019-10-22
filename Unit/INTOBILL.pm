package Unit::INTOBILL;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ]; }

# Opus n Bill Brain Saver
#  based on Delrina Intermission 4.0
# Most modules are .ASA animation files, and don't
#  need any config.  For the rest, defaults are good.
#  See ANTSW.INI in payload/WINDOWS.

my @modules = (
  'OB-Basselope',
  'OB-Brief Insights',
  'OB-Bungee',
  'OB-Death Toasters',
  'OB-Fish Bowl',
  'OB-Full Moon',
  'OB-Microboost 10,000',
  'OB-Night Cat',
  'OB-Opus Clock',
  'OB-Penguins',
  'OB-Puddy Passion',
  'OB-Quality Time',
  'OB-Silicone Bill',
  'OB-Swinger',
  'OB-System Bugs',
  'OB-Velociraptor',
);

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'INTOBILL',
        fullname => "Opus 'n Bill Brain Saver",
        author   => 'Delrina Software',
        payload  => ['INTOBILL.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI' => \&edit_systemini,
            'WINDOWS/WIN.INI'    => \&edit_winini,
            'WINDOWS/ANTSW.INI'  => \&edit_antswini,
        },

        weight => scalar @modules,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    # parse the module input file
    #  antsw.ini is annoying because it uses Saver Selected=offset
    #  into the Intermission Extensions list
    # so we need the IDs...
    my %data;
    for (my $i = 0; $i < scalar @modules; $i ++)
    {
      $data{$modules[$i]}{offset} = $i;
    }

    open( my $fpi, '<:crlf', "$basepath/WINDOWS/ANTSW.INI" )
      or die "Couldn't open antsw.ini: $!";
    my $sec = '';
    my $id  = 0;
    while ( my $line = <$fpi> ) {
        if ( $line =~ m/\[Intermission Extensions\]/i ) {
            $sec = 'ext';
        } elsif ( $line =~ m/^\[/ ) {
            $sec = '';
        } elsif ( $sec eq 'ext' ) {
            if ( $line =~ m/^(.+)=(.+)$/ ) {
                my $ini_modfilename = $1;
                my ( $ini_modunknown, $ini_modname ) = split /~/, $2;
                if ( exists $data{$ini_modname} ) {
                    $data{$ini_modname}{id} = $id;
                    $data{$ini_modname}{filename} = $ini_modfilename;
                } else {
                    print "Skipping unknown module $ini_modname ($ini_modfilename)\n";
                }
                $id++;
            }
        }
    }
    close $fpi;

    # choose module (name)
    my $module = _pick( keys %data );
    if ( !defined $data{$module}{id} ) {
        die "Error: selected module $module but no ID exists!";
    }

    my $self = {
        module      => $module,
	module_file => $data{$module}{filename},
        id          => $data{$module}{id},
        offset      => $data{$module}{offset},
        sound       => 1,
        dosbox => {
            start  => 8000,
#            cycles => 5000
        },
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    #module names all start with "DB-"
    my $name = substr $self->{module}, 3;
    return "Module: " . $name;
}

##############################################################################

sub edit_systemini {
    my ( $self, $line ) = @_;

    # append the 386 driver
    if ( $line && $line =~ m/^\[386Enh\]$/i ) {
        $line .= "\ndevice=ANTHOOK.386";
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( $line && $line =~ m/^load=(.*)$/ ) {
        $line = "load=c:\\saver\\intermis.exe $1";
    }

    return $line;
}

sub edit_antswini {
    my ( $self, $line ) = @_;

    # AS FAR AS I KNOW, the only one of these necessary is Saver Offset.
    #  But set the rest anyway.
    if ( $line ) {
      if ( $line =~ m/^Saver Selected=/i ) {
          $line = "Saver Selected=$self->{id}";
	} elsif ($line =~ m/^Saver Offset=/i) {
	  $line = "Saver Offset=$self->{offset}"
	} elsif ($line =~ m/^Last Saver=/i) {
	  $line = "Last Saver=$self->{module_file}"
	} elsif ($line =~ m/^Last Module=/i) {
	  $line = "Last Module=$self->{module}"
	}
    }

    return $line;
}

1;

