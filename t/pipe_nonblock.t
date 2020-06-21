#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::FailWarnings;

use Sys::Pipe;

use Errno;
use Fcntl;

SKIP: {
    my ($r, $w);

    eval { Sys::Pipe::pipe( $r, $w, Fcntl::O_NONBLOCK() ) } or do {
        skip "No pipe2 support? $@", 1;
    };

    sysread($r, my $buf, 512);
    my $err = 0 + $!;

    is( $err, Errno::EAGAIN(), '$! as expected with non-blocking pipe' );
}

done_testing();
