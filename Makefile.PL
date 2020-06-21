use ExtUtils::MakeMaker;

use Config;

my $d_pipe = $Config{'d_pipe'};

if (!$d_pipe) {
    die "OS unsupported (\$Config{d_pipe} == $d_pipe)";
}

WriteMakefile(
    NAME           => 'Sys::Pipe',
    VERSION_FROM   => 'lib/Sys/Pipe.pm',
    ABSTRACT_FROM  => 'lib/Sys/Pipe.pm',
    AUTHOR         => 'Felipe Gasper (FELIPE)',
    LICENSE        => 'perl',

    INC => '-Wall -I.',

    PREREQ_PM => {
        'XSLoader' => 0.14,
    },

    TEST_REQUIRES => {
        'Test::More' => 0,
        'Test::FailWarnings' => 0,
    },
    META_MERGE => {
        'meta-spec' => { version => 2 },
        resources   => {
            bugtracker => {
                web => 'https://github.com/FGasper/p5-Sys-Pipe/issues',
            },
            repository => {
                type => 'git',
                url  => 'https://github.com/FGasper/p5-Sys-Pipe.git',
                web  => 'https://github.com/FGasper/p5-Sys-Pipe',
            },
        },

        recommends => {
        },
    },
);
