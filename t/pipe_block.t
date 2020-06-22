#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::FailWarnings;

use Sys::Pipe;

use Errno;
use Fcntl;

use IO::File;

{
    Sys::Pipe::pipe( my ($r, $w), 0 ) or die "pipe(): $!";

    ok( $r->blocking(), 'flags=0: blocking from the get-go' );
}

{
    Sys::Pipe::pipe( my ($r, $w) ) or die "pipe(): $!";

    ok( $r->blocking(), 'no flags: blocking from the get-go' );
}

done_testing();
