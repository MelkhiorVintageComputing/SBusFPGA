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

#ifndef _SBUSFPGA_SDCARD_H_
#define _SBUSFPGA_SDCARD_H_

struct sbusfpga_sd_softc {
	struct dk_softc dk;
	//device_t sc_dev;		/* us as a device */
	u_int	sc_rev;			/* revision */
	int	sc_node;		/* PROM node ID */
	int	sc_burst;		/* DVMA burst size in effect */
	bus_space_tag_t	sc_bustag;	/* bus tag */
	bus_space_handle_t sc_bhregs_sdcore;	/* bus handle */
	bus_space_handle_t sc_bhregs_sdirq;	/* bus handle */
	bus_space_handle_t sc_bhregs_sdphy;	/* bus handle */
	bus_space_handle_t sc_bhregs_sdblock2mem;	/* bus handle */
	bus_space_handle_t sc_bhregs_sdmem2block;	/* bus handle */
	int	sc_bufsiz_sdcore;		/* Size of buffer */
	int	sc_bufsiz_sdirq;		/* Size of buffer */
	int	sc_bufsiz_sdphy;		/* Size of buffer */
	int	sc_bufsiz_sdblock2mem;	/* bus handle */
	int	sc_bufsiz_sdmem2block;	/* bus handle */
	/* card details */
	u_int max_rd_blk_len;
	u_int max_size_in_blk;
	u_int init_done;
	/* DMA kernel structures */
	bus_dma_tag_t		sc_dmatag;
	bus_dmamap_t		sc_dmamap;
	
	//device_t		sc_sdmmc_dev; /* us as a sdmmc bus device */
};

#define SBUSFPGA_SD_VAL_DMA_MAX_SZ (64*1024)

#endif /* _SBUSFPGA_SDCARD_H_ */
