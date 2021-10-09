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

#include <sys/cdefs.h>
__KERNEL_RCSID(0, "$NetBSD$");

#include <sys/param.h>
#include <sys/systm.h>
#include <sys/kernel.h>
#include <sys/errno.h>
#include <sys/device.h>
#include <sys/malloc.h>

#include <sys/bus.h>
#include <machine/autoconf.h>
#include <sys/cpu.h>
#include <sys/conf.h>

#include <sys/rndsource.h>

#include <dev/sbus/sbusvar.h>

#include <dev/sbus/sbusfpga_trng.h>

#include <machine/param.h>

int	sbusfpga_trng_print(void *, const char *);
int	sbusfpga_trng_match(device_t, cfdata_t, void *);
void	sbusfpga_trng_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(sbusfpga_trng, sizeof(struct sbusfpga_trng_softc),
    sbusfpga_trng_match, sbusfpga_trng_attach, NULL, NULL);

dev_type_open(sbusfpga_trng_open);
dev_type_close(sbusfpga_trng_close);
dev_type_ioctl(sbusfpga_trng_ioctl);



const struct cdevsw sbusfpga_trng_cdevsw = {
	.d_open = sbusfpga_trng_open,
	.d_close = sbusfpga_trng_close,
	.d_read = noread,
	.d_write = nowrite,
	.d_ioctl = noioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = nommap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = 0
};

extern struct cfdriver sbusfpga_trng_cd;
int
sbusfpga_trng_open(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
sbusfpga_trng_close(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
sbusfpga_trng_print(void *aux, const char *busname)
{

	sbus_print(aux, busname);
	return (UNCONF);
}

int
sbusfpga_trng_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("RDOL,neorv32trng", sa->sa_name) == 0);
}

#define CONFIG_CSR_DATA_WIDTH 32
#include "dev/sbus/sbusfpga_csr_trng.h"

static void
sbusfpga_trng_getentropy(size_t nbytes, void *cookie) {
  struct sbusfpga_trng_softc *sc = cookie;
  size_t dbytes = 0;
  int failure = 0;
  while (nbytes > dbytes) {
	  u_int32_t data = trng_data_read(sc);
	  if (data) {
		  rnd_add_data_sync(&sc->sc_rndsource, &data, 4, 32); // 32 is perhaps optimistic
		  dbytes += 4;
	  } else {
		  failure ++;
		  if (failure > (1+(dbytes/4))) { // something going on
			  device_printf(sc->sc_dev, "out of entropy after %zd / %zd bytes\n", dbytes, nbytes);
			  return;
		  }
		  delay(1);
	  }
	  if (((dbytes%32)==0) && (nbytes > dbytes))
		  delay(1); // let the hardware breathes if the OS needs a lof of bytes
  }
  device_printf(sc->sc_dev, "gathered %zd bytes [%d]\n", dbytes, failure);
}

/*
 * Attach all the sub-devices we can find
 */
void
sbusfpga_trng_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct sbusfpga_trng_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int node;
	int sbusburst;
		
	sc->sc_bustag = sa->sa_bustag;
	sc->sc_dev = self;

	if (sbus_bus_map(sc->sc_bustag, sa->sa_slot, sa->sa_offset, sa->sa_size,
			 BUS_SPACE_MAP_LINEAR, &sc->sc_bhregs_trng) != 0) {
		aprint_error(": cannot map registers\n");
		return;
	}

	//sc->sc_buffer = bus_space_vaddr(sc->sc_bustag, sc->sc_bhregs_trng);
	sc->sc_bufsiz = sa->sa_size;

	node = sc->sc_node = sa->sa_node;

	/*
	 * Get transfer burst size from PROM
	 */
	sbusburst = sbsc->sc_burst;
	if (sbusburst == 0)
		sbusburst = SBUS_BURST_32 - 1; /* 1->16 */

	sc->sc_burst = prom_getpropint(node, "burst-sizes", -1);
	if (sc->sc_burst == -1)
		/* take SBus burst sizes */
		sc->sc_burst = sbusburst;

	/* Clamp at parent's burst sizes */
	sc->sc_burst &= sbusburst;

	aprint_normal("\n");
	aprint_normal_dev(self, "nid 0x%x, bustag %p, burst 0x%x (parent 0x%0x)\n",
			  sc->sc_node,
			  sc->sc_bustag,
			  sc->sc_burst,
			  sbsc->sc_burst);

	trng_ctrl_write(sc, 0x02); // start the TRNG

	rndsource_setcb(&sc->sc_rndsource, sbusfpga_trng_getentropy, sc);
	rnd_attach_source(&sc->sc_rndsource, device_xname(self), RND_TYPE_RNG, RND_FLAG_HASCB | RND_FLAG_COLLECT_VALUE);
}
