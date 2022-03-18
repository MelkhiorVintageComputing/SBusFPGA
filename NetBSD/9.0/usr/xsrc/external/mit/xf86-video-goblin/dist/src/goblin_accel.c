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

//#define DEBUG_GOBLIN 1

#ifdef DEBUG_GOBLIN
#define ENTER xf86Msg(X_ERROR, "%s>\n", __func__);
#define DPRINTF xf86Msg
#else
#define ENTER
#define DPRINTF while (0) xf86Msg
#endif

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
     * Jareth has 128-bits memory access
     */
    pExa->pixmapOffsetAlign = 16;
    pExa->pixmapPitchAlign = 16;

    pExa->flags = EXA_OFFSCREEN_PIXMAPS;/*  | EXA_MIXED_PIXMAPS; */ /* | EXA_SUPPORTS_OFFSCREEN_OVERLAPS; */
	
	/*
	 * these limits are bogus
	 * Jareth doesn't deal with coordinates at all, so there is no limit but
	 * we have to put something here
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

    return exaDriverInit(pScreen, pExa);;
}

static inline void
GoblinWait(GoblinPtr pGoblin)
{
	uint32_t status = pGoblin->jreg->status;
	int count = 0;
	int max_count = 1000;
	int del = 1;
	const int param = 1;
	const int max_del = 32;

	ENTER;
	
	while ((status & 1) && (count < max_count)) {
		count ++;
		usleep(del * param);
		del = del < max_del ? 2*del : del;
		status = pGoblin->jreg->status;
	}

	if (status & 1) {
		xf86Msg(X_ERROR, "Jareth wait for idle timed out %08x %08x\n", status);
	} else {
		xf86Msg(X_INFO, "Jareth: last operation took %d cycles (eng_clk)\n", pGoblin->jreg->cyc_counter);
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
	DPRINTF(X_ERROR, "%s depth %d\n", __func__, bpp);
	dst += (x * cpp) + (y * dst_pitch);

	GoblinWait(pGoblin);

	while (h--) {
		memcpy(dst, src, wBytes);
		src += src_pitch;
		dst += dst_pitch;
	}
	__asm("stbar;");
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
	DPRINTF(X_ERROR, "PrepareSolid bpp: %d, alu %d, pm 0x%08x, Fg 0x%08x\n", pPixmap->drawable.bitsPerPixel, alu, planemask, fg);

	if ((pGoblin->jreg->power & 1) != 1)
		pGoblin->jreg->power = 1;
	
	GoblinWait(pGoblin);

	pGoblin->fg = fg;
	for (i = 0 ; i < 8; i++)
		pGoblin->jregfile->reg[1][i] = fg;

	pGoblin->jregfile->reg[5][0] = planemask;
	pGoblin->jregfile->reg[5][1] = alu;
	
	pGoblin->last_mask = planemask;
	pGoblin->last_rop = alu;

	if ((alu == 0x3) && // GCcopy
		(planemask == 0xFFFFFFFF)) { // full pattern
		// fill
		pGoblin->jreg->mpstart = pGoblin->fill_off;
		pGoblin->jreg->mplen = pGoblin->fill_len;
	} else {
		// fillrop
		pGoblin->jreg->mpstart = pGoblin->fillrop_off;
		pGoblin->jreg->mplen = pGoblin->fillrop_len;
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
			/* we work in bytes not pixels */
			w = w * 4;
			break;
		case 8:
			start = dstoff + (y1 * dstpitch) + x1;
			break;
	}

	ptr = 0x8f000000; // fixme
	ptr += start;

	GoblinWait(pGoblin);

	pGoblin->jregfile->reg[0][0] = ptr;
	pGoblin->jregfile->reg[2][0] = w;
	pGoblin->jregfile->reg[3][0] = h;
	pGoblin->jregfile->reg[4][0] = dstpitch;

	DPRINTF(X_ERROR, "Solid %d %d %d %d [%d %d], %d %d -> %d (%p: %p)\n", x1, y1, x2, y2,
			w, h, dstpitch, dstoff, start, (void*)start, ptr);

	pGoblin->jreg->control = 1; // start
	
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

	pGoblin->jregfile->reg[5][0] = planemask;
	pGoblin->jregfile->reg[5][1] = alu;
	
	pGoblin->last_mask = planemask;
	pGoblin->last_rop = alu;

	if (pGoblin->xdir > 0) {
		if ((alu == 0x3) && // GCcopy
			(planemask == 0xFFFFFFFF)) { // full pattern
			// fill
			pGoblin->jreg->mpstart = pGoblin->copy_off;
			pGoblin->jreg->mplen = pGoblin->copy_len;
		} else {
			// fillrop
			pGoblin->jreg->mpstart = pGoblin->copy_off; // FIXME
			pGoblin->jreg->mplen = pGoblin->copy_len;
		}
	} else {
		if ((alu == 0x3) && // GCcopy
			(planemask == 0xFFFFFFFF)) { // full pattern
			// fill
			pGoblin->jreg->mpstart = pGoblin->copyrev_off;
			pGoblin->jreg->mplen = pGoblin->copyrev_len;
		} else {
			// fillrop
			pGoblin->jreg->mpstart = pGoblin->copyrev_off; // FIXME
			pGoblin->jreg->mplen = pGoblin->copyrev_len;
		}
	}
	
	DPRINTF(X_ERROR, "PrepareCopy: alu %d, pm 0x%08x, xdir/ydir %d/%d\n", alu, planemask, xdir, ydir);
	
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
	src = (char*)0x8f000000 + srcstart; // fixme
	dst = (char*)0x8f000000 + dststart;

	if (pGoblin->ydir < 0) {
		src += pGoblin->srcpitch * (h-1);
		dst +=          dstpitch * (h-1);
		pGoblin->srcpitch = -pGoblin->srcpitch;
		dstpitch = -dstpitch;
	}

	// 32 bits
	w = w*4;

	GoblinWait(pGoblin);

	pGoblin->jregfile->reg[0][0] = (uint32_t)dst;
	pGoblin->jregfile->reg[0][1] = (uint32_t)src;
	pGoblin->jregfile->reg[1][0] = (uint32_t)src;
	pGoblin->jregfile->reg[1][1] = (uint32_t)dst;
	pGoblin->jregfile->reg[2][0] = w;
	pGoblin->jregfile->reg[3][0] = h;
	pGoblin->jregfile->reg[4][0] = dstpitch;
	pGoblin->jregfile->reg[4][1] = pGoblin->srcpitch;

	DPRINTF(X_ERROR, "Copy %d %d -> %d %d [%d x %d, %d %d] ; %d -> %d \n", srcX, srcY, dstX, dstY, w, h, pGoblin->xdir, pGoblin->ydir, srcstart, dststart);

	pGoblin->jreg->control = 1; // start
	
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
