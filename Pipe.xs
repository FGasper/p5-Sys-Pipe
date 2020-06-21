#define PERL_NO_GET_CONTEXT

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <unistd.h>
#include <fcntl.h>

// For now depend on Perl’s HAS_PIPE2

//#include "ppport.h"

//----------------------------------------------------------------------

static inline char* _cur_pkgname( pTHX ) {
    COP* mycop = PL_curcop;

    // This macro may not be part of the API … but PL_curstash doesn’t
    // work with: perl -e'package Foo; _print_pl_curstash()', whereas
    // PL_curcop does.
    HV* myhv = (HV*)CopSTASH(mycop);

    return HvNAME(myhv);
}

static inline void _fd2sv( pTHX_ int fd, bool is_read, SV* sv ) {
    PerlIO *pio = PerlIO_fdopen(fd, is_read ? "r" : "w");

    GV* gv = newGVgen( _cur_pkgname(aTHX) );
    SvUPGRADE(sv, SVt_IV);
    SvROK_on(sv);
    SvRV_set(sv, (SV*)gv);
    IO* io = GvIOn(gv);

    IoTYPE(io) = is_read ? '<' : '>';
    IoIFP(io) = pio;
    IoOFP(io) = pio;
}

int _pipe( pTHX_ SV* infh, SV* outfh, int flags ) {
#ifdef HAS_PIPE
    int fds[2];

    // int ret = pipe2(fds, flags);
    int ret = pipe(fds);

    if (!ret) {
        if (fds[0] > PL_maxsysfd) {
            fcntl(fds[0], F_SETFD, O_CLOEXEC);
        }
        // Perl_setfd_cloexec_for_nonsysfd(fds[0]);
        // Perl_setfd_cloexec_for_nonsysfd(fds[1]);

        _fd2sv( aTHX_ fds[0], true, infh );
        _fd2sv( aTHX_ fds[1], false, outfh );
    }

    return ret;
#else
    die("No pipe2");
#endif
}

//----------------------------------------------------------------------
//----------------------------------------------------------------------

MODULE = Sys::Pipe          PACKAGE = Sys::Pipe

int
pipe( SV *infh, SV *outfh, int flags = 0 )
    CODE:
        RETVAL = _pipe(aTHX_ infh, outfh, flags);

    OUTPUT:
        RETVAL

void
print_PL_maxsysfd()
    CODE:
        fprintf(stdout, "%d\n", PL_maxsysfd);
