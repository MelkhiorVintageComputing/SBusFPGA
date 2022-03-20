/*
 * Hardware cursor support for Goblin
 *
 * Copyright 2000 by Jakub Jelinek <jakub@redhat.com>.
 * Copyright 2022 by Jakub Jelinek <romain@Êolbeau.org>
 *
 * Permission to use, copy, modify, distribute, and sell this software
 * and its documentation for any purpose is hereby granted without
 * fee, provided that the above copyright notice appear in all copies
 * and that both that copyright notice and this permission notice
 * appear in supporting documentation, and that the name of Jakub
 * Jelinek not be used in advertising or publicity pertaining to
 * distribution of the software without specific, written prior
 * permission.  Jakub Jelinek makes no representations about the
 * suitability of this software for any purpose.  It is provided "as
 * is" without express or implied warranty.
 *
 * JAKUB JELINEK DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
 * SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS, IN NO EVENT SHALL JAKUB JELINEK BE LIABLE FOR ANY
 * SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
 * AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
 * OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "goblin.h"

static void GOBLINLoadCursorImage(ScrnInfoPtr pScrn, unsigned char *src);
static void GOBLINShowCursor(ScrnInfoPtr pScrn);
static void GOBLINHideCursor(ScrnInfoPtr pScrn);
static void GOBLINSetCursorPosition(ScrnInfoPtr pScrn, int x, int y);
static void GOBLINSetCursorColors(ScrnInfoPtr pScrn, int bg, int fg);

static void
GOBLINLoadCursorImage(ScrnInfoPtr pScrn, unsigned char *src)
{
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    int i;
    unsigned int *data = (unsigned int *)src;

    for (i = 0; i < 32; i++)
		pGoblin->fbc->curmask[i] = *data++;
    for (i = 0; i < 32; i++)
		pGoblin->fbc->curbits[i] = *data++;
}

static void 
GOBLINShowCursor(ScrnInfoPtr pScrn)
{
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);

    pGoblin->fbc->cursor_xy = pGoblin->CursorXY;
    pGoblin->CursorEnabled = TRUE;
}

static void
GOBLINHideCursor(ScrnInfoPtr pScrn)
{
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);

    pGoblin->fbc->cursor_xy = ((65536 - 32) << 16) | (65536 - 32);
    pGoblin->fbc->cursor_xy = pGoblin->CursorXY;
    pGoblin->CursorEnabled = FALSE;
}

static void
GOBLINSetCursorPosition(ScrnInfoPtr pScrn, int x, int y)
{
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);

    pGoblin->CursorXY = ((x & 0xffff) << 16) | (y & 0xffff);
    if (pGoblin->CursorEnabled)
		pGoblin->fbc->cursor_xy = pGoblin->CursorXY;
}

static void
GOBLINSetCursorColors(ScrnInfoPtr pScrn, int bg, int fg)
{
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);

    if (bg != pGoblin->CursorBg || fg != pGoblin->CursorFg) {
		pGoblin->fbc->lut_addr = 1; // bg color
		pGoblin->fbc->cursor_lut = (bg>>16)&0xFF;
		pGoblin->fbc->cursor_lut = (bg>> 8)&0xFF;
		pGoblin->fbc->cursor_lut = (bg>> 0)&0xFF;
		pGoblin->fbc->lut_addr = 3; // fg color
		pGoblin->fbc->cursor_lut = (fg>>16)&0xFF;
		pGoblin->fbc->cursor_lut = (fg>> 8)&0xFF;
		pGoblin->fbc->cursor_lut = (fg>> 0)&0xFF;
		
    	xf86Msg(X_INFO, "Goblin: fg set to 0x%08x, bg set to 0x%08x\n", fg, bg);
			
		pGoblin->CursorBg = bg;
		pGoblin->CursorFg = fg;
    }
}

Bool 
GOBLINHWCursorInit(ScreenPtr pScreen)
{
    ScrnInfoPtr pScrn = xf86Screens[pScreen->myNum];
    GoblinPtr pGoblin;
    xf86CursorInfoPtr infoPtr;

    pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    pGoblin->CursorXY = 0;
    pGoblin->CursorBg = 0;
	pGoblin->CursorFg = 0;
    pGoblin->CursorEnabled = FALSE;

    infoPtr = xf86CreateCursorInfoRec();
    if(!infoPtr) return FALSE;
    
    pGoblin->CursorInfoRec = infoPtr;

    infoPtr->MaxWidth = 32;
    infoPtr->MaxHeight = 32;
    infoPtr->Flags = HARDWARE_CURSOR_AND_SOURCE_WITH_MASK |
		             HARDWARE_CURSOR_SWAP_SOURCE_AND_MASK |
		             HARDWARE_CURSOR_SOURCE_MASK_NOT_INTERLEAVED |
	                 HARDWARE_CURSOR_TRUECOLOR_AT_8BPP;

    infoPtr->SetCursorColors = GOBLINSetCursorColors;
    infoPtr->SetCursorPosition = GOBLINSetCursorPosition;
    infoPtr->LoadCursorImage = GOBLINLoadCursorImage;
    infoPtr->HideCursor = GOBLINHideCursor;
    infoPtr->ShowCursor = GOBLINShowCursor;
    infoPtr->UseHWCursor = NULL;

    return xf86InitCursor(pScreen, infoPtr);
}
