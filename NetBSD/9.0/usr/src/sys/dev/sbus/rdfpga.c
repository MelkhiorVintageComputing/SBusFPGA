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

#include <machine/param.h>

int	rdfpga_print(void *, const char *);
int	rdfpga_match(device_t, cfdata_t, void *);
void	rdfpga_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(rdfpga, sizeof(struct rdfpga_softc),
    rdfpga_match, rdfpga_attach, NULL, NULL);

dev_type_open(rdfpga_open);
dev_type_close(rdfpga_close);
dev_type_ioctl(rdfpga_ioctl);
dev_type_write(rdfpga_write);

const struct cdevsw rdfpga_cdevsw = {
	.d_open = rdfpga_open,
	.d_close = rdfpga_close,
	.d_read = noread,
	.d_write = rdfpga_write,
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
struct rdfpga_128bits_alt {
	uint64_t x[2];
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
	struct rdfpga_128bits_alt *bits = (struct rdfpga_128bits_alt*)data;
        int err = 0, i;

        switch (cmd) {
        case RDFPGA_WC:
		for (i = 0 ; i < 2 ; i++)
			bus_space_write_8(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_C + (i*8)), bits->x[i] );
                break;
        case RDFPGA_WH:
		for (i = 0 ; i < 2 ; i++)
			bus_space_write_8(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_H + (i*8)), bits->x[i] );
                break;
        case RDFPGA_WI:
		for (i = 0 ; i < 2 ; i++)
			bus_space_write_8(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_I + (i*8)), bits->x[i] );
                break;
        case RDFPGA_RC:
		for (i = 0 ; i < 2 ; i++)
			bits->x[i] = bus_space_read_8(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_C + (i*8)));
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
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_C + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_H + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_I + (i*4)), 0);

	return (0);
}

int
rdfpga_close(dev_t dev, int flags, int mode, struct lwp *l)
{
        struct rdfpga_softc *sc = device_lookup_private(&rdfpga_cd, minor(dev));
	int i;

	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_C + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_H + (i*4)), 0);
	for (i = 0 ; i < 4 ; i++)
		bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_I + (i*4)), 0);
	
	return (0);
}

int
rdfpga_write(dev_t dev, struct uio *uio, int flags)
{
        struct rdfpga_softc *sc = device_lookup_private(&rdfpga_cd, minor(dev));
	int error = 0, ctr = 0, res, oldres;
	
	aprint_normal_dev(sc->sc_dev, "dma uio: %zu in %d\n", uio->uio_resid, uio->uio_iovcnt);

	while (!error && uio->uio_resid >= 16 && uio->uio_iovcnt == 1) {
	  uint64_t ctrl;
	  uint32_t nblock = uio->uio_resid/16;
	  if (nblock > 256)
	    nblock = 256;

	  /* no implemented on sparc ? */
	  /* if (bus_dmamap_load_uio(sc->sc_dmatag, sc->sc_dmamap, uio, BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) { */
	  /*   aprint_error_dev(sc->sc_dev, "cannot allocate DVMA address"); */
	  /*   return ENXIO; */
	  /* } else { */
	  /*   aprint_normal_dev(sc->sc_dev, "dma: %lu %lu %d\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs); */
	  /* } */
	  
	  /* uint64_t buf[4]; */
	  /* if ((error = uiomove(buf, 32, uio)) != 0) */
	  /*   break; */
	  
	  /* if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, buf, 32, /\* kernel space *\/ NULL, */
	  /* 		      BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) { */
	  /*   aprint_error_dev(sc->sc_dev, "cannot allocate DVMA address"); */
	  /*   return ENXIO; */
	  /* } else { */
	  /*   aprint_normal_dev(sc->sc_dev, "dma: %lu %lu %d\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs); */
	  /* } */

	  /* aprint_normal_dev(sc->sc_dev, "dmamem about to alloc for %d blocks...\n", nblock); */
	  
	  bus_dma_segment_t segs;
	  int rsegs;
	  if (bus_dmamem_alloc(sc->sc_dmatag, nblock*16, 64, 64, &segs, 1, &rsegs, BUS_DMA_NOWAIT | BUS_DMA_STREAMING)) {
	     aprint_error_dev(sc->sc_dev, "cannot allocate DVMA memory");
	    return ENXIO;
	  }
	  /* else { */
	  /*   aprint_normal_dev(sc->sc_dev, "dmamem alloc: %d\n", rsegs); */
	  /* } */

	  void* kvap;
	  if (bus_dmamem_map(sc->sc_dmatag, &segs, 1, nblock*16, &kvap, BUS_DMA_NOWAIT)) {
	    aprint_error_dev(sc->sc_dev, "cannot allocate DVMA address");
	    return ENXIO;
	  }
	  /* else { */
	  /*   aprint_normal_dev(sc->sc_dev, "dmamem map: %p\n", kvap); */
	  /* } */

	  if ((error = uiomove(kvap, nblock*16, uio)) != 0)
	    break;
	  
	  /* aprint_normal_dev(sc->sc_dev, "uimove: left %zu in %d\n", uio->uio_resid, uio->uio_iovcnt); */
	  
	  if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, kvap, nblock*16, /* kernel space */ NULL,
	  		      BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
	    aprint_error_dev(sc->sc_dev, "cannot load dma map");
	    return ENXIO;
	  }
	  /* else { */
	  /*   aprint_normal_dev(sc->sc_dev, "dmamap: %lu %lu %d\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs); */
	  /* } */
	  
	  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, nblock*16, BUS_DMASYNC_PREWRITE);
	  
	  /* aprint_normal_dev(sc->sc_dev, "dma: synced\n"); */

	  ctrl = ((uint64_t)(0x80000000 | ((nblock-1) & 0x0FF))) | ((uint64_t)(uint32_t)(sc->sc_dmamap->dm_segs[0].ds_addr)) << 32;
	  
	  /* aprint_normal_dev(sc->sc_dev, "trying 0x%016llx\n", ctrl); */

	  bus_space_write_8(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_DMA_ADDR), ctrl);
	  
	  /* aprint_normal_dev(sc->sc_dev, "dma: cmd sent\n"); */

	  res = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_DMA_CTRL));
	  do {
	    ctr ++;
	    delay(2);
	    oldres = res;
	    res = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_DMA_CTRL));
	  } while ((res & 0x80000000) && !(res & 0x20000000) && (res != oldres) && (ctr < 10000));

	  if ((res & 0x80000000) || (res & 0x20000000)) {
	    aprint_error_dev(sc->sc_dev, "read 0x%08x (%d try)\n", res, ctr);
	    error = ENXIO;
	  }

	  /* if (sc->sc_dmamap->dm_nsegs > 0) { */
	  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, nblock*16, BUS_DMASYNC_POSTWRITE);
	  /* aprint_normal_dev(sc->sc_dev, "dma: synced (2)\n"); */
	  
	  bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
	  /* aprint_normal_dev(sc->sc_dev, "dma: unloaded\n"); */
	  
	  bus_dmamem_unmap(sc->sc_dmatag, kvap, nblock*16);
	  /* aprint_normal_dev(sc->sc_dev, "dma: unmapped\n"); */
	  
	  bus_dmamem_free(sc->sc_dmatag, &segs, 1);
	  /* aprint_normal_dev(sc->sc_dev, "dma: freed\n"); */
	}

	if (uio->uio_resid > 0)
	  aprint_normal_dev(sc->sc_dev, "%zd bytes left after DMA\n", uio->uio_resid);
	
	while (!error && uio->uio_resid > 0) {
		uint64_t bp[2] = {0, 0};
		size_t len = uimin(16, uio->uio_resid);

		if ((error = uiomove(bp, len, uio)) != 0)
			break;

		bus_space_write_8(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_I + 0), bp[0]);
		bus_space_write_8(sc->sc_bustag, sc->sc_bhregs, (RDFPGA_REG_GCM_I + 8), bp[1]);
	}

	return (error);
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

	sc->sc_bustag = sa->sa_bustag;
	sc->sc_dmatag = sa->sa_dmatag;
		
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

	sc->sc_burst = prom_getpropint(node, "slave-burst-sizes", -1);
	if (sc->sc_burst == -1)
		/* take SBus burst sizes */
		sc->sc_burst = sbusburst;

	/* Clamp at parent's burst sizes */
	sc->sc_burst &= sbusburst;

	aprint_normal("\n");
	aprint_normal_dev(self, "nid 0x%x, bustag %p, slave-burst 0x%x\n",
			  sc->sc_node,
			  sc->sc_bustag,
			  sc->sc_burst);

	/* change blink pattern to marching 2 */
	
	bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_REG_LED , 0xc0300c03);

	/* DMA */

	/* Allocate a dmamap */
#define MAX_DMA_SZ 4096
	if (bus_dmamap_create(sc->sc_dmatag, MAX_DMA_SZ, 1, MAX_DMA_SZ, 0, BUS_DMA_NOWAIT | BUS_DMA_ALLOCNOW, &sc->sc_dmamap) != 0) {
		aprint_error_dev(self, ": DMA map create failed\n");
	} else {
		aprint_normal_dev(self, "dmamap: %lu %lu %d (%p)\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs, sc->sc_dmatag->_dmamap_load);
	}
}
