use strict;
use warnings;

use Test::Stream::Bundle::V1 'Explain::Terse' => [];
use Text::Wrap;

# ABSTRACT: Basic self-test

ok( $INC{'Test/Stream/Plugin/Explain/Terse.pm'}, "Load plugin ok" ) or do {
  diag( "[" . wrap( " ", " ", join qq[, ], sort keys %INC ) . "]" );
};

can_ok( __PACKAGE__, 'explain_terse' );

ok( defined( my $result = explain_terse("") ), "explain_terse must return a defined value" );

done_testing;

