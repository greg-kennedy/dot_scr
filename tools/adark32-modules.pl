#!/usr/bin/env perl
use strict;
use warnings;

####
# helper: safe read
#  params: fp, length
sub _rd
{
  my $bytes_read = read $_[0], my $buffer, $_[1];
  die "Short read on file: expected $_[1] but got $bytes_read: $!" unless $bytes_read == $_[1];
  return $buffer;
}

die "Usage: $0 ADMODULE.AS3" unless @ARGV == 1;

open( my $fpi, '<:raw', $ARGV[0] )
      or die "Couldn't open $ARGV[0]: $!";
    #print "FILENAME     | MODULE_NAME        |ct0|ct1|ct2|ct3|vol|UNKNOWN\n";
    #print (("-" x 59) . "\n");
    # read header

    my ($mod_a, $mod_b, $unknown) = unpack 'vvV', _rd($fpi, 8);
    my $len = unpack 'v', _rd($fpi, 2);
    my $title = unpack "Z$len", _rd($fpi, $len);

    print "Title: $title, $mod_b modules\n";

my $i = 0;
    until ( eof $fpi ) {

        $len = unpack 'C', _rd($fpi, 1);
        my $realname = unpack "Z$len", _rd($fpi, $len);
        $len = unpack 'C', _rd($fpi, 1);
        my $filename = unpack "Z$len", _rd($fpi, $len);
	printf( "%02d | %s | %s |", $i, $realname, $filename);
	my $unknown = unpack 'V', _rd($fpi, 4);
	my $volume = unpack 'v', _rd($fpi, 2);
	print " vol=$volume | ";
	my $unk_1 = unpack 'V', _rd($fpi, 4);
	my $unk_2 = unpack 'V', _rd($fpi, 4);
	printf(' %08x %04x %04x | ', $unknown, $unk_1, $unk_2);

	# defaults
        my ( $d_ct0, $d_ct1, $d_ct2, $d_ct3 ) = unpack 'v[4]', _rd($fpi, 8);
	# current settings
        my ( $ct0, $ct1, $ct2, $ct3 ) = unpack 'v[4]', _rd($fpi, 8);

	print "$ct0 / $d_ct0, $ct1 / $d_ct1, $ct2 / $d_ct2, $ct3 / $d_ct3\n";
	# more unknown (sound?)
	_rd($fpi, 3);

	if (!eof $fpi) { _rd($fpi, 0x2) }
	$i ++;
#my ( $filename, $realname, $ct0, $ct1, $ct2, $ct3, $vol, $unknown) = unpack 'Z[13]Z[20]v[5]H*', $buf;

        #printf("%13s|%20s|%3d|%3d|%3d|%3d|%3d|%s\n", 
	  #$filename, $realname, $ct0, $ct1, $ct2, $ct3, $vol, $unknown );
    }

1;
