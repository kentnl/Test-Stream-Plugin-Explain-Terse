use strict;
use warnings;

use Test::Stream::Bundle::V1;
use Test::Stream::Plugin::Explain::Terse;
use Data::Dump qw(pp);

{
  note "Some dumpers might not fold literal newlines, but we must";

  my $newline_text = "Hello\nWorld";
  my $pp           = pp($newline_text);
  my $got          = explain_terse($newline_text);

  is( $pp,  q["Hello\nWorld"], "Dumper uses qq expression for \\n" ) or last;
  is( $got, q["Hello\nWorld"], "Newlines come through intact" )      or last;

}
done_testing;

