use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Mojolicious::Plugin::ProRenderer',
    AUTHOR           => q{Sergey Lobin <ifitwasi@gmail.com>},
    VERSION_FROM     => 'lib/Mojolicious/Plugin/ProRenderer.pm',
    ABSTRACT_FROM    => 'lib/Mojolicious/Plugin/ProRenderer.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.010,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'HTML::Template::Pro'   => 0.9509,
        'Mojolicious'           => 3.73,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Mojolicious-Plugin-ProRenderer-*' },
);
