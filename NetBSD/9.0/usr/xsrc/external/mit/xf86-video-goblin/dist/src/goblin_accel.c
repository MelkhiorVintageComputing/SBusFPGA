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

/* DGA stuff */

static Bool Goblin_OpenFramebuffer(ScrnInfoPtr pScrn, char **, unsigned char **mem,
    int *, int *, int *);
static Bool Goblin_SetMode(ScrnInfoPtr, DGAModePtr);
static void Goblin_SetViewport(ScrnInfoPtr, int, int, int);
static int Goblin_GetViewport(ScrnInfoPtr);

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
