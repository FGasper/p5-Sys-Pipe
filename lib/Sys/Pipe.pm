package Sys::Pipe;

use strict;
use warnings;

=encoding utf-8

=head1 NAME

Sys::Pipe - C<pipe2()> in Perl

=head1 SYNOPSIS

    Sys::Pipe::pipe( my $r, my $w, O_NONBLOCK ) or die "pipe: $!";

=head1 DESCRIPTION

Ever wish you could create a pipe that starts out non-blocking?
Linux and a number of other modern OSes can do this via the C<pipe2()>
system call; this little library exposes that functionality.

=head1 WHAT’S THE POINT OF THIS?

As shown above, this exposes the ability to create a pipe that starts
out non-blocking. If that’s all you need, then the gain here is mostly just
tidiness. It I<is> also faster than doing:

    pipe my $r, my $w or die "pipe: $!";
    $r->blocking(0);
    $w->blocking(0);

… but the above is already quite fast, so that seems unlikely to make a
real-world difference.

In Linux, this also exposes the ability to create a “packet mode” pipe.
See L<pipe2(2)> for more details.

=head1 FUNCTIONS

=head2 $success_yn = pipe( READHANDLE, WRITEHANDLE [, FLAGS] )

A drop-in replacement for Perl’s C<pipe()> built-in that optionally
accepts a numeric I<FLAGS> argument. See your system’s L<pipe2(2)>
documentation for what values you can pass in there.

Note that if I<FLAGS> is nonzero on any system (e.g., macOS) that
lacks C<pipe2()> an exception is thrown.

=cut

our ($VERSION);

use XSLoader ();

BEGIN {
    $VERSION = '0.01';
    XSLoader::load();
}

1;
