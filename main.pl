#!/usr/bin/env perl
use strict;
use warnings;

###
# Elaborate screensaver bot thing

use FindBin qw( $RealBin );
use lib $RealBin;

use File::Copy;
use File::Path qw(make_path remove_tree);
use File::Spec;
use IO::Uncompress::Unzip qw($UnzipError);

use Twitter::API;
use Scalar::Util 'blessed';
use Module::Load;

##############################################################################
# CONFIG
##############################################################################
my $dbpath  = '/home/user/.dosbox';    # Path to your DOSBox local folder
my $tmppath = '/tmp/dosbox';           # Temp location for all staging
my $cfgname = 'dosbox-0.74-3.conf';

##############################################################################
# HELPERS
##############################################################################
# Unzip a file to a directory
sub deploy {
    my ( $file, $dest ) = @_;

    print "Unzipping $file into $dest...\n";
    my $u = IO::Uncompress::Unzip->new($file)
      or die "Cannot open $file: $UnzipError";

    my $status;
    while ( ( $status = $u->nextStream() ) > 0 ) {
        my $header = $u->getHeaderInfo();

        #print " . " . $header->{Name} . "...\n";
        my ( undef, $path, $name ) = File::Spec->splitpath( $header->{Name} );

        my $destdir = File::Spec->catdir( $dest, $path );
        unless ( -d $destdir ) {
            make_path($destdir) or die "Couldn't mkdir $destdir: $!";
        }

        next unless $name;

        my $destfile = File::Spec->catfile( $dest, $path, $name );

        my $buff;
        open( my $fpo, '>:raw', "$destfile" )
          or die "failed opening $destfile: $!";
        while ( $u->read($buff) ) {
            print $fpo $buff;
        }
        close $fpo;

        my $stored_time = $header->{Time};
        utime( $stored_time, $stored_time, $destfile )
          or die "Couldn't touch $destfile: $!";
    }

    if ( $status < 0 ) {
        die "Unspecified unzip error: $UnzipError";
    }
}

# Backup a file from $tmpdir/c/... to $tmpdir/source/...
#  Returns a pair: working file, backed-up file
sub make_backup {
    my ( $relname, $tmppath ) = @_;

    # get directory and filename
    my ( undef, $dir, $filename ) = File::Spec->splitpath($relname);

    # Backup file into SOURCES folder
    my $destdir = File::Spec->catdir( $tmppath, 'source', $dir );

    unless ( -d $destdir ) {
        make_path($destdir) or die "Couldn't mkdir $destdir: $!";
    }

    my $workfile = File::Spec->catfile( $tmppath, 'c',      $dir, $filename );
    my $bkupfile = File::Spec->catfile( $tmppath, 'source', $dir, $filename );

    move( $workfile, $bkupfile )
      or die "Couldn't back up file $workfile for edit: $!";

    return ( $workfile, $bkupfile );
}

# Edit an INI file: pass each line to interested units,
#  plus append for anyone who wants it
sub edit {
    my ( $relname, $tmppath, $classes ) = @_;

    # call backup
    my ( $workfile, $bkupfile ) = make_backup( $relname, $tmppath );

    # Actually perform the edits
    open( my $fpo, '>:crlf', $workfile ) or die "failed opening $workfile: $!";
    open( my $fpi, '<:crlf', $bkupfile ) or die "failed opening $bkupfile: $!";

    # trigger edit methods
    while ( my $line = <$fpi> ) {
        chomp $line;
        foreach my $class ( @{$classes} ) {
            my ( $edit_name, $edit_func, $instance ) = @{$class};
            my $new_line = $edit_func->( $instance, $line );
            if ( $new_line ne $line ) {
                print "$relname, "
                  . $edit_name
                  . ": EDIT '"
                  . $line
                  . "' => '"
                  . $new_line . "'\n";
                $line = $new_line;
            }
        }

        print $fpo $line . "\n";
    }
    close $fpi;

    # last call to append stuff
    foreach my $class ( @{$classes} ) {
        my ( $edit_name, $edit_func, $instance ) = @{$class};
        my $append = $edit_func->($instance);
        if ($append) {
            print "$relname, " . $edit_name . ": ADD '" . $append . "'\n";
            print $fpo $append . "\n";
        }
    }
    close $fpo;
}

##############################################################################
# MAIN
##############################################################################
print "WIN31 SCREENSAVERS BOT\n";

######################################
# Get all screensaver objects in one place
print "Loading screensaver units...\n";

my $unit;
if ( @ARGV == 1 ) {
    $unit = 'Unit::' . $ARGV[0];
} else {
    opendir( my $dh, "Unit" );
    my @files = readdir($dh);
    closedir($dh);

    my @units;
    foreach my $file (@files) {
        if ( $file =~ m/^(.+)\.pm$/ ) {
            my $mod_name = 'Unit::' . $1;
            print " . $mod_name\n";
            push @units, $mod_name;
        }
    }
    print 'Found ' . scalar(@units) . " units.\n";

    # Pick today's winner
    $unit = $units[ rand @units ];
}

######################################
# Load the specific unit picked, and create one instance
print "\n=== $unit ===\n";
load $unit;
my %mod_info = $unit->info();

######################################
# Load the theme unit too
print "\n=== Theme ===\n";
load Theme;
my %theme_info = Theme->info();

######################################
# Setup the scratch area
print "Clearing temp path '$tmppath'...\n";
remove_tree( $tmppath, { safe => 1 } );
make_path( "$tmppath/c", "$tmppath/capture", "$tmppath/source" );

# Deploy files
print "Deploying __main__.zip...\n";
deploy( './payload/__main__.zip', "$tmppath/c/" );

foreach my $payload ( @{ $mod_info{payload} } ) {
    print "Deploying $payload...\n";
    deploy( "./payload/$payload" => "$tmppath/c/" );
}

######################################
# Create an instance of the unit and retrieve details
print "\n=== SETTINGS THIS RUN ===\n";
my $saver  = $unit->new( $tmppath . '/c' );
my $detail = $saver->detail();
print $detail . "\n\n";

# Theme too
my $theme = Theme->new( $tmppath . '/c' );
print $theme->detail() . "\n\n";

######################################
# fuck with dosbox conf
{
    open( my $fpo, '>', "$dbpath/$cfgname" )
      or die "failed opening $dbpath/$cfgname: $!";
    open( my $fpi, '<', $cfgname ) or die "failed opening $cfgname: $!";

    # trigger edit methods
    while ( my $line = <$fpi> ) {
        chomp $line;

        if ( $line =~ m/^demostart=/ ) {
            $line = "demostart=" . $mod_info{dosbox}{start};
        } elsif ( $mod_info{dosbox}{cycles} && $line =~ m/^cycles=/ ) {
            $line = "cycles=fixed " . $mod_info{dosbox}{cycles};
        }

        print $fpo $line . "\n";
    }
}

######################################
# Collect all file edits across units
my %edits;

foreach my $file ( keys %{ $mod_info{files} } ) {
    push @{ $edits{$file} },
      [ $mod_info{name}, $mod_info{files}{$file}, $saver ];
}
foreach my $file ( keys %{ $theme_info{files} } ) {
    push @{ $edits{$file} },
      [ $theme_info{name}, $theme_info{files}{$file}, $theme ];
}

# fuck with files
foreach my $file ( keys %edits ) {
    print "EDIT($file)...\n";
    edit( $file, $tmppath, $edits{$file} );
}

# trigger calls for any extra file processing
foreach my $file ( keys %{ $mod_info{files_custom} } ) {
    print "CUSTOM EDIT($file)...\n";

    # call backup
    my ( $workfile, $bkupfile ) = make_backup( $file, $tmppath );
    $mod_info{files_custom}{$file}->( $saver, $bkupfile, $workfile );
}

######################################
# launch dosbox
print "Launching DOSBox\n";
print `SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy ./dosbox` . "\n";

######################################
# ffmpeg the result
print "FFMpeggin'\n";

# compute some limits
my $length =
`ffprobe -v error -select_streams v:0 -show_entries stream=duration -of default=noprint_wrappers=1:nokey=1 $tmppath/capture/krnl386_000.avi`;
chomp $length;
print "Computed video length $length seconds, ";

my $max_file_size  = 8 * 256 * 1024;
my $target_bitrate = int( $max_file_size / $length );
my $audio_bitrate  = $saver->{sound} ? 192 : 0;
my $video_bitrate  = $target_bitrate - $audio_bitrate;
print
  "target video_bitrrate=$video_bitrate k, audio_bitrate=$audio_bitrate k\n";

my $video_line =
    '-c:v libx264 -pix_fmt yuv420p -b:v '
  . $video_bitrate
  . 'k -filter:v scale=iw*2:ih*2:flags=neighbor+full_chroma_inp+full_chroma_int+accurate_rnd';
my $audio_line =
  $saver->{sound} ? '-c:a aac -b:a ' . $audio_bitrate . 'k' : '-an';

my $ffmpeg_line =
"ffmpeg -i $tmppath/capture/krnl386_000.avi $video_line $audio_line $tmppath/capture/krnl386_000.mp4";

print $ffmpeg_line . "\n";
print `$ffmpeg_line` . "\n";

######################################
# shove on Tweeta
die;
print "Posting on Twitter...\n";

# Connect to Twitter

## NOTE: you must supply valid credentials here for application access
my $client = Twitter::API->new_with_traits(
    traits          => qw( NormalizeBooleans DecodeHtmlEntities RetryOnError ),
    consumer_key    => '',
    consumer_secret => '',
    access_token    => '',
    access_token_secret => '',
);

eval {
    my $json;
    my $size = -s "$tmppath/capture/krnl386_000.mp4";

    # INIT req
    my $r = $client->post(
        'https://upload.twitter.com/1.1/media/upload.json',
        {
            command        => 'INIT',
            total_bytes    => $size,
            media_type     => 'video/mp4',
            media_category => 'tweet_video'
        }
    );
    my $media_id = $r->{media_id_string};

    my $bytes;
    open( my $fp, "<:raw", "$tmppath/capture/krnl386_000.mp4" ) or die $!;
    read $fp, $bytes, $size;
    close $fp;

    for ( my $i = 0 ; $i * 5242880 < $size ; $i++ ) {
        print "Uploading part $i...\n";
        my $block = substr $bytes, $i * 5242880, 5242880;
        $r = $client->post(
            'https://upload.twitter.com/1.1/media/upload.json',
            {
                command       => 'APPEND',
                media_id      => $media_id,
                segment_index => $i,
                media         => [
                    undef, "$tmppath/capture/krnl386_000.mp4",
                    Content => $block
                ]
            }
        );
    }

    print "Finalize.\n";
    $r = $client->post(
        'https://upload.twitter.com/1.1/media/upload.json',
        {
            command  => 'FINALIZE',
            media_id => $media_id
        }
    );

    if ( $r->{processing_info} ) {
        while ($r->{processing_info}{state} ne 'failed'
            && $r->{processing_info}{state} ne 'succeeded' )
        {
            print "Status "
              . $r->{processing_info}{state} . ", "
              . ( $r->{processing_info}{progress_percent} || 0 )
              . "% done, sleeping "
              . $r->{processing_info}{check_after_secs} . "\n";
            sleep( $r->{processing_info}{check_after_secs} );
            $r = $client->get(
                'https://upload.twitter.com/1.1/media/upload.json',
                {
                    command  => 'STATUS',
                    media_id => $media_id
                }
            );
        }
    }

    if ( $r->{processing_info}{state} ne 'succeeded' ) {
        die "Upload failed: " . Dumper($r);
    }

    print "Posting tweet!\n";

    # Compose tweet.
    my $post =
        "Name: "
      . $mod_info{fullname}
      . "\nAuthor: "
      . $mod_info{author}
      . "\nSettings: "
      . $detail;

    # Post!
    $r = $client->post( 'statuses/update',
        { status => $post, media_ids => $media_id } );
    my $last_id = $r->{id_str};

    # Add a second "detail" tweet if needed
    my $followup_method = $unit->can('followup');
    if ($followup_method) {
        print "Calling followup method for a second tweet\n";
        my $followup = &$followup_method($saver);
        $client->post(
            'statuses/update',
            {
                status                       => $followup,
                in_reply_to_status_id        => $last_id,
                auto_populate_reply_metadata => 'true'
            }
        );
    }
};

# error handling
if ( my $err = $@ ) {
    die $@ unless blessed $err && $err->isa('Net::Twitter::Lite::Error');

    warn "HTTP Response Code: ", $err->code, "\n",
      "HTTP Message......: ", $err->message, "\n",
      "Twitter error.....: ", $err->error,   "\n";
}
