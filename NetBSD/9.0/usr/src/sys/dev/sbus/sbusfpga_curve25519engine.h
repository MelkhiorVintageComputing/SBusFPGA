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

#ifndef _SBUSFPGA_CURVE25519ENGINE_H_
#define _SBUSFPGA_CURVE25519ENGINE_H_

struct sbusfpga_curve25519engine_softc {
	device_t sc_dev;		/* us as a device */
	u_int	sc_rev;			/* revision */
	int	sc_node;		/* PROM node ID */
	int	sc_burst;		/* DVMA burst size in effect */
	bus_space_tag_t	sc_bustag;	/* bus tag */
	bus_space_handle_t sc_bhregs_curve25519engine;	/* bus handle */
	bus_space_handle_t sc_bhregs_microcode;	/* bus handle */
	bus_space_handle_t sc_bhregs_regfile;	/* bus handle */
	//void *	sc_buffer;		/* VA of the registers */
	int	sc_bufsiz_curve25519engine;		/* Size of buffer */
	int	sc_bufsiz_microcode;		/* Size of buffer */
	int	sc_bufsiz_regfile;		/* Size of buffer */
	bus_dma_tag_t		sc_dmatag;
	int initialized;
};

#endif /* _SBUSFPGA_CURVE25519ENGINE_H_ */
