use Alien::graphviz;
use ExtUtils::MakeMaker;
use Alien::Base::Wrapper qw( Alien::graphviz !export );

WriteMakefile(
    AUTHOR => ['Ed J <etj at cpan.org>'],
    NAME => 'GraphViz::FFI',
    ABSTRACT_FROM => "lib/GraphViz/FFI.pm",
    VERSION_FROM => "lib/GraphViz/FFI.pm",
    LICENSE => "artistic_2",
    Alien::Base::Wrapper->mm_args,
    CONFIGURE_REQUIRES => {
        'Alien::graphviz' => 0
    },
    PREREQ_PM => {
        'FFI::Platypus' => 0,
        'Alien::graphviz' => 0,
        'Exporter' => '5.57', # importable 'import'
    },
    TEST_REQUIRES => {
        'Test::More' => 0,
    },
    META_MERGE => {
        "meta-spec" => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url => 'git://github.com/graphviz-perl/GraphViz-FFI.git',
                web => 'https://github.com/graphviz-perl/GraphViz-FFI',
            },
            bugtracker => {
                web => 'https://github.com/graphviz-perl/GraphViz-FFI/issues',
            },
        },
    },
);
