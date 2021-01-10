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
#include <sys/timetc.h>

#include <dev/sbus/sbusvar.h>

#include <dev/sbus/rdfpga_trng.h>

#include <machine/param.h>

int	rdfpga_trng_print(void *, const char *);
int	rdfpga_trng_match(device_t, cfdata_t, void *);
void	rdfpga_trng_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(rdfpga_trng, sizeof(struct rdfpga_trng_softc),
    rdfpga_trng_match, rdfpga_trng_attach, NULL, NULL);

dev_type_open(rdfpga_trng_open);
dev_type_close(rdfpga_trng_close);
dev_type_ioctl(rdfpga_trng_ioctl);



const struct cdevsw rdfpga_trng_cdevsw = {
	.d_open = rdfpga_trng_open,
	.d_close = rdfpga_trng_close,
	.d_read = noread,
	.d_write = nowrite,
	.d_ioctl = rdfpga_trng_ioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = nommap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = 0
};

extern struct cfdriver rdfpga_trng_cd;

#define RDFPGA_TRNG_RD   _IOR(0, 1, u_int32_t)
int
rdfpga_trng_ioctl (dev_t dev, u_long cmd, void *data, int flag, struct lwp *l)
{
        struct rdfpga_trng_softc *sc = device_lookup_private(&rdfpga_trng_cd, minor(dev));
	int err = 0;
	
        switch (cmd) {
        case RDFPGA_TRNG_RD:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_TRNG_REG_DATA);
                break;
        default:
                err = EINVAL;
                break;
        }
        return(err);
}


int
rdfpga_trng_open(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
rdfpga_trng_close(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
rdfpga_trng_print(void *aux, const char *busname)
{

	sbus_print(aux, busname);
	return (UNCONF);
}

int
rdfpga_trng_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("RDOL,trng", sa->sa_name) == 0);
}

static void
rdfpga_trng_getentropy(size_t nbytes, void *cookie) {
  struct rdfpga_trng_softc *sc = cookie;
  /* aprint_normal_dev(sc->sc_dev, "%s\n", __PRETTY_FUNCTION__); */
  u_int32_t data = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_TRNG_REG_DATA);
  rnd_add_data_sync(&sc->sc_rndsource, &data, 4, 32);
}

static u_int
rdfpga_trng_tc_get_timecount(struct timecounter *tc) {
  struct rdfpga_trng_softc *sc = tc->tc_priv;
  return bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_TRNG_REG_TIMER);
}

/*
 * Attach all the sub-devices we can find
 */
void
rdfpga_trng_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct rdfpga_trng_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	struct timecounter* tc = &sc->sc_tc;
	int node;
	int sbusburst;
		
	sc->sc_bustag = sa->sa_bustag;
	sc->sc_dev = self;

	if (sbus_bus_map(sc->sc_bustag, sa->sa_slot, sa->sa_offset, sa->sa_size,
			 BUS_SPACE_MAP_LINEAR, &sc->sc_bhregs) != 0) {
		aprint_error(": cannot map registers\n");
		return;
	}

	//sc->sc_buffer = bus_space_vaddr(sc->sc_bustag, sc->sc_bhregs);
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
	
	aprint_normal_dev(self, "garbage 0x%08x\n", bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_TRNG_REG_DATA));
	aprint_normal_dev(self, "random 0x%08x\n", bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_TRNG_REG_DATA));

	rndsource_setcb(&sc->sc_rndsource, rdfpga_trng_getentropy, sc);
	rnd_attach_source(&sc->sc_rndsource, device_xname(self), RND_TYPE_RNG, RND_FLAG_HASCB | RND_FLAG_COLLECT_VALUE);

	tc->tc_get_timecount = rdfpga_trng_tc_get_timecount;
	tc->tc_poll_pps = NULL;
	tc->tc_counter_mask = 0xFFFFFFFF;
	tc->tc_frequency = 5000000;
	tc->tc_name = "RDOL,trng builtin 5MHz timer";
	tc->tc_quality = 1;
	tc->tc_priv = sc;

	tc_init(tc);
}
