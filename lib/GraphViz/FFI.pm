package GraphViz::FFI;

use strict;
use warnings;
use FFI::Platypus;
use Exporter qw(import);
use Alien::graphviz;

our $VERSION = '0.001';

our @EXPORT_OK;

my %func2sig = (
  gvParseArgs => [ ['opaque','int','int','string[]'] => 'int' ],
  gvPluginsGraph => [ ['opaque'] => 'opaque' ],
  gvLayoutJobs => [ ['opaque','opaque'] => 'int' ],
  gvRenderJobs => [ ['opaque','opaque'] => 'int' ],
  gvNextInputGraph => [ ['opaque'] => 'opaque' ],
  gvFreeLayout => [ ['opaque','opaque'] => 'int' ],
  agclose => [ ['opaque'] => 'int' ],
  agreseterrors => [ [] => 'int' ],
  gvFinalize => [ ['opaque'] => 'void' ],
  gvFreeContext => [ ['opaque'] => 'int' ],
);

@EXPORT_OK = (
  'lt_preloaded_symbols',
  keys %func2sig,
);

my $ffi = FFI::Platypus->new;
use Carp; use Test::More; diag 'RUN ', Test::More::explain [ Alien::graphviz->dynamic_libs ];
$ffi->lib(Alien::graphviz->dynamic_libs);
$ffi->attach($_ => @{ $func2sig{$_} }) for keys %func2sig;

my $lt_p_s = $ffi->find_symbol('lt_preloaded_symbols');
sub lt_preloaded_symbols { $lt_p_s }

=head1 NAME

GraphViz::FFI - FFI interface to Graphviz libraries

=head1 SYNOPSIS

  use GraphViz::FFI qw(
    lt_preloaded_symbols
    gvParseArgs
    gvPluginsGraph
    gvLayoutJobs
    gvRenderJobs
    gvNextInputGraph
    gvFreeLayout
    agclose
    agreseterrors
    gvFinalize
    gvFreeContext
  );
  my $gvc = gvContextPlugins(lt_preloaded_symbols(), 1);
  my @args = ('dot');
  gvParseArgs($gvc, scalar @args, \@args);
  my ($G, $rc);
  if ($G = gvPluginsGraph($gvc)) {
    gvLayoutJobs($gvc, $G);
    gvRenderJobs($gvc, $G);
  } else {
    while (($G = gvNextInputGraph($gvc))) {
      gvLayoutJobs($gvc, $G);
      gvRenderJobs($gvc, $G);
      $rc = MAX($rc, agreseterrors());
      gvFreeLayout($gvc, $G);
      agclose($G);
    }
  }
  gvFinalize($gvc);
  $r = gvFreeContext($gvc);
  return MAX($rc, $r);
  sub MAX { $_[0] > $_[1] ? $_[0] : $_[1] }

=head1 DESCRIPTION

Allows a Perl programme to access Graphviz functionality without having
to use the command-line interface.

=head1 SEE ALSO

L<FFI::Platypus>

L<Alien::graphviz>

L<GraphViz2>

=cut

1;
