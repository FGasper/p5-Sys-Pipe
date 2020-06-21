#define PERL_NO_GET_CONTEXT

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <unistd.h>
#include <fcntl.h>

#include <stdbool.h>

// CopSTASH may not be part of the API … but PL_curstash doesn’t
// work with “perl -e'package Foo; _print_pl_curstash()'”, whereas
// PL_curcop does.
#define SP_CUR_STASH ( (HV*)CopSTASH(PL_curcop) )

#define SP_CUR_PKGNAME HvNAME( SP_CUR_STASH )

// For now depend on Perl’s HAS_PIPE2

//#include "ppport.h"

//----------------------------------------------------------------------

static inline void _fd2sv( pTHX_ int fd, bool is_read, SV* sv ) {
    PerlIO *pio = PerlIO_fdopen(fd, is_read ? "r" : "w");

    GV* gv = newGVgen( SP_CUR_PKGNAME );
    IO* io = GvIOn(gv);

    SvUPGRADE(sv, SVt_IV);
    SvROK_on(sv);
    SvRV_set(sv, (SV*)gv);

    IoTYPE(io) = is_read ? '<' : '>';
    IoIFP(io) = pio;
    IoOFP(io) = pio;
}

int _sp_pipe( pTHX_ SV* infh, SV* outfh, int flags ) {
    int fds[2];

#ifdef HAS_PIPE2
    int ret = pipe2(fds, flags);
#elif defined(HAS_PIPE)
    if (flags != 0) {
        croak("This system lacks pipe2 support, so pipe() cannot accept flags.");
    }

    int ret = pipe(fds);
#else
    assert(0);
#endif

    if (!ret) {

        // These don’t seem to be available to extensions,
        // but apparently they’re unneeded anyway.
        //
        // Perl_setfd_cloexec_for_nonsysfd(fds[0]);
        // Perl_setfd_cloexec_for_nonsysfd(fds[1]);

        _fd2sv( aTHX_ fds[0], true, infh );
        _fd2sv( aTHX_ fds[1], false, outfh );
    }

    return ret;
}

//----------------------------------------------------------------------
//----------------------------------------------------------------------

MODULE = Sys::Pipe          PACKAGE = Sys::Pipe

PROTOTYPES: DISABLE

SV*
pipe( SV *infh, SV *outfh, int flags = 0 )
    CODE:
        if (_sp_pipe(aTHX_ infh, outfh, flags)) {
            RETVAL = &PL_sv_undef;
        }
        else {
            RETVAL = newSVuv(1);
        }

    OUTPUT:
        RETVAL

