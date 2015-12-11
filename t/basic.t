use strict;
use warnings;

use Test::Stream::Bundle::V1;
use Test::Stream::Plugin::Explain::Terse;

# ABSTRACT: Basic self-test

can_ok( __PACKAGE__, 'explain_terse' );

ok( defined( explain_terse("") ), "explain_terse must return a defined value" );

is( explain_terse("Hello"), '"Hello"', 'short values dump-pass through OK' );

done_testing;

