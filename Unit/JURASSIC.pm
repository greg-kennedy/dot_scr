package Unit::JURASSIC;
use strict;
use warnings;

sub _pick { return $_[ rand @_ ] }
sub _trim { my $s = shift; $s =~ s/^\s+//; $s =~ s/\s+$//; return $s }

# Info routine: return basic details about this module
sub info {
    return (
        name     => 'JURASSIC',
        fullname => 'Jurassic Park: The Screen Saver',
        author   => 'Asymetrix',
        payload  => ['MCIAAP.zip','VFW11E.zip','JURASSIC.zip'],
        files    => {
            'WINDOWS/SYSTEM.INI'  => \&edit_systemini,
            'WINDOWS/WIN.INI'     => \&edit_winini,

            'WINDOWS/JPSAVER.INI' => \&edit_jpsaver,
            'WINDOWS/MDIABLTZ.INI' => \&edit_mdiabltz,
        },

        # kind of a bummer to hardcode this
        weight => 36,
    );
}

# Create an instance of module.
#  This should also generate settings for a specific run.
sub new {
    my $class    = shift;
    my $basepath = shift;

    my %modules;
    my @choices;

    # open the INI file and parse it to get modules
    open( my $fpi, '<:crlf', "$basepath/WINDOWS/JPSAVER.INI" )
      or die "Couldn't open jpsaver.ini: $!";
    my $section = '';
    my $id  = 0;
    while ( my $line = <$fpi> ) {
      $line = _trim($line);
      if ( $line =~ m/^\[([^\]]+)\]$/ ) {
          $section = uc($1);
      } elsif ( $section eq 'MODULES' ) {
        if ( $line =~ m/^Module(\d+)=(.+)$/ ) {
          my $index = $1 - 1;
          my $modname = $2;
          $modules{$index}{name} = $modname;
        }
      } elsif ( $section =~ m/MODULE(\d+)/ ) {
        my $index = $1 - 1;
        if ( $line =~ m/^Option(\d+)=(.+),(\d),(.+)$/ ) {
          my $optindex = $1 - 1;
          my $playlist = $2;
          my $no_sound = $3;
          my $optname = $4;

          # munge path out of playlist
          $playlist =~ s/[^\\]+$//;
          $modules{$index}{option}{$optindex} = {
            name => $optname,
            path => $playlist,
            sound => ($no_sound ne '1')
          };

          push @choices, [ $index, $optindex ];
        }
      }
    }
    close $fpi;

    my $choice = _pick( @choices );
    my ($mid, $oid) = @{$choice};

    my $self = {
        module_id => $mid,
        module_name => $modules{$mid}{name},
        option_id => $oid,
        option_name => $modules{$mid}{option}{$oid}{name},
        path => $modules{$mid}{option}{$oid}{path},

        dosbox => {
            start => 8000,

            #            cycles => 0
        },
        sound => $modules{$mid}{option}{$oid}{sound},
    };

    return bless( $self, $class );
}

# Return stringified version of settings
sub detail {
    my $self = shift;

    return "Module: $self->{module_name}, Option: $self->{option_name}";
}

##############################################################################
# Edit and Append functions
#  Functions are called with $line,
#  or undef if we are at file-end
sub edit_systemini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
      if ($line =~ m/^SCRNSAVE\.EXE=/i ) {
        $line = "SCRNSAVE.EXE=C:\\WINDOWS\\JPSAVER.SCR";
      } elsif ($line =~ m/^\[MCI\]$/i) {
        # the MCIAAP should have this already, but it gets clobbered by
        #  the vfw11e so we have to add it back.
        $line .= "\nAutodesk=mciaap.drv";
      }
    }
    return $line;
}

sub edit_winini {
    my ( $self, $line ) = @_;

    if ( defined $line ) {
      if ( $line =~ m/^ScreenSaveActive=/i ) {
        $line = "ScreenSaveActive=1";
      } elsif ($line =~ m/^\[MCI EXTENSIONS\]$/i) {
        # same story
        $line .= "\nfli=Autodesk\nflc=Autodesk";
      }
    }

    return $line;
}

sub edit_jpsaver {
    # this is actually a bit off
    #  we are editing option across ALL modules
    # it should still work though because we select
    #  the correct module ID
    my ( $self, $line ) = @_;

    if ( defined $line ) {
      if ($line =~ m/^SelectedModule=/i ) {
        $line = "SelectedModule=$self->{module_id}";
      } elsif ($line =~ m/^SelectedOption=/i ) {
        $line = "SelectedOption=$self->{option_id}";
      }
    }
    return $line;
}

sub edit_mdiabltz {
    my ( $self, $line ) = @_;

    # supposed to set the path to match the main module root
    if ($line && $line =~ m/^path=/i) {
      $line = "path=$self->{path}";
    }

    return $line;
}

1;
