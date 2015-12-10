use 5.006;    # our
use strict;
use warnings;

package Test::Stream::Plugin::Explain::Terse;

our $VERSION = '0.001000';

# ABSTRACT: Dump anything in a single line less than 80 characters

# AUTHORITY

use Test::Stream::Exporter qw/ default_exports import /;

default_exports qw/ explain_terse /;

=func C<explain_terse>

  my $data = explain_terse($structure);

Returns C<$structure> pretty printed and compacted to be less than 80
characters long.

=cut

sub explain_terse {
  return q[];
}

1;

=head1 DESCRIPTION

This module aims to provide a simple tool for adding trace-level details
about data-structures to the TAP stream to visually keep track of what is being
tested.

Its objective is to not be comprehensive, and only be sufficient for a quick
visual sanity check, allowing you to visually spot obviously wrong things at a
glance without producing too much clutter.

It is expected that if C<Explain::Terse> produces a data structure that needs
compacting for display, that the user will also be performing sub-tests on that
data structure, and those sub-tests will trace their own context closer to the
actual test.

  # Checking: { a_key => ["a value"], b_key => ["b value'], ... }
    # Subtest: c_key is expected
    # Checking: ["c value"]
    ok 1 - c_key's array has value "c value"
    1..1
  ok 1 - c_key is expected

The idea being the higher up in the data structure you're doing the comparison,
the less relevant the individual details are to that comparison, and the actual
details only being relevant in child comparisons.

This is obviously also better if you're doing structurally layered comparison,
and not simple path-based comparisons, e.g:

  # Not intended to be used this way.
  note explain_terse(\%hash);
  is( $hash{'key'}{'otherkey'}{'finalkey'}, 'expected_value' );

And you want something like:

  note explain_terse(\%hash);
  ok( exists $hash{'key'}, 'has q[key]')
    and subtest "key structure" => sub {

      my $structure = $hash{'key'};
      note explain_terse($structure);
      is( ref $structure, 'HASH', 'is a HASH' )
        and ok( exists $structure->{'otherkey'}, 'has q[otherkey]' )
        and subtest "otherkey structure" => sub {

          my $substructure = $structure->{'otherkey'};
          note explain_terse($substructure);
          is( ref $substructure, 'HASH', 'is a HASH' )
            and ok( exists $structure->{'finalkey'}, 'has final key' )
            and subtest "finalkey structure" => sub {

              my $final_structure = $substructure->{'finalkey'};
              note explain_terse($final_structure);
              ok( !ref $final_structure, "finalkey is not a ref")
                and ok( defined $final_structure, "finalkey is defined")
                and is( $final_structure, 'expected_value', "finalkey is expected_value" );
          };

      };
  };

Though of course you'd not want to write it like that directly in your tests,
you'd probably want something more like

  with(\%hash)->is_hash->has_key('key', sub {
      with($_[0])->is_hash->has_key('otherkey', sub {
        with($_[0])->is_hash->has_key('finalkey', sub {
          with($_[0])->is_scalar->defined->is_eq("expected_value");
        });
      });
  });

Or

  cmp_deeply( \%hash, superhashof({
      key => superhashof({
        otherkey => superhashof({
          finalkey => "expeted_value"
        }),
      }),
  }));

And have C<Explain::Terse> operating transparently under the hood of these implementations
so you can see what is happening.
