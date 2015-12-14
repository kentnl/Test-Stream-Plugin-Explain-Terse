use strict;
use warnings;

use Test::Stream::Bundle::V1 'Explain::Terse', 'Core' => [ qw( ok can_ok done_testing diag ) ];

# ABSTRACT: Make sure the magic Test::Stream API works with us.

ok( $INC{'Test/Stream/Plugin/Explain/Terse.pm'}, "Load plugin ok" ) or do {
  diag( "[" . wrap( " ", " ", join qq[, ], sort keys %INC ) . "]" );
};

can_ok( __PACKAGE__, 'explain_terse' );

done_testing;
