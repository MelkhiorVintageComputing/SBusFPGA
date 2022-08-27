/*
 * Goblin acceleration support
 *
 * Copyright (C) 2005 Michael Lorenz
 * Copyright (C) 2022 Romain Dolbeau <romain@dolbeau.org>
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
 * MICHAEL LORENZ BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
/* $XFree86$ */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "goblin.h"
#include "goblin_regs.h"
#include "dgaproc.h"

#include <unistd.h>

/* DGA stuff */

// #define DEBUG_GOBLIN 1

#ifdef DEBUG_GOBLIN
//#define ENTER xf86Msg(X_ERROR, "%s>\n", __func__);
#define ENTER
#define DPRINTF xf86Msg
#define RPRINTF xf86Msg
#else
#define ENTER
#define DPRINTF while (0) xf86Msg
#define RPRINTF xf86Msg
#endif

#define arraysize(ary)        (sizeof(ary) / sizeof(ary[0]))

static Bool Goblin_OpenFramebuffer(ScrnInfoPtr pScrn, char **, unsigned char **mem,
    int *, int *, int *);
static Bool Goblin_SetMode(ScrnInfoPtr, DGAModePtr);
static void Goblin_SetViewport(ScrnInfoPtr, int, int, int);
static int Goblin_GetViewport(ScrnInfoPtr);

static void GoblinWaitMarker(ScreenPtr pScreen, int Marker);
static Bool GoblinUploadToScreen(PixmapPtr pDst, int x, int y, int w, int h, char *src, int src_pitch);
static Bool GoblinDownloadFromScreen(PixmapPtr pSrc, int x, int y, int w, int h, char *dst, int dst_pitch);
static Bool GoblinPrepareSolid(PixmapPtr pPixmap, int alu, Pixel planemask, Pixel fg);
static void GoblinSolid(PixmapPtr pPixmap, int x1, int y1, int x2, int y2);
static void GoblinDone(PixmapPtr pDstPixmap);
static Bool GoblinPrepareCopy(PixmapPtr pSrcPixmap, PixmapPtr pDstPixmap, int xdir, int ydir, int alu, Pixel planemask);
static void GoblinCopy(PixmapPtr pDstPixmap, int srcX, int srcY, int dstX, int dstY, int w, int h);
static void GoblinSync(ScrnInfoPtr);

static Bool GoblinCheckComposite(int op, PicturePtr pSrcPicture, PicturePtr pMaskPicture, PicturePtr pDstPicture);
static Bool GoblinPrepareComposite(int op, PicturePtr pSrcPicture, PicturePtr pMaskPicture, PicturePtr pDstPicture, PixmapPtr pSrc, PixmapPtr pMask, PixmapPtr pDst);
static void GoblinComposite(PixmapPtr pDst, int srcX, int srcY, int maskX, int maskY, int dstX, int dstY, int width, int height);

/* internal helper */
static Bool GoblinCheckPicture(PicturePtr pict);


static DGAFunctionRec Goblin_DGAFuncs = {
	Goblin_OpenFramebuffer,
	NULL,
	Goblin_SetMode,
	Goblin_SetViewport,
	Goblin_GetViewport,
	GoblinSync,
	NULL, //Goblin_FillRect,
	NULL, //Goblin_BlitRect,
	NULL
};

static void 
GoblinSync(ScrnInfoPtr pScrn)
{
	//GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
}

Bool
GoblinDGAInit(ScreenPtr pScreen)
{
    ScrnInfoPtr pScrn = xf86Screens[pScreen->myNum];
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    DGAModePtr mode;
    int result;
    
    mode = xnfcalloc(sizeof(DGAModeRec), 1);
    if (mode == NULL) {
        xf86Msg(X_WARNING, "%s: DGA setup failed, cannot allocate memory\n",
            pGoblin->psdp->device);
        return FALSE;
    }
    
    mode->mode = pScrn->modes;
    mode->flags = DGA_PIXMAP_AVAILABLE | DGA_CONCURRENT_ACCESS;
    if(!pGoblin->NoAccel) {
#if 0
        mode->flags |= DGA_FILL_RECT | DGA_BLIT_RECT;
#endif
    }
    
    mode->imageWidth = mode->pixmapWidth = mode->viewportWidth =
	pScrn->virtualX;
    mode->imageHeight = mode->pixmapHeight = mode->viewportHeight =
	pScrn->virtualY;

    mode->bytesPerScanline = mode->imageWidth;

    mode->byteOrder = pScrn->imageByteOrder;
    mode->depth = pScrn->depth;
    mode->bitsPerPixel = pScrn->bitsPerPixel;
    mode->red_mask = pScrn->mask.red;
    mode->green_mask = pScrn->mask.green;
    mode->blue_mask = pScrn->mask.blue;
    
    mode->visualClass = TrueColor;
    mode->address = pGoblin->fb;

    result = DGAInit(pScreen, &Goblin_DGAFuncs, mode, 1);

    if (result) {
    	xf86Msg(X_INFO, "%s: DGA initialized\n",
            pGoblin->psdp->device);
	return TRUE;
    } else {
     	xf86Msg(X_WARNING, "%s: DGA setup failed\n",
            pGoblin->psdp->device);
	return FALSE;
    }
}

static Bool 
Goblin_OpenFramebuffer(ScrnInfoPtr pScrn, char **name,
				unsigned char **mem,
				int *size, int *offset,
				int *extra)
{
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    /*     xf86Msg(X_INFO, "%s: %s\n", pGoblin->psdp->device, __PRETTY_FUNCTION__); */

    *name = pGoblin->psdp->device;

    *mem = (unsigned char*)GOBLIN_RAM_VOFF;
    *size = pGoblin->vidmem;
    *offset = 0;
    *extra = 0;

    return TRUE;
}

static Bool
Goblin_SetMode(ScrnInfoPtr pScrn, DGAModePtr pMode)
{
    /*
     * Nothing to do, we currently only support one mode
     * and we are always in it.
     */
    return TRUE;
}

static void
Goblin_SetViewport(ScrnInfoPtr pScrn, int x, int y, int flags)
{
     /* We don't support viewports, so... */
}

static int
Goblin_GetViewport(ScrnInfoPtr pScrn)
{
    /* No viewports, none pending... */
    return 0;
}


int
GOBLINEXAInit(ScreenPtr pScreen)
{
    ScrnInfoPtr pScrn = xf86Screens[pScreen->myNum];
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    ExaDriverPtr pExa;

    pExa = exaDriverAlloc();
    if (!pExa)
	return FALSE;

    pGoblin->pExa = pExa;

    pExa->exa_major = EXA_VERSION_MAJOR;
    pExa->exa_minor = EXA_VERSION_MINOR;

    pExa->memoryBase = pGoblin->fb;

    pExa->memorySize = pGoblin->vidmem - 32;
    pExa->offScreenBase = pGoblin->width * pGoblin->height * 4; // 32-bits

    /*
     * mmmm, need to think about this
     */
    pExa->pixmapOffsetAlign = 16;
    pExa->pixmapPitchAlign = 16;

    pExa->flags = EXA_OFFSCREEN_PIXMAPS;/*  | EXA_MIXED_PIXMAPS; */ /* | EXA_SUPPORTS_OFFSCREEN_OVERLAPS; */
	
	/*
	 */
    pExa->maxX = 4096;
    pExa->maxY = 4096;

    pExa->WaitMarker = GoblinWaitMarker;

    pExa->PrepareSolid = GoblinPrepareSolid;
    pExa->Solid = GoblinSolid;
    pExa->DoneSolid = GoblinDone;

    pExa->PrepareCopy = GoblinPrepareCopy;
    pExa->Copy = GoblinCopy;
    pExa->DoneCopy = GoblinDone;

    pExa->UploadToScreen = GoblinUploadToScreen;
    pExa->DownloadFromScreen = GoblinDownloadFromScreen;

	if (pGoblin->has_xrender) {
		pExa->CheckComposite = GoblinCheckComposite;
		pExa->PrepareComposite = GoblinPrepareComposite;
		pExa->Composite = GoblinComposite;
		pExa->DoneComposite = GoblinDone;
	}

    return exaDriverInit(pScreen, pExa);;
}

static inline void
GoblinWait(GoblinPtr pGoblin)
{
	uint32_t status = pGoblin->jreg->reg_status;
	int count = 0;
	int max_count = 1000;
	int del = 1;
	const int param = 1;
	const int max_del = 32;

	ENTER;
	
	while ((status & 1) && (count < max_count)) { // & 1 is WORK_IN_PROGRESS_BIT
		count ++;
		usleep(del * param);
		del = del < max_del ? 2*del : del;
		status = pGoblin->jreg->reg_status;
	}

	if (status & 1) { // & 1 is WORK_IN_PROGRESS_BIT
		xf86Msg(X_ERROR, "Jareth wait for idle timed out %08x\n", status);
	} else {
		//xf86Msg(X_INFO, "Jareth: last operation took %d cycles (eng_clk)\n", pGoblin->jreg->cyc_counter);
	}
}

static void
GoblinWaitMarker(ScreenPtr pScreen, int Marker)
{
	ScrnInfoPtr pScrn = xf86Screens[pScreen->myNum];
	GoblinPtr p = GET_GOBLIN_FROM_SCRN(pScrn);

	GoblinWait(p);
}

/*
 * Memcpy-based UTS.
 */
static Bool
GoblinUploadToScreen(PixmapPtr pDst, int x, int y, int w, int h, char *src, int src_pitch)
{
	ScrnInfoPtr pScrn = xf86Screens[pDst->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	char  *dst        = pGoblin->fb + exaGetPixmapOffset(pDst);
	int    dst_pitch  = exaGetPixmapPitch(pDst);

	int bpp    = pDst->drawable.bitsPerPixel;
	int cpp    = (bpp + 7) >> 3;
	int wBytes = w * cpp;

	ENTER;
	DPRINTF(X_INFO, "%s: %d: depth %d x %d y %d w %d h %d src %d %p dst %d 0x%08x %p cpp %d wBytes %d\n", __func__, __LINE__, bpp,
			x, y, w, h,
			src_pitch, src,
			dst_pitch, exaGetPixmapOffset(pDst), dst,
			cpp, wBytes);
	dst += (x * cpp) + (y * dst_pitch);

	GoblinWait(pGoblin);

	while (h--) {
		memcpy(dst, src, wBytes);
		src += src_pitch;
		dst += dst_pitch;
	}
	
	/* __asm("stbar;"); */
	return TRUE;
}

/*
 * Memcpy-based DFS.
 */
static Bool
GoblinDownloadFromScreen(PixmapPtr pSrc, int x, int y, int w, int h, char *dst, int dst_pitch)
{
	ScrnInfoPtr pScrn = xf86Screens[pSrc->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	char  *src        = pGoblin->fb + exaGetPixmapOffset(pSrc);
	int    src_pitch  = exaGetPixmapPitch(pSrc);

	ENTER;
	int bpp    = pSrc->drawable.bitsPerPixel;
	int cpp    = (bpp + 7) >> 3;
	int wBytes = w * cpp;

	src += (x * cpp) + (y * src_pitch);

	GoblinWait(pGoblin);

	while (h--) {
		memcpy(dst, src, wBytes);
		src += src_pitch;
		dst += dst_pitch;
	}

	return TRUE;
}

static Bool
GoblinPrepareSolid(PixmapPtr pPixmap, int alu, Pixel planemask, Pixel fg)
{
	ScrnInfoPtr pScrn = xf86Screens[pPixmap->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	int i;

	ENTER;
	DPRINTF(X_INFO, "%s: %d: bpp: %d, alu %d, pm 0x%08x, Fg 0x%08x\n", __func__, __LINE__, pPixmap->drawable.bitsPerPixel, alu, planemask, fg);
	
	GoblinWait(pGoblin);

	//goblin->jreg->reg_XXXXX = planemask;
	// format rgbx
	pGoblin->jreg->reg_fgcolor = __builtin_bswap32(fg);
	
	pGoblin->last_mask = planemask;
	pGoblin->last_rop = alu;

	pGoblin->jreg->reg_dst_ptr = 0;

	if ((alu == 0x3) && // GXcopy
		(planemask == 0xFFFFFFFF)) { // full patternp
		// fill
		pGoblin->jreg->reg_op = alu;
		pGoblin->jreg->reg_depth = 0; // reset to native
	} else {
		// fillrop
		DPRINTF(X_ERROR, "%s: %d: unsupported: 0x08x, 0x%08x\n", __func__, __LINE__, alu, planemask);
		return FALSE;
	}
	return TRUE;
}

static void
GoblinSolid(PixmapPtr pPixmap, int x1, int y1, int x2, int y2)
{
	ScrnInfoPtr pScrn = xf86Screens[pPixmap->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	int w = x2 - x1, h = y2 - y1, dstoff, dstpitch;
	int start, depth;
	uint32_t ptr;
	ENTER;

	if (pGoblin->last_rop == 5) // GXnoop
		return;
	
	dstpitch = exaGetPixmapPitch(pPixmap);
	dstoff = exaGetPixmapOffset(pPixmap);

	depth = pPixmap->drawable.bitsPerPixel;
	switch (depth) {
		case 32:
			start = dstoff + (y1 * dstpitch) + (x1 << 2);
			break;
		case 8:
			start = dstoff + (y1 * dstpitch) + x1;
			break;
	}

	ptr = 0x8f000000; // fixme!
	ptr += start;

	GoblinWait(pGoblin);

	pGoblin->jreg->reg_width = w;
	pGoblin->jreg->reg_height = h;
	pGoblin->jreg->reg_dst_stride = dstpitch;
	pGoblin->jreg->reg_bitblt_dst_x = x1;
	pGoblin->jreg->reg_bitblt_dst_y = y1;
	
	if (dstoff != 0)
		pGoblin->jreg->reg_dst_ptr = (0x8f000000 + dstoff); // fixme: hw'ired @
	else
		pGoblin->jreg->reg_dst_ptr = 0;

	DPRINTF(X_INFO, "%s: %d: {%d} %d %d %d %d [%d %d], %d %d -> %d (%p: %p) fg: 0x%08x\n", __func__, __LINE__,
			depth,
			x1, y1, x2, y2,
			w, h, dstpitch, dstoff, start, (void*)start, ptr, pGoblin->jreg->reg_fgcolor);

	pGoblin->jreg->reg_cmd = 2; // 1<<DO_FILL_BIT
	
	exaMarkSync(pPixmap->drawable.pScreen);
}

static void GoblinDone(PixmapPtr pDstPixmap) {
}

static Bool
GoblinPrepareCopy(PixmapPtr pSrcPixmap, PixmapPtr pDstPixmap,
		int xdir, int ydir, int alu, Pixel planemask)
{
	ScrnInfoPtr pScrn = xf86Screens[pDstPixmap->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	ENTER;

	pGoblin->srcpitch = exaGetPixmapPitch(pSrcPixmap);
	pGoblin->srcoff = exaGetPixmapOffset(pSrcPixmap);
	pGoblin->xdir = xdir;
	pGoblin->ydir = ydir;

	GoblinWait(pGoblin);

	//goblin->jreg->reg_XXXXX = planemask;
	//goblin->jreg->reg_XXXXX = alu;
	
	pGoblin->last_mask = planemask;
	pGoblin->last_rop = alu;

	if (pGoblin->xdir > 0) {
		if ((alu == 0x3) && // GCcopy
			(planemask == 0xFFFFFFFF)) { // full pattern
			// fill
			pGoblin->jreg->reg_op = alu;
			pGoblin->jreg->reg_depth = 0; // reset to native
		} else {
			// fillrop
			DPRINTF(X_ERROR, "%s: %d: unsupported: 0x08x, 0x%08x\n", __func__, __LINE__, alu, planemask);
			return FALSE;
		}
	} else {
		if ((alu == 0x3) && // GCcopy
			(planemask == 0xFFFFFFFF)) { // full pattern
			// fill
			pGoblin->jreg->reg_op = alu;
			pGoblin->jreg->reg_depth = 0; // reset to native
		} else {
			// fillrop
			DPRINTF(X_ERROR, "%s: %d: unsupported: 0x08x, 0x%08x\n", __func__, __LINE__, alu, planemask);
			return FALSE;
		}
	}
	
	DPRINTF(X_INFO, "%s: %d: alu %d, pm 0x%08x, xdir/ydir %d/%d\n", __func__, __LINE__, alu, planemask, xdir, ydir);
	
	return TRUE;
}

static void
GoblinCopy(PixmapPtr pDstPixmap,
         int srcX, int srcY, int dstX, int dstY, int w, int h)
{
	ScrnInfoPtr pScrn = xf86Screens[pDstPixmap->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	int dstoff = exaGetPixmapOffset(pDstPixmap);
	int dstpitch = exaGetPixmapPitch(pDstPixmap);
	int srcstart, dststart;
	char *src, *dst;
	int i, j;
	ENTER;
	
	srcstart = (srcX << 2) + (pGoblin->srcpitch * srcY) + pGoblin->srcoff;
	dststart = (dstX << 2) + (         dstpitch * dstY) +          dstoff;
#if 1
	//src = (char*)0x8f000000 + srcstart; // fixme: hw'ired @
	//dst = (char*)0x8f000000 + dststart; // fixme: hw'ired @

	/*
	  if (pGoblin->ydir < 0) {
		src += pGoblin->srcpitch * (h-1);
		dst +=          dstpitch * (h-1);
		pGoblin->srcpitch = -pGoblin->srcpitch;
		dstpitch = -dstpitch;
	}
	*/

	GoblinWait(pGoblin);

	pGoblin->jreg->reg_width = w;
	pGoblin->jreg->reg_height = h;
	pGoblin->jreg->reg_src_stride = pGoblin->srcpitch;
	pGoblin->jreg->reg_dst_stride = dstpitch;
	pGoblin->jreg->reg_bitblt_src_x = srcX;
	pGoblin->jreg->reg_bitblt_src_y = srcY;
	pGoblin->jreg->reg_bitblt_dst_x = dstX;
	pGoblin->jreg->reg_bitblt_dst_y = dstY;

	if (pGoblin->srcoff != 0)
		pGoblin->jreg->reg_src_ptr = (0x8f000000 + pGoblin->srcoff); // fixme: hw'ired @
	else
		pGoblin->jreg->reg_src_ptr = 0;
	if (dstoff != 0)
		pGoblin->jreg->reg_dst_ptr = (0x8f000000 + dstoff); // fixme: hw'ired @
	else
		pGoblin->jreg->reg_dst_ptr = 0;

	DPRINTF(X_INFO, "%s: %d: %d %d -> %d %d [%d x %d, %d %d] ; 0x%08x 0x%08x ; %d %d \n", __func__, __LINE__, srcX, srcY, dstX, dstY, w, h, pGoblin->xdir, pGoblin->ydir, pGoblin->srcoff, dstoff, pGoblin->srcpitch, dstpitch);

	pGoblin->jreg->reg_cmd = 1; // 1<<DO_COPY_BIT
	
	exaMarkSync(pDstPixmap->drawable.pScreen);
	
#else
	src = pGoblin->fb + srcstart;
	dst = pGoblin->fb + dststart;
	
	if (pGoblin->ydir > 0) {
		for (j = 0 ; j < h ; j++) {
			memcpy(dst, src, w*4);
			src += pGoblin->srcpitch;
			dst += dstpitch;
		}
	} else if (pGoblin->ydir < 0 ) {
		src += pGoblin->srcpitch * h;
		dst += dstpitch * h;
		for (j = 0 ; j < h ; j++) {
			src -= pGoblin->srcpitch;
			dst -= dstpitch;
			memcpy(dst, src, w*4);
		}
	}
#endif
}

int src_formats[] = {PICT_a8r8g8b8, PICT_x8r8g8b8,
					 PICT_a8b8g8r8, PICT_x8b8g8r8, PICT_a8};
int tex_formats[] = {PICT_a8r8g8b8, PICT_a8b8g8r8, PICT_a8};

static const char* fmt2name(const int fmt) {
	switch (fmt) {
	case PICT_a8r8g8b8: return "PICT_a8r8g8b8";
	case PICT_x8r8g8b8: return "PICT_x8r8g8b8";
	case PICT_a8b8g8r8: return "PICT_a8b8g8r8";
	case PICT_x8b8g8r8: return "PICT_x8b8g8r8";
	case PICT_a8: return "PICT_a8";
	default: return "PICT_Unknown";
	}
}
static const char* op2name(const int op) {
	switch (op) {
	case PictOpClear: return "PictOpClear";
	case PictOpSrc: return "PictOpSrc";
	case PictOpDst: return "PictOpDst";
	case PictOpOver: return "PictOpOver";
	case PictOpOverReverse: return "PictOpOverReverse";
	case PictOpIn: return "PictOpIn";
	case PictOpInReverse:  return "PictOpInReverse";
	case PictOpOut: return "PictOpOut";
	case PictOpOutReverse: return "PictOpOutReverse";
	case PictOpAtop: return "PictOpAtop";
	case PictOpAtopReverse: return "PictOpAtopReverse";
	case PictOpXor: return "PictOpXor";
	case PictOpAdd: return "PictOpAdd";
	case PictOpSaturate: return "PictOpSaturate";
	default: return "PictOpUnknown";
	}
}

static Bool GoblinCheckComposite(int op, PicturePtr pSrcPicture, PicturePtr pMaskPicture, PicturePtr pDstPicture) {
	int i, ok = FALSE;
	
	ENTER;

	/*
	 * Like SX, Goblin is in theory capable of accelerating pretty much all Xrender ops,
	 * even coordinate transformation and gradients.
	 * However someone needs to write all that software...
	 */
	
	if ((op != PictOpOver) &&
		(op != PictOpAdd) &&
		/* (op != PictOpSrc) && */
		/* (op != PictOpOutReverse) && */
		1) {
		RPRINTF(X_ERROR, "%s: %d: rejecting %s (%d)\n", __func__, __LINE__, op2name(op), op);
		return FALSE;
	} else {
		DPRINTF(X_INFO, "%s: %d: accepting %s (%d)\n", __func__, __LINE__, op2name(op), op);
	}

	if (pSrcPicture != NULL) {
		i = 0;
		while ((i < arraysize(src_formats)) && (!ok)) {
			ok =  (pSrcPicture->format == src_formats[i]);
			i++;
		}

		if (!ok) {
			RPRINTF(X_ERROR, "%s: %d: unsupported src format %s (%x)\n",
					__func__, __LINE__, fmt2name(pSrcPicture->format), pSrcPicture->format);
			return FALSE;
		}

		if (!GoblinCheckPicture(pSrcPicture)) {
			return FALSE;
		}
		
		DPRINTF(X_INFO, "%s: %d: src is %s (%x), %s (%d)\n", __func__, __LINE__, fmt2name(pSrcPicture->format), pSrcPicture->format, op2name(op), op);
		//				pSrcPicture->pDrawable->width, 	pSrcPicture->pDrawable->height);
	}

	if (pDstPicture != NULL) {
		i = 0;
		ok = FALSE;
		while ((i < arraysize(src_formats)) && (!ok)) {
			ok =  (pDstPicture->format == src_formats[i]);
			i++;
		}

		if (!ok) {
			RPRINTF(X_ERROR, "%s: %d: unsupported dst format %x\n",
			    __func__, __LINE__, pDstPicture->format);
			return FALSE;
		}

		DPRINTF(X_INFO, "%s: %d: dst is %s (%x), %s (%d)\n", __func__, __LINE__, fmt2name(pDstPicture->format), pDstPicture->format, op2name(op), op);
		//				pDstPicture->pDrawable->width, pDstPicture->pDrawable->height);
	}

	if (pMaskPicture != NULL) {
		if (!GoblinCheckPicture(pMaskPicture)) {
			return FALSE;
		}
		
		DPRINTF(X_INFO, "%s: %d: mask is %s (%x), %d x %d\n", __func__, __LINE__, fmt2name(pMaskPicture->format), pMaskPicture->format,
		    pMaskPicture->pDrawable->width,
		    pMaskPicture->pDrawable->height);
	}
	
	return TRUE;
}

static Bool GoblinCheckPicture(PicturePtr pict) {
	int w, h;

	if (pict->pDrawable) {
		w = pict->pDrawable->width;
		h = pict->pDrawable->height;
	} else {
		if (pict->pSourcePict->type != SourcePictTypeSolidFill) {
			RPRINTF(X_ERROR, "%s: %d: Gradient pictures not supported\n", __func__, __LINE__);
			return FALSE;
		}
		w = 1;
		h = 1;
	}

	if (w >= 4096 || h >= 4096) {
		RPRINTF(X_ERROR, "%s: %d: Picture too large, %d x %d\n", __func__, __LINE__, w, h);
		return FALSE;
	}

	if ((pict->repeat != RepeatNone) &&
		((w != 1) || (h != 1))) {
		RPRINTF(X_ERROR, "%s: %d: Picture is repeating non-trivial\n", __func__, __LINE__);
		return FALSE;
	}

	if (pict->filter) {
		RPRINTF(X_ERROR, "%s: %d: Picture has filter\n", __func__, __LINE__);
		return FALSE;
	}

	if (pict->transform) {
		RPRINTF(X_ERROR, "%s: %d: Picture has transform\n", __func__, __LINE__);
		return FALSE;
	}

	return TRUE;
}

static Bool GoblinPrepareComposite(int op, PicturePtr pSrcPicture, PicturePtr pMaskPicture, PicturePtr pDstPicture, PixmapPtr pSrc, PixmapPtr pMask, PixmapPtr pDst) {
	ScrnInfoPtr pScrn = xf86Screens[pDst->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	
	ENTER;

	pGoblin->no_source_pixmap = FALSE;
	pGoblin->source_is_solid = FALSE;

	if (pSrcPicture->format == PICT_a1) {
		xf86Msg(X_ERROR, "src mono, dst %x, op %d\n",
		    pDstPicture->format, op);
		if (pMaskPicture != NULL) {
			xf86Msg(X_ERROR, "msk %x\n", pMaskPicture->format);
		}
	}
	if (pSrcPicture->pSourcePict != NULL) {
		if (pSrcPicture->pSourcePict->type == SourcePictTypeSolidFill) {
			pGoblin->fillcolour =
			    pSrcPicture->pSourcePict->solidFill.color;
			DPRINTF(X_INFO, "%s: %d: solid src %08x\n", __func__, __LINE__, pGoblin->fillcolour);
			pGoblin->no_source_pixmap = TRUE;
			pGoblin->source_is_solid = TRUE;
		}
	}
	if ((pMaskPicture != NULL) && (pMaskPicture->pSourcePict != NULL)) {
		if (pMaskPicture->pSourcePict->type ==
		    SourcePictTypeSolidFill) {
			pGoblin->fillcolour = 
			   pMaskPicture->pSourcePict->solidFill.color;
			xf86Msg(X_ERROR, "%s: %d: solid mask %08x\n", __func__, __LINE__, pGoblin->fillcolour);
		}
	}
	if (pMaskPicture != NULL) {
		pGoblin->mskoff = exaGetPixmapOffset(pMask);
		pGoblin->mskpitch = exaGetPixmapPitch(pMask);
		pGoblin->mskformat = pMaskPicture->format;
	} else {
		pGoblin->mskoff = 0;
		pGoblin->mskpitch = 0;
		pGoblin->mskformat = 0;
	}
	if (pSrc != NULL) {
		pGoblin->source_is_solid = ((pSrc->drawable.width == 1) && (pSrc->drawable.height == 1));
		pGoblin->srcoff = exaGetPixmapOffset(pSrc);
		pGoblin->srcpitch = exaGetPixmapPitch(pSrc);
		if (pGoblin->source_is_solid) {
			pGoblin->fillcolour = *(uint32_t *)(pGoblin->fb + pGoblin->srcoff);
		}
	}
	pGoblin->srcformat = pSrcPicture->format;
	pGoblin->dstformat = pDstPicture->format;
	
	if (pGoblin->source_is_solid) {
		// init for solid ?
	}
	pGoblin->op = op;

	if ((pGoblin->op == PictOpOver) &&
		(pGoblin->source_is_solid) &&
		(pGoblin->mskformat == PICT_a8) &&
		1) {
		DPRINTF(X_INFO, "%s: %d: A %s (%d) %s _ %s [%d %d _] %s\n", __func__, __LINE__, op2name(op), op, fmt2name(pGoblin->srcformat), fmt2name(pGoblin->dstformat),
				pGoblin->srcpitch, pGoblin->mskpitch, pGoblin->source_is_solid ? "Solid" : "");
		return TRUE;
	}

	if ((pGoblin->op == PictOpOver) &&
		(~pGoblin->source_is_solid) &&
		((pGoblin->srcformat == PICT_x8r8g8b8) || (pGoblin->srcformat == PICT_x8b8g8r8)) &&
		(pGoblin->mskformat == PICT_a8r8g8b8) &&
		1) {
		DPRINTF(X_INFO, "%s: %d: B %s (%d) %s _ %s [%d %d _] %s\n", __func__, __LINE__, op2name(op), op, fmt2name(pGoblin->srcformat), fmt2name(pGoblin->dstformat),
				pGoblin->srcpitch, pGoblin->mskpitch, pGoblin->source_is_solid ? "Solid" : "");
		return TRUE;
	}
	
	if ((pGoblin->op == PictOpAdd) &&
		(pGoblin->srcformat == PICT_a8) &&
		(pGoblin->dstformat == PICT_a8) &&
		(pGoblin->mskformat == 0) &&
		1) {
		DPRINTF(X_INFO, "%s: %d: C %s (%d) %s _ %s [%d %d _] %s\n", __func__, __LINE__, op2name(op), op, fmt2name(pGoblin->srcformat), fmt2name(pGoblin->dstformat),
				pGoblin->srcpitch, pGoblin->mskpitch, pGoblin->source_is_solid ? "Solid" : "");
		return TRUE;
	}
		
	RPRINTF(X_ERROR, "%s: %d: NOT %s (%d) %s _ %s [%d %d _] %s\n", __func__, __LINE__, op2name(op), op, fmt2name(pGoblin->srcformat), fmt2name(pGoblin->dstformat),
			pGoblin->srcpitch, pGoblin->mskpitch, pGoblin->source_is_solid ? "Solid" : "");
	
	return FALSE;
}

static void GoblinComposite(PixmapPtr pDst, int srcX, int srcY, int maskX, int maskY, int dstX, int dstY, int width, int height) {
	ScrnInfoPtr pScrn = xf86Screens[pDst->drawable.pScreen->myNum];
	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
	uint32_t dstoff, dstpitch;
	uint32_t dst, msk, src;
	int flip = 0;
	
	ENTER;
	dstoff = exaGetPixmapOffset(pDst);		
	dstpitch = exaGetPixmapPitch(pDst);

	flip = (PICT_FORMAT_TYPE(pGoblin->srcformat) !=
			PICT_FORMAT_TYPE(pGoblin->dstformat));

	switch (pGoblin->op) {
	case PictOpOver: {
		GoblinWait(pGoblin);
		//pGoblin->jreg->reg_op = (0x80 | PictOpOver | ((flip && !pGoblin->source_is_solid) ? 0x40 : 0)); // xrender operation
		pGoblin->jreg->reg_depth = 0; // or 32 ?
		pGoblin->jreg->reg_width = width;
		pGoblin->jreg->reg_height = height;

		pGoblin->jreg->reg_dst_stride = dstpitch;
		pGoblin->jreg->reg_bitblt_dst_x = dstX;
		pGoblin->jreg->reg_bitblt_dst_y = dstY;
		if (dstoff != 0)
			pGoblin->jreg->reg_dst_ptr = (0x8f000000 + dstoff); // fixme: hw'ired @
		else
			pGoblin->jreg->reg_dst_ptr = 0;
		
		pGoblin->jreg->reg_msk_stride = pGoblin->mskpitch;
		pGoblin->jreg->reg_bitblt_msk_x = maskX;
		pGoblin->jreg->reg_bitblt_msk_y = maskY;
		if (pGoblin->mskoff != 0)
			pGoblin->jreg->reg_msk_ptr = (0x8f000000 + pGoblin->mskoff); // fixme: hw'ired @
		else
			pGoblin->jreg->reg_msk_ptr = 0;
		
		if (pGoblin->source_is_solid) {
			pGoblin->jreg->reg_fgcolor = __builtin_bswap32(pGoblin->fillcolour);
			switch (pGoblin->mskformat) {
			case PICT_a8:
				RPRINTF(X_INFO, "%s: %d: Starting PictOpOver: %d x %d, flip %d, %d x %d (+0x%08x)-> %d x %d (+0x%08x), fg 0x%08x\n", __func__, __LINE__,
						width, height, flip,
						maskX, maskY, pGoblin->mskoff,
						dstX, dstY, dstoff,
						pGoblin->fillcolour
						);
				
						/* RPRINTF(X_INFO, "%s: %d: before:\n", __func__, __LINE__); */
						/* for (int j = 0 ; j < 8 && j < height ; j++) { */
						/* 	for (int i = 0 ; i < 8 && i < width ; i++) { */
						/* 		RPRINTF(X_INFO, "\t[0x%02hhx 0x%08x]", */
						/* 				*(volatile unsigned char*)(pGoblin->fb + pGoblin->mskoff + (maskX+i) + (maskY+j)*pGoblin->mskpitch), */
						/* 				*(volatile unsigned int*)(pGoblin->fb + dstoff + 4*(dstX+i) + (dstY+j)*dstpitch)); */
						/* 	} */
						/* 	RPRINTF(X_INFO, "\n"); */
						/* } */
						
				pGoblin->jreg->reg_op = (0x80 | PictOpOver);
				pGoblin->jreg->reg_cmd = 8; // 1<<DO_RSMSK8DST32_BIT
				
	/* 					RPRINTF(X_INFO, "%s: %d: after:\n", __func__, __LINE__); */
	/* GoblinWait(pGoblin); */
	/* 					for (int j = 0 ; j < 8 && j < height ; j++) { */
	/* 						for (int i = 0 ; i < 8 && i < width ; i++) { */
	/* 							RPRINTF(X_INFO, "\t[0x%02hhx 0x%08x]", */
	/* 									*(volatile unsigned char*)(pGoblin->fb + pGoblin->mskoff + (maskX+i) + (maskY+j)*pGoblin->mskpitch), */
	/* 									*(volatile unsigned int*)(pGoblin->fb + dstoff + 4*(dstX+i) + (dstY+j)*dstpitch)); */
	/* 						} */
	/* 						RPRINTF(X_INFO, "\n"); */
	/* 					} */
				break;
			case PICT_a8r8g8b8:
			case PICT_a8b8g8r8:
				// not quite supported yet
				if ((width == 1) && (height == 1)) {
					pGoblin->jreg->reg_src_stride = pGoblin->srcpitch;
					pGoblin->jreg->reg_bitblt_src_x = srcX;
					pGoblin->jreg->reg_bitblt_src_y = srcY;
					if (pGoblin->srcoff != 0)
						pGoblin->jreg->reg_src_ptr = (0x8f000000 + pGoblin->srcoff); // fixme: hw'ired @
					else
						pGoblin->jreg->reg_src_ptr = 0;
					RPRINTF(X_INFO, "%s: %d: Starting PictOpOver: %d x %d, flip %d, %d x %d (+0x%08x) & %d x %d (+0x%08x) -> %d x %d (+0x%08x)\n", __func__, __LINE__,
						width, height, flip,
						srcX, srcY, pGoblin->srcoff,
						maskX, maskY, pGoblin->mskoff,
						dstX, dstY, dstoff
						);
					
						/* RPRINTF(X_INFO, "%s: %d: before:\n", __func__, __LINE__); */
						/* for (int j = 0 ; j < 8 && j < height ; j++) { */
						/* 	for (int i = 0 ; i < 8 && i < width ; i++) { */
						/* 		RPRINTF(X_INFO, "\t[0x%08x 0x%08x 0x%08x]", */
						/* 				*(volatile unsigned int*)(pGoblin->fb + pGoblin->srcoff + 4*(srcX+i) + (srcY+j)*pGoblin->srcpitch), */
						/* 				*(volatile unsigned int*)(pGoblin->fb + pGoblin->mskoff + 4*(maskX+i) + (maskY+j)*pGoblin->mskpitch), */
						/* 				*(volatile unsigned int*)(pGoblin->fb + dstoff + 4*(dstX+i) + (dstY+j)*dstpitch)); */
						/* 	} */
						/* 	RPRINTF(X_INFO, "\n"); */
						/* } */
					
					pGoblin->jreg->reg_op = (0x80 | PictOpOver | (flip ? 0x40 : 0));
					if ((pGoblin->srcoff != pGoblin->mskoff) ||
						(srcX != maskX) ||
						(srcY != maskY) ||
						(pGoblin->srcpitch != pGoblin->mskpitch)) {
						pGoblin->jreg->reg_cmd = 0x10; // 1<<DO_RSRC32MSK32DST32_BIT
					} else {
						// mask is just src
						pGoblin->jreg->reg_cmd = 0x20; // 1<<DO_RSRC32DST32_BIT
					}
				
	/* 					RPRINTF(X_INFO, "%s: %d: after:\n", __func__, __LINE__); */
	/* GoblinWait(pGoblin); */
	/* 					for (int j = 0 ; j < 8 && j < height ; j++) { */
	/* 						for (int i = 0 ; i < 8 && i < width ; i++) { */
	/* 							RPRINTF(X_INFO, "\t[0x%08x 0x%08x 0x%08x]", */
	/* 									*(volatile unsigned int*)(pGoblin->fb + pGoblin->srcoff + 4*(srcX+i) + (srcY+j)*pGoblin->srcpitch), */
	/* 									*(volatile unsigned int*)(pGoblin->fb + pGoblin->mskoff + 4*(maskX+i) + (maskY+j)*pGoblin->mskpitch), */
	/* 									*(volatile unsigned int*)(pGoblin->fb + dstoff + 4*(dstX+i) + (dstY+j)*dstpitch)); */
	/* 						} */
	/* 						RPRINTF(X_INFO, "\n"); */
	/* 					} */
			} else {
					RPRINTF(X_ERROR, "%s: %d: A Unsupported mask format %s (%d) for PictOpOver (%d x %d)\n", __func__, __LINE__, fmt2name(pGoblin->mskformat), pGoblin->mskformat, width, height);
				}
				break;
			default:
				RPRINTF(X_ERROR, "%s: %d: A Unsupported mask format %s (%d) for PictOpOver (%d x %d)\n", __func__, __LINE__, fmt2name(pGoblin->mskformat), pGoblin->mskformat, width, height);
				break;
			}
		} else {
			pGoblin->jreg->reg_src_stride = pGoblin->srcpitch;
			pGoblin->jreg->reg_bitblt_src_x = srcX;
			pGoblin->jreg->reg_bitblt_src_y = srcY;
			if (pGoblin->srcoff != 0)
				pGoblin->jreg->reg_src_ptr = (0x8f000000 + pGoblin->srcoff); // fixme: hw'ired @
			else
				pGoblin->jreg->reg_src_ptr = 0;
			switch (pGoblin->mskformat) {
			case PICT_a8r8g8b8:
			case PICT_a8b8g8r8:
				RPRINTF(X_INFO, "%s: %d: Starting PictOpOver: %d x %d, flip %d, %d x %d (+0x%08x) & %d x %d (+0x%08x) -> %d x %d (+0x%08x)\n", __func__, __LINE__,
						width, height, flip,
						srcX, srcY, pGoblin->srcoff,
						maskX, maskY, pGoblin->mskoff,
						dstX, dstY, dstoff
						);
				
						/* RPRINTF(X_INFO, "%s: %d: before:\n", __func__, __LINE__); */
						/* for (int j = 0 ; j < 8 && j < height ; j++) { */
						/* 	for (int i = 0 ; i < 8 && i < width ; i++) { */
						/* 		RPRINTF(X_INFO, "\t[0x%08x 0x%08x 0x%08x]", */
						/* 				*(volatile unsigned int*)(pGoblin->fb + pGoblin->srcoff + 4*(srcX+i) + (srcY+j)*pGoblin->srcpitch), */
						/* 				*(volatile unsigned int*)(pGoblin->fb + pGoblin->mskoff + 4*(maskX+i) + (maskY+j)*pGoblin->mskpitch), */
						/* 				*(volatile unsigned int*)(pGoblin->fb + dstoff + 4*(dstX+i) + (dstY+j)*dstpitch)); */
						/* 	} */
						/* 	RPRINTF(X_INFO, "\n"); */
						/* } */
						
				pGoblin->jreg->reg_op = (0x80 | PictOpOver | (flip ? 0x40 : 0));
				if ((pGoblin->srcoff != pGoblin->mskoff) ||
					(srcX != maskX) ||
					(srcY != maskY) ||
					(pGoblin->srcpitch != pGoblin->mskpitch)) {
					pGoblin->jreg->reg_cmd = 0x10; // 1<<DO_RSRC32MSK32DST32_BIT
				} else {
					// mask is just src
					pGoblin->jreg->reg_cmd = 0x20; // 1<<DO_RSRC32DST32_BIT
				}
				
	/* 					RPRINTF(X_INFO, "%s: %d: after:\n", __func__, __LINE__); */
	/* GoblinWait(pGoblin); */
	/* 					for (int j = 0 ; j < 8 && j < height ; j++) { */
	/* 						for (int i = 0 ; i < 8 && i < width ; i++) { */
	/* 							RPRINTF(X_INFO, "\t[0x%08x 0x%08x 0x%08x]", */
	/* 									*(volatile unsigned int*)(pGoblin->fb + pGoblin->srcoff + 4*(srcX+i) + (srcY+j)*pGoblin->srcpitch), */
	/* 									*(volatile unsigned int*)(pGoblin->fb + pGoblin->mskoff + 4*(maskX+i) + (maskY+j)*pGoblin->mskpitch), */
	/* 									*(volatile unsigned int*)(pGoblin->fb + dstoff + 4*(dstX+i) + (dstY+j)*dstpitch)); */
	/* 						} */
	/* 						RPRINTF(X_INFO, "\n"); */
	/* 					} */
						
				break;
			default:
				RPRINTF(X_ERROR, "%s: %d: B Unsupported mask format %s (%d) for PictOpOver (%d x %d)\n", __func__, __LINE__, fmt2name(pGoblin->mskformat), pGoblin->mskformat, width, height);
				break;
			}
		}
	} break;
	case PictOpAdd: {
		GoblinWait(pGoblin);
		pGoblin->jreg->reg_op = (0x80 | PictOpAdd); // xrender operation
		pGoblin->jreg->reg_width = width;
		pGoblin->jreg->reg_height = height;

		pGoblin->jreg->reg_dst_stride = dstpitch;
		pGoblin->jreg->reg_bitblt_dst_x = dstX;
		pGoblin->jreg->reg_bitblt_dst_y = dstY;
		if (dstoff != 0)
			pGoblin->jreg->reg_dst_ptr = (0x8f000000 + dstoff); // fixme: hw'ired @
		else
			pGoblin->jreg->reg_dst_ptr = 0;
		
		pGoblin->jreg->reg_src_stride = pGoblin->srcpitch;
		pGoblin->jreg->reg_bitblt_src_x = srcX;
		pGoblin->jreg->reg_bitblt_src_y = srcY;
		if (pGoblin->srcoff != 0)
			pGoblin->jreg->reg_src_ptr = (0x8f000000 + pGoblin->srcoff); // fixme: hw'ired @
		else
			pGoblin->jreg->reg_src_ptr = 0;

		if ((pGoblin->srcformat == PICT_a8) &&
			(pGoblin->dstformat == PICT_a8) &&
			(pGoblin->mskformat == 0) &&
			1) {
				RPRINTF(X_INFO, "%s: %d: Starting PictOpAdd: %d x %d, flip %d, %d x %d (+0x%08x)-> %d x %d (+0x%08x)\n", __func__, __LINE__,
						width, height, flip,
						srcX, srcY, pGoblin->srcoff,
						dstX, dstY, dstoff
						);
				
						/* RPRINTF(X_INFO, "%s: %d: before:\n", __func__, __LINE__); */
						/* for (int j = 0 ; j < 8 && j < height ; j++) { */
						/* 	for (int i = 0 ; i < 8 && i < width ; i++) { */
						/* 		RPRINTF(X_INFO, "\t[0x%02hhx 0x%02hhx]", */
						/* 				*(volatile unsigned char*)(pGoblin->fb + pGoblin->srcoff + (srcX+i) + (srcY+j)*pGoblin->srcpitch), */
						/* 				*(volatile unsigned char*)(pGoblin->fb + dstoff + (dstX+i) + (dstY+j)*dstpitch)); */
						/* 	} */
						/* 	RPRINTF(X_INFO, "\n"); */
						/* } */
						
			pGoblin->jreg->reg_depth = 8; // force 8 bits mode in the blitter
			pGoblin->jreg->reg_cmd = 1; // 1<<DO_COPY_BIT
			
						/* RPRINTF(X_INFO, "%s: %d: after:\n", __func__, __LINE__); */
						/* GoblinWait(pGoblin); */
						/* for (int j = 0 ; j < 8 && j < height ; j++) { */
						/* 	for (int i = 0 ; i < 8 && i < width ; i++) { */
						/* 		RPRINTF(X_INFO, "\t[0x%02hhx 0x%02hhx]", */
						/* 				*(volatile unsigned char*)(pGoblin->fb + pGoblin->srcoff + (srcX+i) + (srcY+j)*pGoblin->srcpitch), */
						/* 				*(volatile unsigned char*)(pGoblin->fb + dstoff + (dstX+i) + (dstY+j)*dstpitch)); */
						/* 	} */
						/* 	RPRINTF(X_INFO, "\n"); */
						/* } */
		} else {
			RPRINTF(X_ERROR, "%s: %d: Unsupported fmts %s (%d), %s (%d), %s (%d)\n", __func__, __LINE__, pGoblin->srcformat, pGoblin->srcformat, pGoblin->dstformat, pGoblin->dstformat, pGoblin->mskformat, pGoblin->mskformat);
		}
	} break;
	default:
		RPRINTF(X_ERROR, "%s: %d: Unsupported %s (%d)\n", __func__, __LINE__, op2name(pGoblin->op), pGoblin->op);
		break;
	}
	
	exaMarkSync(pDst->drawable.pScreen);
}
