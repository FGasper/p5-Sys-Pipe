package Sys::Pipe;

use strict;
use warnings;

our ($VERSION);

use XSLoader ();

BEGIN {
    $VERSION = '0.01';
    XSLoader::load();
}

1;
