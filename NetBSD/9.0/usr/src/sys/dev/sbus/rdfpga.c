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
#include <sys/ioccom.h>

#include <dev/sbus/sbusvar.h>

#include <dev/sbus/rdfpga.h>

int	rdfpga_print(void *, const char *);
int	rdfpga_match(device_t, cfdata_t, void *);
void	rdfpga_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(rdfpga, sizeof(struct rdfpga_softc),
    rdfpga_match, rdfpga_attach, NULL, NULL);

dev_type_open(rdfpga_open);
dev_type_close(rdfpga_close);
dev_type_ioctl(rdfpga_ioctl);

const struct cdevsw rdfpga_cdevsw = {
	.d_open = rdfpga_open,
	.d_close = rdfpga_close,
	.d_read = noread,
	.d_write = nowrite,
	.d_ioctl = rdfpga_ioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = nommap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = 0
};


extern struct cfdriver rdfpga_cd;

struct rdfpga_128bits {
	uint32_t x[4];
};

#define RDFPGA_WC   _IOW(0, 1, struct rdfpga_128bits)
#define RDFPGA_WH   _IOW(0, 2, struct rdfpga_128bits)
#define RDFPGA_WI   _IOW(0, 3, struct rdfpga_128bits)
#define RDFPGA_RC   _IOR(0, 4, struct rdfpga_128bits)
#define RDFPGA_WL   _IOW(0, 1, uint32_t)

int
rdfpga_ioctl (dev_t dev, u_long cmd, void *data, int flag, struct lwp *l)
{
        struct rdfpga_softc *sc = device_lookup_private(&rdfpga_cd, minor(dev));
	struct rdfpga_128bits *bits = (struct rdfpga_128bits*)data;
        int err = 0, i;

        switch (cmd) {
        case RDFPGA_WC:
		for (i = 0 ; i < 4 ; i++)
			bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_C + (i*4)), bits->x[i] );
                break;
        case RDFPGA_WH:
		for (i = 0 ; i < 4 ; i++)
			bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_H + (i*4)), bits->x[i] );
                break;
        case RDFPGA_WI:
		for (i = 0 ; i < 4 ; i++)
			bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_I + (i*4)), bits->x[i] );
                break;
        case RDFPGA_RC:
		for (i = 0 ; i < 4 ; i++)
			bits->x[i] = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_C + (i*4)));
                break;
        case RDFPGA_WL:
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_REG_LED, *(uint32_t*)data);
                break;
        default:
                err = EINVAL;
                break;
        }
        return(err);
}


int
rdfpga_open(dev_t dev, int flags, int mode, struct lwp *l)
{
        struct rdfpga_softc *sc = device_lookup_private(&rdfpga_cd, minor(dev));
	int i;

	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_C + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_H + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_I + (i*4)), 0);

	return (0);
}

int
rdfpga_close(dev_t dev, int flags, int mode, struct lwp *l)
{
        struct rdfpga_softc *sc = device_lookup_private(&rdfpga_cd, minor(dev));
	int i;

	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_C + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_H + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_I + (i*4)), 0);
	
	return (0);
}

int
rdfpga_print(void *aux, const char *busname)
{

	sbus_print(aux, busname);
	return (UNCONF);
}

int
rdfpga_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("RDOL,SBusFPGA", sa->sa_name) == 0);
}

/*
 * Attach all the sub-devices we can find
 */
void
rdfpga_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct rdfpga_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int node;
	int sbusburst;
	/* bus_dma_tag_t	dt = sa->sa_dmatag; */
	bus_space_handle_t bh;

	sc->sc_bustag = sa->sa_bustag;

	sc->sc_dev = self;

	if (sbus_bus_map(sc->sc_bustag, sa->sa_slot, sa->sa_offset, sa->sa_size,
			 BUS_SPACE_MAP_LINEAR, &bh) != 0) {
		aprint_error(": cannot map registers\n");
		return;
	}
	
	sc->sc_bhregs = bh;

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

	aprint_normal_dev(self, " nid %d, burst %x\n",
			  sc->sc_node,
			  sc->sc_burst);

	/* change blink pattern */
	
	bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_REG_LED , 0x81422418);
}
