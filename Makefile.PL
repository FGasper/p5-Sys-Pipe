use ExtUtils::MakeMaker;

WriteMakefile(
    NAME           => 'Sys::Pipe',
    VERSION_FROM   => 'lib/Sys/Pipe.pm',
    ABSTRACT_FROM  => 'lib/Sys/Pipe.pm',
    AUTHOR         => 'Felipe Gasper (FELIPE)',
    LICENSE        => 'perl',

    INC => '-Wall -I.',

    PREREQ_PM => {

    },

    TEST_REQUIRES => {

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
