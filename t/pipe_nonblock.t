#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::FailWarnings;

use Sys::Pipe;

use Errno;
use Fcntl;

use IO::File;

SKIP: {
    my ($r, $w);

    eval { Sys::Pipe::pipe( $r, $w, Fcntl::O_NONBLOCK() ) } or do {
        skip "No pipe2 support? $@", 1;
    };

    ok( !$r->blocking(), 'non-blocking from the get-go' );
}

done_testing();
