use strict;
use warnings;

use Test::Stream::Bundle::V1;
use Test::Stream::Plugin::Explain::Terse;
use Test::Stream::Plugin::SRand;
use Data::Dump qw(pp);

use lib 't/lib';
use T::Grapheme qw( grapheme_str );

{
  note "Dumped structure would span multiple lines normally";

  my $newline_structure = {
    a => grapheme_str(30),
    b => grapheme_str(30),
  };

  my $pp  = pp($newline_structure);
  my $got = explain_terse($newline_structure);
  note "Studying: $got";
  note "From: $pp";

  cmp_ok( ( scalar split qq/\n/, $pp ), q[==], 4, "Dumper unpacks structure into 4 lines by default" ) or last;
  cmp_ok( ( scalar split qq/\n/, $got ), q[==], 1, "Terse uses 1 line" ) or last;

}
done_testing;

