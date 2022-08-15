/*
 * Goblin framebuffer driver.
 *
 * Copyright (C) 2000 Jakub Jelinek (jakub@redhat.com)
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
 * JAKUB JELINEK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <string.h>
#include <sys/ioctl.h>

#include "goblin.h"
#include "xf86.h"
#include "xf86_OSproc.h"
#include "mipointer.h"
#include "micmap.h"

#include "fb.h"
#include "xf86cmap.h"

#include "compat-api.h"

#ifndef SBUS_DEVICE_GOBLIN
#define SBUS_DEVICE_GOBLIN 0x0010
#endif

/*
                                                     0011 src
                                                     0101 dst
GXclear				0x0 	0                        0000
GXand				0x1 	src AND dst              0001
GXandReverse		0x2 	src AND NOT dst          0010
GXcopy				0x3 	src                      0011
GXandInverted		0x4 	(NOT src) AND dst        0100
GXnoop				0x5 	dst                      0101
GXxor				0x6 	src XOR dst              0110
GXor				0x7 	src OR dst               0111
GXnor				0x8 	(NOT src) AND (NOT dst)  1000
GXequiv				0x9 	(NOT src) XOR dst        1001
GXinvert			0xa 	NOT dst                  1010
GXorReverse			0xb 	src OR (NOT dst)         1011
GXcopyInverted		0xc 	NOT src                  1100
GXorInverted		0xd 	(NOT src) OR dst         1101
GXnand				0xe 	(NOT src) OR (NOT dst)   1110
GXset				0xf 	1                        1111
*/

static const OptionInfoRec * GOBLINAvailableOptions(int chipid, int busid);
static void	GOBLINIdentify(int flags);
static Bool	GOBLINProbe(DriverPtr drv, int flags);
static Bool	GOBLINPreInit(ScrnInfoPtr pScrn, int flags);
static Bool	GOBLINScreenInit(SCREEN_INIT_ARGS_DECL);
static Bool	GOBLINEnterVT(VT_FUNC_ARGS_DECL);
static void	GOBLINLeaveVT(VT_FUNC_ARGS_DECL);
static Bool	GOBLINCloseScreen(CLOSE_SCREEN_ARGS_DECL);
static Bool	GOBLINSaveScreen(ScreenPtr pScreen, int mode);
static void	GOBLINInitCplane24(ScrnInfoPtr pScrn);
static void	GOBLINExitCplane24(ScrnInfoPtr pScrn);

/* Required if the driver supports mode switching */
static Bool	GOBLINSwitchMode(SWITCH_MODE_ARGS_DECL);
/* Required if the driver supports moving the viewport */
static void	GOBLINAdjustFrame(ADJUST_FRAME_ARGS_DECL);

/* Optional functions */
static void	GOBLINFreeScreen(FREE_SCREEN_ARGS_DECL);
static ModeStatus GOBLINValidMode(SCRN_ARG_TYPE arg, DisplayModePtr mode,
			       Bool verbose, int flags);

static Bool GOBLINDriverFunc(ScrnInfoPtr pScrn, xorgDriverFuncOp op,
				pointer ptr);

#define GOBLIN_VERSION 1
#define GOBLIN_NAME "GOBLIN"
#define GOBLIN_DRIVER_NAME "goblin"
#define GOBLIN_MAJOR_VERSION PACKAGE_VERSION_MAJOR
#define GOBLIN_MINOR_VERSION PACKAGE_VERSION_MINOR
#define GOBLIN_PATCHLEVEL PACKAGE_VERSION_PATCHLEVEL

/* 
 * This contains the functions needed by the server after loading the driver
 * module.  It must be supplied, and gets passed back by the SetupProc
 * function in the dynamic case.  In the static case, a reference to this
 * is compiled in, and this requires that the name of this DriverRec be
 * an upper-case version of the driver name.
 */

_X_EXPORT DriverRec GOBLIN = {
    GOBLIN_VERSION,
    GOBLIN_DRIVER_NAME,
    GOBLINIdentify,
    GOBLINProbe,
    GOBLINAvailableOptions,
    NULL,
    0,
    GOBLINDriverFunc
};

typedef enum {
    OPTION_NOACCEL,
    OPTION_ACCELMETHOD
} GOBLINOpts;

static const OptionInfoRec GOBLINOptions[] = {
    { OPTION_NOACCEL,		"NoAccel",	OPTV_BOOLEAN,	{0}, FALSE },
    { OPTION_ACCELMETHOD,	"AccelMethod",	OPTV_STRING,	{0}, FALSE },
    { -1,			NULL,		OPTV_NONE,	{0}, FALSE }
};

static MODULESETUPPROTO(goblinSetup);

static XF86ModuleVersionInfo goblinVersRec =
{
	"goblin",
	MODULEVENDORSTRING,
	MODINFOSTRING1,
	MODINFOSTRING2,
	XORG_VERSION_CURRENT,
	GOBLIN_MAJOR_VERSION, GOBLIN_MINOR_VERSION, GOBLIN_PATCHLEVEL,
	ABI_CLASS_VIDEODRV,
	ABI_VIDEODRV_VERSION,
	MOD_CLASS_VIDEODRV,
	{0,0,0,0}
};

_X_EXPORT XF86ModuleData goblinModuleData = { &goblinVersRec, goblinSetup, NULL };

pointer
goblinSetup(pointer module, pointer opts, int *errmaj, int *errmin)
{
    static Bool setupDone = FALSE;

    if (!setupDone) {
	setupDone = TRUE;
	xf86AddDriver(&GOBLIN, module, HaveDriverFuncs);

	/*
	 * Modules that this driver always requires can be loaded here
	 * by calling LoadSubModule().
	 */

	/*
	 * The return value must be non-NULL on success even though there
	 * is no TearDownProc.
	 */
	return (pointer)TRUE;
    } else {
	if (errmaj) *errmaj = LDR_ONCEONLY;
	return NULL;
    }
}

static Bool
GOBLINGetRec(ScrnInfoPtr pScrn)
{
    /*
     * Allocate an GoblinRec, and hook it into pScrn->driverPrivate.
     * pScrn->driverPrivate is initialised to NULL, so we can check if
     * the allocation has already been done.
     */
    if (pScrn->driverPrivate != NULL)
	return TRUE;

    pScrn->driverPrivate = xnfcalloc(sizeof(GoblinRec), 1);
    return TRUE;
}

static void
GOBLINFreeRec(ScrnInfoPtr pScrn)
{
    GoblinPtr pGoblin;

    if (pScrn->driverPrivate == NULL)
	return;

    pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);

    free(pScrn->driverPrivate);
    pScrn->driverPrivate = NULL;

    return;
}

static const OptionInfoRec *
GOBLINAvailableOptions(int chipid, int busid)
{
    return GOBLINOptions;
}

/* Mandatory */
static void
GOBLINIdentify(int flags)
{
    xf86Msg(X_INFO, "%s: driver for SBusFPGA Goblin\n", GOBLIN_NAME);
}


/* Mandatory */
static Bool
GOBLINProbe(DriverPtr drv, int flags)
{
    int i;
    GDevPtr *devSections;
    int *usedChips;
    int numDevSections;
    int numUsed;
    Bool foundScreen = FALSE;
    EntityInfoPtr pEnt;

    /*
     * The aim here is to find all cards that this driver can handle,
     * and for the ones not already claimed by another driver, claim the
     * slot, and allocate a ScrnInfoRec.
     *
     * This should be a minimal probe, and it should under no circumstances
     * change the state of the hardware.  Because a device is found, don't
     * assume that it will be used.  Don't do any initialisations other than
     * the required ScrnInfoRec initialisations.  Don't allocate any new
     * data structures.
     */

    /*
     * Next we check, if there has been a chipset override in the config file.
     * For this we must find out if there is an active device section which
     * is relevant, i.e., which has no driver specified or has THIS driver
     * specified.
     */

    if ((numDevSections = xf86MatchDevice(GOBLIN_DRIVER_NAME,
					  &devSections)) <= 0) {
	/*
	 * There's no matching device section in the config file, so quit
	 * now.
	 */
	return FALSE;
    }

    /*
     * We need to probe the hardware first.  We then need to see how this
     * fits in with what is given in the config file, and allow the config
     * file info to override any contradictions.
     */

    numUsed = xf86MatchSbusInstances(GOBLIN_NAME, SBUS_DEVICE_GOBLIN,
		   devSections, numDevSections,
		   drv, &usedChips);
				    
    free(devSections);
    if (numUsed <= 0)
	return FALSE;

    if (flags & PROBE_DETECT)
	foundScreen = TRUE;
    else for (i = 0; i < numUsed; i++) {
	pEnt = xf86GetEntityInfo(usedChips[i]);

	/*
	 * Check that nothing else has claimed the slots.
	 */
	if(pEnt->active) {
	    ScrnInfoPtr pScrn;
	    
	    /* Allocate a ScrnInfoRec and claim the slot */
	    pScrn = xf86AllocateScreen(drv, 0);

	    /* Fill in what we can of the ScrnInfoRec */
	    pScrn->driverVersion = GOBLIN_VERSION;
	    pScrn->driverName	 = GOBLIN_DRIVER_NAME;
	    pScrn->name		 = GOBLIN_NAME;
	    pScrn->Probe	 = GOBLINProbe;
	    pScrn->PreInit	 = GOBLINPreInit;
	    pScrn->ScreenInit	 = GOBLINScreenInit;
  	    pScrn->SwitchMode	 = GOBLINSwitchMode;
  	    pScrn->AdjustFrame	 = GOBLINAdjustFrame;
	    pScrn->EnterVT	 = GOBLINEnterVT;
	    pScrn->LeaveVT	 = GOBLINLeaveVT;
	    pScrn->FreeScreen	 = GOBLINFreeScreen;
	    pScrn->ValidMode	 = GOBLINValidMode;
	    xf86AddEntityToScreen(pScrn, pEnt->index);
	    foundScreen = TRUE;
	}
	free(pEnt);
    }
    free(usedChips);
    return foundScreen;
}

/* Mandatory */
static Bool
GOBLINPreInit(ScrnInfoPtr pScrn, int flags)
{
    GoblinPtr pGoblin;
    sbusDevicePtr psdp;
    int i, prom, len;
    char *ptr;

    if (flags & PROBE_DETECT) return FALSE;

    /*
     * Note: This function is only called once at server startup, and
     * not at the start of each server generation.  This means that
     * only things that are persistent across server generations can
     * be initialised here.  xf86Screens[] is (pScrn is a pointer to one
     * of these).  Privates allocated using xf86AllocateScrnInfoPrivateIndex()  
     * are too, and should be used for data that must persist across
     * server generations.
     *
     * Per-generation data should be allocated with
     * AllocateScreenPrivateIndex() from the ScreenInit() function.
     */

    /* Allocate the GoblinRec driverPrivate */
    if (!GOBLINGetRec(pScrn)) {
	return FALSE;
    }
    pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    
    /* Set pScrn->monitor */
    pScrn->monitor = pScrn->confScreen->monitor;

    /* This driver doesn't expect more than one entity per screen */
    if (pScrn->numEntities > 1)
	return FALSE;
    /* This is the general case */
    for (i = 0; i < pScrn->numEntities; i++) {
	EntityInfoPtr pEnt = xf86GetEntityInfo(pScrn->entityList[i]);

	/* GOBLIN is purely SBUS */
	if (pEnt->location.type == BUS_SBUS) {
	    psdp = xf86GetSbusInfoForEntity(pEnt->index);
	    pGoblin->psdp = psdp;
	} else
	    return FALSE;
    }
	
    prom = sparcPromInit();
	len = 4;
    if ((ptr = sparcPromGetProperty(&psdp->node, "goblin-has-jareth", &len))) {
    	if (len >= 1) {
			/* if (ptr[0]) */
			/* 	pGoblin->has_accel = TRUE; */
			/* else */
			/* 	pGoblin->has_accel = FALSE; */
			pGoblin->has_accel = TRUE;
		} else {
			pGoblin->has_accel = FALSE;
		}
    }
	if (pGoblin->has_accel)
		xf86DrvMsg(pScrn->scrnIndex, X_INFO, "Jareth found\n");
	else
		xf86DrvMsg(pScrn->scrnIndex, X_INFO, "no Jareth (%p)\n", ptr);

    /*********************
    deal with depth
    *********************/
#if 0
    if (!xf86SetDepthBpp(pScrn, 8, 0, 0, NoDepth24Support)) {
	return FALSE;
    } else {
	/* Check that the returned depth is one we support */
	switch (pScrn->depth) {
	case 8:
	    /* OK */
	    break;
	default:
	    xf86DrvMsg(pScrn->scrnIndex, X_ERROR,
		       "Given depth (%d) is not supported by this driver\n",
		       pScrn->depth);
	    return FALSE;
	}
    }
#else
    if (!xf86SetDepthBpp(pScrn, 0, 0, 0, Support24bppFb|Support32bppFb))
		return FALSE;
    /* Check that the returned depth is one we support */
    switch (pScrn->depth) {
	case 32:
	case 24:
	    /* OK */
	    break;
	default:
	    xf86DrvMsg(pScrn->scrnIndex, X_ERROR,
		       "Given depth (%d) is not supported by this driver\n",
		       pScrn->depth);
	    return FALSE;
    }
#endif

    /* Collect all of the relevant option flags (fill in pScrn->options) */
    xf86CollectOptions(pScrn, NULL);
    /* Process the options */
    if (!(pGoblin->Options = malloc(sizeof(GOBLINOptions))))
	return FALSE;
    memcpy(pGoblin->Options, GOBLINOptions, sizeof(GOBLINOptions));
    xf86ProcessOptions(pScrn->scrnIndex, pScrn->options, pGoblin->Options);
	
    /*
     * This must happen after pScrn->display has been set because
     * xf86SetWeight references it.
     */
    if (pScrn->depth > 8) {
	rgb weight = {0, 0, 0};
	rgb mask = {0xff, 0xff00, 0xff0000};
                                       
	if (!xf86SetWeight(pScrn, weight, mask)) {
	    return FALSE;
	}
    }
    
    if (!xf86SetDefaultVisual(pScrn, -1))
	return FALSE;
    else if (pScrn->depth > 8) {
	/* We don't currently support DirectColor */
	if (pScrn->defaultVisual != TrueColor) {
	    xf86DrvMsg(pScrn->scrnIndex, X_ERROR, "Given default visual"
		       " (%s) is not supported\n",
		       xf86GetVisualName(pScrn->defaultVisual));
	    return FALSE;
	}
    }   

    /*
     * The new cmap code requires this to be initialised.
     */

    {
	Gamma zeros = {0.0, 0.0, 0.0};

	if (!xf86SetGamma(pScrn, zeros)) {
	    return FALSE;
	}
    }

    if (xf86ReturnOptValBool(pGoblin->Options, OPTION_NOACCEL, FALSE)) {
		pGoblin->NoAccel = TRUE;
		xf86DrvMsg(pScrn->scrnIndex, X_CONFIG, "Acceleration disabled\n");
    }

    char *optstr;
    optstr = (char *)xf86GetOptValString(pGoblin->Options, OPTION_ACCELMETHOD);
    if (optstr == NULL) optstr = "exa";

    if (xf86LoadSubModule(pScrn, "fb") == NULL) {
	GOBLINFreeRec(pScrn);
	return FALSE;
    }

    /*********************
    set up clock and mode stuff
    *********************/
    
    pScrn->progClock = TRUE;

    if(pScrn->display->virtualX || pScrn->display->virtualY) {
	xf86DrvMsg(pScrn->scrnIndex, X_WARNING,
		   "GOBLIN does not support a virtual desktop\n");
	pScrn->display->virtualX = 0;
	pScrn->display->virtualY = 0;
    }

    xf86SbusUseBuiltinMode(pScrn, pGoblin->psdp);
    pScrn->currentMode = pScrn->modes;
    pScrn->displayWidth = pScrn->virtualX;

    /* Set display resolution */
    xf86SetDpi(pScrn, 0, 0);

    return TRUE;
}

/* Mandatory */

/* This gets called at the start of each server generation */

static Bool
GOBLINScreenInit(SCREEN_INIT_ARGS_DECL)
{
    ScrnInfoPtr pScrn = xf86ScreenToScrn(pScreen);
    GoblinPtr pGoblin;
    sbusDevicePtr psdp;
    int ret, i;
    
    pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    psdp = pGoblin->psdp;
/*     xf86Msg(X_INFO, "%s: %s\n", pGoblin->psdp->device, __PRETTY_FUNCTION__); */

    /* Map the GOBLIN memory */

    pGoblin->fbc = xf86MapSbusMem(psdp, GOBLIN_FBC_VOFF, sizeof(*pGoblin->fbc));

    /*
     * XXX need something better here - we rely on the OS to allow mmap()ing 
     * usable VRAM ONLY. Works with NetBSD, may crash and burn on other OSes.
     */

    pGoblin->fb = NULL;
    for (i = 16 ; (i > 0) && (pGoblin->fb == NULL)  ; i = i / 2) {
	    pGoblin->vidmem = i * 1024 * 1024;
	    pGoblin->fb = xf86MapSbusMem(psdp, GOBLIN_RAM_VOFF, pGoblin->vidmem);
    }
    
    if (pGoblin->fb != NULL) {
        xf86DrvMsg(pScrn->scrnIndex, X_INFO, "mapped %d KB video RAM @ [%p, %p[\n", 
				   pGoblin->vidmem >> 10, pGoblin->fb, pGoblin->fb + pGoblin->vidmem);
    }
    
    if (!pGoblin->fbc || !pGoblin->fb) {
        xf86DrvMsg(pScrn->scrnIndex, X_ERROR,
                   "xf86MapSbusMem failed fbc:%p fb:%p\n",
                   pGoblin->fbc, pGoblin->fb);
    
        if (pGoblin->fbc) {
            xf86UnmapSbusMem(psdp, pGoblin->fbc, sizeof(*pGoblin->fbc));
            pGoblin->fbc = NULL;
        }

        if (pGoblin->fb) {
            xf86UnmapSbusMem(psdp, pGoblin->fb, pGoblin->vidmem);
            pGoblin->fb = NULL;
        }

        return FALSE;
    }

	if (pGoblin->has_accel && !pGoblin->NoAccel) {
		// map Jareth registers
	    pGoblin->jreg = xf86MapSbusMem(psdp, JARETH_REG_VOFF, sizeof(GoblinAccel));
		if (pGoblin->jreg == NULL) {
			xf86DrvMsg(pScrn->scrnIndex, X_ERROR, "xf86MapSbusMem failed for Jareth\n");
			pGoblin->has_accel = FALSE;
		} else {
			xf86DrvMsg(pScrn->scrnIndex, X_INFO, "Jareth successfully mapped @ %p\n", pGoblin->jreg);
		}
	}

    /* Darken the screen for aesthetic reasons and set the viewport */
    GOBLINSaveScreen(pScreen, SCREEN_SAVER_ON);

    /*
     * The next step is to setup the screen's visuals, and initialise the
     * framebuffer code.  In cases where the framebuffer's default
     * choices for things like visual layouts and bits per RGB are OK,
     * this may be as simple as calling the framebuffer's ScreenInit()
     * function.  If not, the visuals will need to be setup before calling
     * a fb ScreenInit() function and fixed up after.
     */

    /*
     * Reset visual list.
     */
    miClearVisualTypes();

#if 0
    /* Set the bits per RGB for 8bpp mode */
    pScrn->rgbBits = 8;
#endif
	
    /* Setup the visuals we support. */

    if (!miSetVisualTypes(pScrn->depth, miGetDefaultVisualMask(pScrn->depth),
			  pScrn->rgbBits, pScrn->defaultVisual))
	return FALSE;

    miSetPixmapDepths ();
	
    /*
     * Call the framebuffer layer's ScreenInit function, and fill in other
     * pScreen fields.
     */
	
	GOBLINInitCplane24(pScrn);
    ret = fbScreenInit(pScreen, pGoblin->fb, pScrn->virtualX,
					   pScrn->virtualY, pScrn->xDpi, pScrn->yDpi,
					   pScrn->virtualX, pScrn->bitsPerPixel);
    if (!ret)
		return FALSE;

    pGoblin->width = pScrn->virtualX;
    pGoblin->height = pScrn->virtualY;
    pGoblin->maxheight = (pGoblin->vidmem / pGoblin->width) & 0xffff;

    fbPictureInit (pScreen, 0, 0);

    xf86SetBackingStore(pScreen);
    xf86SetSilkenMouse(pScreen);

    xf86SetBlackWhitePixels(pScreen);

    if (pScrn->bitsPerPixel > 8) {
		VisualPtr visual;
		/* Fixup RGB ordering */
		visual = pScreen->visuals + pScreen->numVisuals;
		while (--visual >= pScreen->visuals) {
			if ((visual->class | DynamicClass) == DirectColor) {
				visual->offsetRed = pScrn->offset.red;
				visual->offsetGreen = pScrn->offset.green;
				visual->offsetBlue = pScrn->offset.blue;
				visual->redMask = pScrn->mask.red;
				visual->greenMask = pScrn->mask.green;
				visual->blueMask = pScrn->mask.blue;
			}
		}
    }

    if (!pGoblin->NoAccel && pGoblin->has_accel) {
		{
			/* EXA */
			XF86ModReqInfo req;
			int errmaj, errmin;
			
			memset(&req, 0, sizeof(XF86ModReqInfo));
			req.majorversion = EXA_VERSION_MAJOR;
			req.minorversion = EXA_VERSION_MINOR;
			if (!LoadSubModule(pScrn->module, "exa", NULL, NULL, NULL, &req,
							   &errmaj, &errmin)) {
				LoaderErrorMsg(NULL, "exa", errmaj, errmin);
			return FALSE;
			}
			if (!GOBLINEXAInit(pScreen))
				return FALSE;
			xf86Msg(X_INFO, "%s: Using EXA acceleration\n", pGoblin->psdp->device);
		}
    }

    /* setup DGA */
    GoblinDGAInit(pScreen);


    /* Initialise cursor functions */
    miDCInitialize (pScreen, xf86GetPointerScreenFuncs());

	/* hw cursor */
	GOBLINHWCursorInit(pScreen);

    /* Initialise default colourmap */
    if (!miCreateDefColormap(pScreen))
		return FALSE;
	
#if 0
    if(!xf86SbusHandleColormaps(pScreen, pGoblin->psdp))
		return FALSE;
#endif
	
    pGoblin->CloseScreen = pScreen->CloseScreen;
    pScreen->CloseScreen = GOBLINCloseScreen;
    pScreen->SaveScreen = GOBLINSaveScreen;

    /* Report any unused options (only for the first generation) */
    if (serverGeneration == 1) {
		xf86ShowUnusedOptions(pScrn->scrnIndex, pScrn->options);
    }

    /* unblank the screen */
    GOBLINSaveScreen(pScreen, SCREEN_SAVER_OFF);

    /* Done */
    return TRUE;
}


/* Usually mandatory */
static Bool
GOBLINSwitchMode(SWITCH_MODE_ARGS_DECL)
{
    return TRUE;
}


/*
 * This function is used to initialize the Start Address - the first
 * displayed location in the video memory.
 */
/* Usually mandatory */
static void 
GOBLINAdjustFrame(ADJUST_FRAME_ARGS_DECL)
{
    /* we don't support virtual desktops */
    return;
}

/*
 * This is called when VT switching back to the X server.  Its job is
 * to reinitialise the video mode.
 */

/* Mandatory */
static Bool
GOBLINEnterVT(VT_FUNC_ARGS_DECL)
{
    SCRN_INFO_PTR(arg);
    /* GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn); */

    GOBLINInitCplane24 (pScrn);
    return TRUE;
}


/*
 * This is called when VT switching away from the X server.
 */

/* Mandatory */
static void
GOBLINLeaveVT(VT_FUNC_ARGS_DECL)
{
    SCRN_INFO_PTR(arg);
    /* GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn); */
	
    GOBLINExitCplane24 (pScrn);
    return;
}


/*
 * This is called at the end of each server generation.  It restores the
 * original (text) mode.  It should really also unmap the video memory too.
 */

/* Mandatory */
static Bool
GOBLINCloseScreen(CLOSE_SCREEN_ARGS_DECL)
{
    ScrnInfoPtr pScrn = xf86ScreenToScrn(pScreen);
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    sbusDevicePtr psdp = pGoblin->psdp;
/*     xf86Msg(X_INFO, "%s: %s\n", pGoblin->psdp->device, __PRETTY_FUNCTION__); */

    pScrn->vtSema = FALSE;

	if (pGoblin->jreg) {
		pGoblin->jreg->reg_src_ptr = 0;
		pGoblin->jreg->reg_dst_ptr = 0;
		xf86UnmapSbusMem(psdp, pGoblin->jreg, sizeof(GoblinAccel));
		pGoblin->jreg = NULL;
	}
		
    if (pGoblin->fbc) {
        xf86UnmapSbusMem(psdp, pGoblin->fbc, sizeof(*pGoblin->fbc));
        pGoblin->fbc = NULL;
    }

    if (pGoblin->fb) {
        xf86UnmapSbusMem(psdp, pGoblin->fb, pGoblin->vidmem);
        pGoblin->fb = NULL;
    }
	
    GOBLINExitCplane24(pScrn);

    pScreen->CloseScreen = pGoblin->CloseScreen;
    return (*pScreen->CloseScreen)(CLOSE_SCREEN_ARGS);
}


/* Free up any per-generation data structures */

/* Optional */
static void
GOBLINFreeScreen(FREE_SCREEN_ARGS_DECL)
{
    SCRN_INFO_PTR(arg);
    GOBLINFreeRec(pScrn);
}


/* Checks if a mode is suitable for the selected chipset. */

/* Optional */
static ModeStatus
GOBLINValidMode(SCRN_ARG_TYPE arg, DisplayModePtr mode, Bool verbose, int flags)
{
    if (mode->Flags & V_INTERLACE)
	return(MODE_BAD);

    return(MODE_OK);
}

/* Do screen blanking */

/* Mandatory */
static Bool
GOBLINSaveScreen(ScreenPtr pScreen, int mode)
{
    ScrnInfoPtr pScrn = xf86Screens[pScreen->myNum];
    GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
    /* xf86Msg(X_INFO, "%s: %s\n", pGoblin->psdp->device, __PRETTY_FUNCTION__); */
	
    switch(mode)
    {
    case SCREEN_SAVER_ON:
    case SCREEN_SAVER_CYCLE:
		if (pGoblin->fbc->videoctrl != GOBOFB_VIDEOCTRL_OFF)
			pGoblin->fbc->videoctrl = GOBOFB_VIDEOCTRL_OFF;
       break;
    case SCREEN_SAVER_OFF:
    case SCREEN_SAVER_FORCER:
		if (pGoblin->fbc->videoctrl != GOBOFB_VIDEOCTRL_ON)
			pGoblin->fbc->videoctrl = GOBOFB_VIDEOCTRL_ON;
       break;
    default:
       return FALSE;
    }
	
    return TRUE;
}

static Bool
GOBLINDriverFunc(ScrnInfoPtr pScrn, xorgDriverFuncOp op,
    pointer ptr)
{
	xorgHWFlags *flag;
/* 	GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn); */
/* 	xf86Msg(X_INFO, "%s: %s\n", pGoblin->psdp->device, __PRETTY_FUNCTION__); */
    
	switch (op) {
	case GET_REQUIRED_HW_INTERFACES:
		flag = (CARD32*)ptr;
		(*flag) = HW_MMIO;
		return TRUE;
	default:
		return FALSE;
	}
}



/*
 * This initializes the card for 24 bit mode.
 */
static void
GOBLINInitCplane24(ScrnInfoPtr pScrn)
{
  GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
  int size, bpp;
              
  size = pScrn->virtualX * pScrn->virtualY;
  bpp = 32;
  ioctl (pGoblin->psdp->fd, GOBLIN_SET_PIXELMODE, &bpp);
  memset (pGoblin->fb, 0, size * 4);
}                                                  

/*
 * This initializes the card for 8 bit mode.
 */
static void
GOBLINExitCplane24(ScrnInfoPtr pScrn)
{
  GoblinPtr pGoblin = GET_GOBLIN_FROM_SCRN(pScrn);
  int bpp = 8;
              
  ioctl (pGoblin->psdp->fd, GOBLIN_SET_PIXELMODE, &bpp);
}
