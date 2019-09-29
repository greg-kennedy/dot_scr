#!/usr/bin/env perl
use strict;
use warnings;

die "Usage: $0 ADMODULE.ADS" unless @ARGV == 1;

open( my $fpi, '<:raw', $ARGV[0] )
      or die "Couldn't open $ARGV[0]: $!";
    print "FILENAME     | MODULE_NAME        |ct0|ct1|ct2|ct3|vol|UNKNOWN\n";
    print (("-" x 59) . "\n");
    until ( eof $fpi ) {
        read $fpi, my $buf, 49;
        my ( $filename, $realname, $ct0, $ct1, $ct2, $ct3, $vol, $unknown) = unpack 'Z[13]Z[20]v[5]H*', $buf;

        printf("%13s|%20s|%3d|%3d|%3d|%3d|%3d|%s\n", 
	  $filename, $realname, $ct0, $ct1, $ct2, $ct3, $vol, $unknown );
    }

1;
