/*
 * Goblin framebuffer - defines.
 *
 * Copyright (C) 2000 Jakub Jelinek (jakub@redhat.com)
 * Copyright (C) 2022 Romain Dolbeau <romain@dolbeau.org>
 *
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * JAKUB JELINEK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifndef GOBLIN_H
#define GOBLIN_H

#include "xf86.h"
#include "xf86_OSproc.h"
#include "xf86RamDac.h"
#include <X11/Xmd.h>
#include "gcstruct.h"
#include "goblin_regs.h"
#include "xf86sbusBus.h"
#include "exa.h"

/* Various offsets in virtual (ie. mmap()) spaces Linux and Solaris support. */
#define GOBLIN_FBC_VOFF	      0x70000000
#define	JARETH_REG_VOFF	      0x70001000
#define	JARETH_MICROCODE_VOFF 0x70002000
#define	JARETH_REGFILE_VOFF	  0x70003000
#define GOBLIN_RAM_VOFF	      0x70016000

typedef struct {
	unsigned int fg, bg;			/* FG/BG colors for stipple */
	unsigned int patalign;                  /* X/Y alignment of bits */
        unsigned int alu;			/* Transparent/Opaque + rop */
        unsigned int bits[32];                  /* The stipple bits themselves */
} GoblinStippleRec, *GoblinStipplePtr;

typedef struct {
	int type;
	GoblinStipplePtr stipple;
} GoblinPrivGCRec, *GoblinPrivGCPtr;

typedef struct {
	unsigned char	*fb;
	GoblinFbcPtr	fbc;
	JarethRegPtr    jreg;
	JarethMicrocodePtr jmicrocode;
	JarethRegfilePtr   jregfile;
	int		width;
	int		height;
	int		maxheight;
	int		vidmem;
	sbusDevicePtr	psdp;
	Bool		NoAccel;
	CloseScreenProcPtr CloseScreen;
	OptionInfoPtr	Options;
	Bool    has_accel;

	ExaDriverPtr	pExa;
	uint32_t	last_mask;
	uint32_t	last_rop;
	uint32_t    fg;
	int		xdir, ydir;
	uint32_t	srcoff, srcpitch;
	int fill_off, fill_len;
	int fillrop_off, fillrop_len;
	int copy_off, copy_len;
	int copyrev_off, copyrev_len;
} GoblinRec, *GoblinPtr;

extern int  GoblinScreenPrivateIndex;
extern int  GoblinGCPrivateIndex;
extern int  GoblinWindowPrivateIndex;

#define GET_GOBLIN_FROM_SCRN(p)    ((GoblinPtr)((p)->driverPrivate))

#define GoblinGetScreenPrivate(s)						\
((GoblinPtr) (s)->devPrivates[GoblinScreenPrivateIndex].ptr)

#define GoblinGetGCPrivate(g)						\
((GoblinPrivGCPtr) (g)->devPrivates [GoblinGCPrivateIndex].ptr)

#define GoblinGetWindowPrivate(w)						\
((GoblinStipplePtr) (w)->devPrivates[GoblinWindowPrivateIndex].ptr)
                            
#define GoblinSetWindowPrivate(w,p) 					\
((w)->devPrivates[GoblinWindowPrivateIndex].ptr = (pointer) p)

extern int goblinRopTable[];

int GOBLINAccelInit(ScrnInfoPtr);
Bool GoblinDGAInit(ScreenPtr);
int GOBLINEXAInit(ScreenPtr);

#ifdef __NetBSD__
#include <dev/sun/fbio.h>
#include <sys/ioccom.h>
#define GOBLIN_SET_PIXELMODE	_IOW('M', 3, int)
#define JARETH_FN_NUM_FILL       0
#define JARETH_FN_NUM_FILLROP    1
#define JARETH_FN_NUM_COPY       2
#define JARETH_FN_NUM_COPYREV    3
struct jareth_fn {
	int off;
	int len;
};
#define JARETH_FN   _IOWR('j', 0, struct jareth_fn)
#else
#define GOBLIN_SET_PIXELMODE	(('M' << 8) | 3)
#error "toto"
#endif

#endif /* GOBLIN_H */
