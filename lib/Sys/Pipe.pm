package Sys::Pipe;

use strict;
use warnings;

=encoding utf-8

=head1 NAME

Sys::Pipe - C<pipe2()> in Perl

=head1 SYNOPSIS

    use Fcntl;
    use Sys::Pipe;

    Sys::Pipe::pipe( my $r, my $w, O_NONBLOCK ) or die "pipe: $!";

=head1 DESCRIPTION

Ever wish you could create a pipe that starts out non-blocking?
Linux and a number of other OSes can do this via a proprietary C<pipe2()>
system call; this little library exposes that functionality to Perl.

=head1 WHEN IS THIS USEFUL?

As shown above, this exposes the ability to create a pipe that starts
out non-blocking. If that’s all you need, then the gain here is mostly just
tidiness. It I<is> also faster than doing:

    pipe my $r, my $w or die "pipe: $!";
    $r->blocking(0);
    $w->blocking(0);

… but the above is already quite fast, so that may not make a real-world
difference for you.

In Linux, this also exposes the ability to create a “packet mode” pipe.
Other OSes may allow other functionality. See your system’s L<pipe2(2)>
for more details.

=head1 FUNCTIONS

=head2 $success_yn = pipe( READHANDLE, WRITEHANDLE [, FLAGS] )

A drop-in replacement for Perl’s C<pipe()> built-in that optionally
accepts a numeric I<FLAGS> argument. See your system’s L<pipe2(2)>
documentation for what values you can pass in there.

Note that behavior is currently B<undefined> if I<FLAGS> is nonzero on
any system (e.g., macOS) that lacks C<pipe2()>. (As of this writing an
exception is thrown; that may change eventually.)

=cut

our ($VERSION);

use XSLoader ();

BEGIN {
    $VERSION = '0.01_01';
    XSLoader::load();
}

=head1 COPYRIGHT

Copyright 2020 Gasper Software Consulting. All rights reserved.

=cut

1;
