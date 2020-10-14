use Test::More;
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
use File::Temp qw(tempdir);
use File::Spec;

my $dir = tempdir( CLEANUP => 1 );
my $infile = File::Spec->catfile($dir, 'in.gv');
{
open my $fh, '>', $infile or die "$infile: $!";
print $fh 'digraph { a -> b }';
}
my $outfile = File::Spec->catfile($dir, 'out.svg');

isnt lt_preloaded_symbols(), undef, 'defined lt_p_s';
my $gvc = gvContextPlugins(lt_preloaded_symbols(), 1);
my @args = ('dot', '-Tsvg', $infile, "-o$outfile");
gvParseArgs($gvc, scalar @args, \@args);
my ($G, $rc);
if ($G = gvPluginsGraph($gvc)) {
  gvLayoutJobs($gvc, $G);
  gvRenderJobs($gvc, $G);
} else {
  while (($G = gvNextInputGraph($gvc))) {
    gvLayoutJobs($gvc, $G);
    gvRenderJobs($gvc, $G);
    $rc ||= agreseterrors();
    gvFreeLayout($gvc, $G);
    agclose($G);
  }
}
gvFinalize($gvc);
$r = gvFreeContext($gvc);

is $r, 0, 'freed gvc';
is $rc, 0, 'exit 0';

my $svg = do { local $/; open my $fh, '<', $outfile or die "$outfile: $!"; <$fh> };
like $svg, qr/<\/svg>/i, 'plausible SVG';

done_testing;
