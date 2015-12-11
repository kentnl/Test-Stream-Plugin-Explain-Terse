use strict;
use warnings;

use Test::Stream::Bundle::V1;
use Test::Stream::Plugin::Explain::Terse;
use Test::Stream::Plugin::SRand;
use Test::Stream::Plugin::Subtest;
use Data::Dump qw(pp);

use lib 't/lib';
use T::Grapheme qw/grapheme_str/;

# ABSTRACT: Basic self-test

can_ok( __PACKAGE__, 'explain_terse' );

ok( defined( my $result = explain_terse("") ), "explain_terse must return a defined value" );

is( explain_terse("Hello"), '"Hello"', 'short values dump-pass through OK' );

# These have to be random strings because Data::Dump is smart enough to reverse
# "N" x $n  back into a short expression!
my $superstring = grapheme_str(100);

subtest "dumped string would be >80 normally" => sub {
  my $super_long      = substr( $superstring, 0, 81 - 2 );
  my $super_long_wrap = substr( $superstring, 0, 80 - 2 - 3 );    # minus 3 for elipsis

  my $pp  = pp($super_long);
  my $got = explain_terse($super_long);

  note "Studying: $got";
  note "From: $pp (=" . ( length $pp ) . ")";

  ok( defined $got, 'is defined' ) or last;
  cmp_ok( length $got, '<=', 80, "Length <= 80" ) or last;
  cmp_ok( $got, 'ne', qq["$super_long"], 'dumps over MAX_LENGTH do not go unmolested' ) or last;
  is( $got, qq["$super_long_wrap..."], 'dumps over MAX_LENGTH warp as expected' ) or last;
};
done_testing;

