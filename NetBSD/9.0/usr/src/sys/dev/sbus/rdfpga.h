/*	$NetBSD$ */

/*-
 * Copyright (c) 1998 The NetBSD Foundation, Inc.
 * All rights reserved.
 *
 * This code is derived from software contributed to The NetBSD Foundation
 * by Paul Kranenburg.
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

#ifndef _RDFPGA_H_
#define _RDFPGA_H_

struct rdfpga_softc {
	device_t sc_dev;		/* us as a device */
	u_int	sc_rev;			/* revision */
	int	sc_node;		/* PROM node ID */
	int	sc_burst;		/* DVMA burst size in effect */
	bus_space_tag_t	sc_bustag;	/* bus tag */
	bus_space_handle_t sc_bhregs;	/* bus handle */
	//void *	sc_buffer;		/* VA of the registers */
	int	sc_bufsiz;		/* Size of buffer */
	bus_dma_tag_t		sc_dmatag;
	bus_dmamap_t		sc_dmamap;	/* DMA map for bus_dma_* */
        int			aes_key_refresh;
  
  u_int32_t cr_id;
  u_int32_t sid;
  u_int64_t aeskey[2];
  u_int64_t aesiv[2];
  u_int8_t *sw_kschedule;
};

/* led */
#define RDFPGA_REG_LED 0x0 /* 1 reg */

/* gcm stuff */
#define RDFGPA_REG_GCM_BASE 0x40
#define RDFPGA_REG_GCM_H (RDFGPA_REG_GCM_BASE + 0x00) /* 4 regs */
#define RDFPGA_REG_GCM_C (RDFGPA_REG_GCM_BASE + 0x10) /* 4 regs */
#define RDFPGA_REG_GCM_I (RDFGPA_REG_GCM_BASE + 0x20) /* 4 regs */

/* dma, currently to read data in GCM */
#define RDFPGA_REG_DMA_BASE 0x80
#define RDFPGA_REG_DMA_ADDR (RDFPGA_REG_DMA_BASE + 0x00)
#define RDFPGA_REG_DMA_CTRL (RDFPGA_REG_DMA_BASE + 0x04)

#define RDFPGA_MASK_DMA_CTRL_START  0x80000000
#define RDFPGA_MASK_DMA_CTRL_BUSY   0x40000000 /* unused */
#define RDFPGA_MASK_DMA_CTRL_ERR    0x20000000
/* #define RDFPGA_MASK_DMA_CTRL_RW     0x10000000 */
#define RDFPGA_MASK_DMA_CTRL_BLKCNT 0x00000FFF
#define RDFPGA_VAL_DMA_MAX_BLKCNT         4096
/* #define RDFPGA_MASK_DMA_CTRL_SIZ    0x00000F00 */

#define RDFPGA_VAL_DMA_MAX_SZ 65536

/* having a go at AES128 */
#define RDFPGA_REG_AES128_BASE 0xc0
#define RDFPGA_REG_AES128_KEY  (RDFPGA_REG_AES128_BASE + 0x00) /* 4 regs */
#define RDFPGA_REG_AES128_DATA (RDFPGA_REG_AES128_BASE + 0x10) /* 4 regs */
#define RDFPGA_REG_AES128_OUT  (RDFPGA_REG_AES128_BASE + 0x20) /* 4 regs */
#define RDFPGA_REG_AES128_CTRL (RDFPGA_REG_AES128_BASE + 0x30)

#define RDFPGA_MASK_AES128_START  0x80000000
#define RDFPGA_MASK_AES128_BUSY   0x40000000
#define RDFPGA_MASK_AES128_ERR    0x20000000
#define RDFPGA_MASK_AES128_NEWKEY 0x10000000

#endif /* _RDFPGA_H_ */
