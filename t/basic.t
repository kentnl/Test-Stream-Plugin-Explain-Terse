use strict;
use warnings;

use Test::Stream::Bundle::V1;
use Test::Stream::Plugin::Explain::Terse;
use Test::Stream::Plugin::SRand;
use Data::Dump qw(pp);

# ABSTRACT: Basic self-test

can_ok( __PACKAGE__, 'explain_terse' );

ok( defined( my $result = explain_terse("") ), "explain_terse must return a defined value" );

is( explain_terse("Hello"), '"Hello"', 'short values dump-pass through OK' );

# These have to be random strings because Data::Dump is smart enough to reverse
# "N" x $n  back into a short expression!
my $superstring = join q[], map { mk_grapheme() } 0 .. 50;

my $sub_long        = substr( $superstring, 0, 80 - 2 );        # minus 2 because pp adds quotes.
my $super_long      = substr( $superstring, 0, 81 - 2 );
my $super_long_wrap = substr( $superstring, 0, 80 - 2 - 3 );    # minus 3 for elipsis

{
  my $pp = pp($sub_long);
  note "length(pp(item)) <= 80:" . $pp . "=" . length($pp);
}
for ( explain_terse($sub_long) ) {
  note $_;
  ok( defined, 'is defined' ) or last;
  cmp_ok( length, '<=', 80, "Length <= 80" ) or last;
  is( $_, qq["$sub_long"], 'dumps under MAX_LENGTH pass through OK' ) or last;
}
{
  my $pp = pp($super_long);
  note "length(pp(item)) > 80:" . $pp . "=" . length($pp);
}
for ( explain_terse($super_long) ) {
  note $_;
  ok( defined, 'is defined' ) or last;
  cmp_ok( length, '<=', 80, "Length <= 80" ) or last;
  cmp_ok( $_, 'ne', qq["$sub_long"], 'dumps over MAX_LENGTH do not go unmolested' ) or last;
  is( $_, qq["$super_long_wrap..."], 'dumps over MAX_LENGTH warp as expected' ) or last;
}

done_testing;

my ( @CONS, @VOLS );

BEGIN {
  @CONS = qw( B C D F G H J K L M N P Q R S T V W X Y Z );
  @VOLS = qw( a e i o u );
}

sub mk_grapheme { $CONS[ int( rand() * $#CONS ) ] . $VOLS[ int( rand() * $#VOLS ) ] }
