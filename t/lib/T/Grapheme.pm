use 5.006;    #our
use strict;
use warnings;

package T::Grapheme;

# ABSTRACT: Generate Pronouncable letter pairs for testing

# AUTHORITY

use Test::Stream::Exporter qw/import default_export/;

default_export qw/grapheme_str/;

my ( @CONS, @VOLS );

BEGIN {
  @CONS = qw( B C D F G H J K L M N P Q R S T V W X Y Z );
  @VOLS = qw( a e i o u );
}

sub mk_grapheme {
  $CONS[ int( rand() * $#CONS ) ] . $VOLS[ int( rand() * $#VOLS ) ];
}

sub grapheme_str {
  substr scalar( join q[], map { mk_grapheme } 0 .. ( ( $_[0] + 1 ) / 2 ) ), 0, $_[0];
}
1;

