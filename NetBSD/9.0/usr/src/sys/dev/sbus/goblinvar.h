/*	$NetBSD$ */

/*
 * Copyright (c) 2022 Romain Dolbeau <romain@dolbeau.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE NETBSD FOUNDATION, INC. AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include "wsdisplay.h"
#include <dev/wscons/wsdisplay_vconsvar.h>

/*
 * color display (goblin) driver.
 */

struct goblin_fbcontrol {
	uint32_t mode; /* 0 */
	uint32_t vbl_mask;
	uint32_t videoctrl;
	uint32_t intr_clear;
	uint32_t reset; /* 4 */
	uint32_t lut_addr;
	uint32_t lut;
	uint32_t debug;
	uint32_t cursor_lut; /* 8 */
	uint32_t cursor_xy;
	uint32_t padding[6]; /* 0xa..0xf */
	uint32_t padding2[16]; /* 0x10 .. 0x1f */
	uint32_t curmask[32]; /* 0x20 .. 0x3f */
	uint32_t curbits[32]; /* 0x40 .. 0x5f */
};

/* per-display variables */
struct goblin_softc {
	device_t	      sc_dev;	  /* base device */
	struct fbdevice	  sc_fb;	  /* frame buffer device */
	bus_space_tag_t	  sc_bustag;
	bus_addr_t	      sc_reg_fbc_paddr;	  /* phys address for device mmap() */
	bus_addr_t	      sc_fb_paddr;	  /* phys address for device mmap() */
	bus_addr_t	      sc_jareth_reg_paddr;	  /* phys address for device mmap() */
	uint32_t          sc_size; /* full memory size */
	int	              sc_opens; /* number of open() to track 8/24 bits */
	int               sc_has_jareth; /* whether we have a Jareth vector engine available */
	uint32_t          sc_internal_adr;
	
	bus_space_handle_t sc_bhregs_jareth;	/* bus handle */
	
	volatile struct goblin_fbcontrol *sc_fbc;	/* control registers */
#if NWSDISPLAY > 0	
	uint32_t          sc_width;
	uint32_t          sc_height;  /* display width / height */
	uint32_t          sc_stride;
	int               sc_mode;
	struct vcons_data sc_vd;
	int               sc_depth;
#endif	
	union	bt_cmap   sc_cmap;	  /* DAC color map */
};

#define GOBLIN_SET_PIXELMODE	_IOW('M', 3, int)

void	goblinattach(struct goblin_softc *, const char *, int);
