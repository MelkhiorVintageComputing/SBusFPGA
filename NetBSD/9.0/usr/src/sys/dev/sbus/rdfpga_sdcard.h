/*	$NetBSD$ */

/*-
 * Copyright (c) 2020 Romain Dolbeau <romain@dolbeau.org>
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

#ifndef _RDFPGA_SDCARD_H_
#define _RDFPGA_SDCARD_H_

struct rdfpga_sdcard_softc {
	struct dk_softc dk;
	/* device_t sc_dev;		/\* us as a device *\/ */
	/* struct disk	sc_dk;		/\* generic disk info *\/ */
	u_int	sc_rev;			/* revision */
	int	sc_node;		/* PROM node ID */
	int	sc_burst;		/* DVMA burst size in effect */
	bus_space_tag_t	sc_bustag;	/* bus tag */
	bus_space_handle_t sc_bhregs;	/* bus handle */
	//void *	sc_buffer;		/* VA of the registers */
	int	sc_bufsiz;		/* Size of buffer */
	bus_dma_tag_t		sc_dmatag;
	bus_dmamap_t		sc_dmamap;	/* DMA map for bus_dma_* */
	bus_dma_segment_t       sc_segs;
	int                     sc_rsegs;

};

/* ctrl*/
#define RDFPGA_SDCARD_REG_BASE   0x00
#define RDFPGA_SDCARD_REG_STATUS (RDFPGA_SDCARD_REG_BASE + 0x00)
#define RDFPGA_SDCARD_REG_STATUS_OLD (RDFPGA_SDCARD_REG_BASE + 0x04)
#define RDFPGA_SDCARD_REG_ADDR   (RDFPGA_SDCARD_REG_BASE + 0x08)
#define RDFPGA_SDCARD_REG_CTRL   (RDFPGA_SDCARD_REG_BASE + 0x0c)
#define RDFPGA_SDCARD_REG_DMAW_ADDR   (RDFPGA_SDCARD_REG_BASE + 0x10)
#define RDFPGA_SDCARD_REG_DMAW_CTRL   (RDFPGA_SDCARD_REG_BASE + 0x14)
#define RDFPGA_SDCARD_REG_STATUS_OLD2 (RDFPGA_SDCARD_REG_BASE + 0x18)
#define RDFPGA_SDCARD_REG_STATUS_OLD3 (RDFPGA_SDCARD_REG_BASE + 0x1c)
#define RDFPGA_SDCARD_REG_STATUS_DAT (RDFPGA_SDCARD_REG_BASE + 0x20)
#define RDFPGA_SDCARD_REG_STATUS_DAT2 (RDFPGA_SDCARD_REG_BASE + 0x24)
#define RDFPGA_SDCARD_REG_DMA_ADDR (RDFPGA_SDCARD_REG_BASE + 0x28)
#define RDFPGA_SDCARD_REG_DMA_CTRL (RDFPGA_SDCARD_REG_BASE + 0x2c)


#define RDFPGA_SDCARD_CTRL_START  0x80000000
#define RDFPGA_SDCARD_CTRL_READ   0x40000000

/* 16 pages, though we're likely to only use 512 bytes (one block) ATM */
#define RDFPGA_SDCARD_VAL_DMA_MAX_SZ       (65536)

#endif /* _RDFPGA_SDCARD_H_ */
