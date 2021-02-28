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

#include <dev/sbus/rdfpga_sdcard.h>

#include <machine/param.h>

int	rdfpga_sdcard_print(void *, const char *);
int	rdfpga_sdcard_match(device_t, cfdata_t, void *);
void	rdfpga_sdcard_attach(device_t, device_t, void *);

CFATTACH_DECL_NEW(rdfpga_sdcard, sizeof(struct rdfpga_sdcard_softc),
    rdfpga_sdcard_match, rdfpga_sdcard_attach, NULL, NULL);

dev_type_open(rdfpga_sdcard_open);
dev_type_close(rdfpga_sdcard_close);
dev_type_ioctl(rdfpga_sdcard_ioctl);

const struct bdevsw rdfpga_sdcard_bdevsw = {
    .d_open = rdfpga_sdcard_open,
    .d_close = rdfpga_sdcard_close,
    .d_strategy = bdev_strategy,
    .d_ioctl = rdfpga_sdcard_ioctl,
    .d_dump = nodump,
    .d_psize = nosize,
    .d_discard = nodiscard,
    .d_flag = D_DISK
};

extern struct cfdriver rdfpga_sdcard_cd;

static int rdfpga_sdcard_wait_dma_ready(struct rdfpga_sdcard_softc *sc, const int count);
static int rdfpga_sdcard_wait_device_ready(struct rdfpga_sdcard_softc *sc, const int count);
static int rdfpga_sdcard_read_block(struct rdfpga_sdcard_softc *sc, const u_int32_t block, void *data);
static int rdfpga_sdcard_write_block(struct rdfpga_sdcard_softc *sc, const u_int32_t block, void *data);

struct rdfpga_sdcard_rb_32to512 {
  u_int32_t block;
  u_int8_t data[512];
};

#define RDFPGA_SDCARD_RS    _IOR(0, 1, u_int32_t)
#define RDFPGA_SDCARD_RSO   _IOR(0, 3, u_int32_t)
#define RDFPGA_SDCARD_RSO2  _IOR(0, 4, u_int32_t)
#define RDFPGA_SDCARD_RSO3  _IOR(0, 5, u_int32_t)
#define RDFPGA_SDCARD_RSTC  _IOR(0, 6, u_int32_t)
#define RDFPGA_SDCARD_RSTD  _IOR(0, 7, u_int32_t)
#define RDFPGA_SDCARD_RSD   _IOR(0, 8, u_int32_t)
#define RDFPGA_SDCARD_RSD2  _IOR(0, 9, u_int32_t)
#define RDFPGA_SDCARD_RB    _IOWR(0, 2, struct rdfpga_sdcard_rb_32to512)
#define RDFPGA_SDCARD_WB    _IOW(0, 10, struct rdfpga_sdcard_rb_32to512)
#define RDFPGA_SDCARD_RSTD2  _IOR(0, 11, u_int32_t)

int
rdfpga_sdcard_ioctl (dev_t dev, u_long cmd, void *data, int flag, struct lwp *l)
{
        struct rdfpga_sdcard_softc *sc = device_lookup_private(&rdfpga_sdcard_cd, minor(dev));
	int err = 0;
	
        switch (cmd) {
        case RDFPGA_SDCARD_RS:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS);
	  break;
        case RDFPGA_SDCARD_RSO:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD);
	  break;
        case RDFPGA_SDCARD_RSO2:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD2);
	  break;
        case RDFPGA_SDCARD_RSO3:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD3);
	  break;
        case RDFPGA_SDCARD_RSD:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_DAT);
	  break;
        case RDFPGA_SDCARD_RSD2:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_DAT2);
	  break;
        case RDFPGA_SDCARD_RSTC:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL);
	  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL, 0);
	  break;
        case RDFPGA_SDCARD_RSTD:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMAW_CTRL);
	  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMAW_CTRL, 0);
	  break;
        case RDFPGA_SDCARD_RSTD2:
	  *((u_int32_t*)data) = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMA_CTRL);
	  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMA_CTRL, 0);
	  break;
        case RDFPGA_SDCARD_RB:
	  {
	    struct rdfpga_sdcard_rb_32to512* u = data; 
	    err = rdfpga_sdcard_read_block(sc, u->block, u->data);
	    break;
	  }
        case RDFPGA_SDCARD_WB:
	  {
	    struct rdfpga_sdcard_rb_32to512* u = data; 
	    err = rdfpga_sdcard_write_block(sc, u->block, u->data);
	    break;
	  }
        default:
	  err = EINVAL;
	  break;
        }
        return(err);
}

int
rdfpga_sdcard_open(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
rdfpga_sdcard_close(dev_t dev, int flags, int mode, struct lwp *l)
{
	return (0);
}

int
rdfpga_sdcard_print(void *aux, const char *busname)
{

	sbus_print(aux, busname);
	return (UNCONF);
}

int
rdfpga_sdcard_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("RDOL,sdcard", sa->sa_name) == 0);
}

/*
 * Attach all the sub-devices we can find
 */
void
rdfpga_sdcard_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct rdfpga_sdcard_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int node;
	int sbusburst;
		
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
	
	aprint_normal_dev(self, "old status 0x%08x, current 0x%08x\n",
			  bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD),
			  bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS));
	
	/* Allocate a dmamap */
	if (bus_dmamap_create(sc->sc_dmatag, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, 1, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, 0, BUS_DMA_NOWAIT | BUS_DMA_ALLOCNOW, &sc->sc_dmamap) != 0) {
		aprint_error_dev(self, ": DMA map create failed\n");
	} else {
		aprint_normal_dev(self, "dmamap: %lu %lu %d (%p)\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs, sc->sc_dmatag->_dmamap_load);
	}

	bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL, 0);
	bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMAW_CTRL, 0);
	bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMA_CTRL, 0);
}

static int rdfpga_sdcard_wait_dma_ready(struct rdfpga_sdcard_softc *sc, const int count) {
  u_int32_t ctrl;
  int ctr;
  
  ctr = 0;
  while (((ctrl = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMAW_CTRL)) != 0) &&
	 (ctr < count)) {
    delay(1);
    ctr ++;
  }

  if (ctrl) {
	  aprint_error_dev(sc->sc_dev, "%s:%d:  timed out (%u after %u)\n", __PRETTY_FUNCTION__, __LINE__, ctrl, ctr);
    return EBUSY;
  }
  
  ctr = 0;
  while (((ctrl = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMA_CTRL)) != 0) &&
	 (ctr < count)) {
    delay(1);
    ctr ++;
  }

  if (ctrl) {
	  aprint_error_dev(sc->sc_dev, "%s:%d:  timed out (%u after %u)\n", __PRETTY_FUNCTION__, __LINE__, ctrl, ctr);
    return EBUSY;
  }

  return 0;
}

static int rdfpga_sdcard_wait_device_ready(struct rdfpga_sdcard_softc *sc, const int count) {
  u_int32_t ctrl;
  int ctr;
  
  ctr = 0;
  while (((ctrl = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL)) != 0) &&
	 (ctr < count)) {
    /* aprint_error_dev(sc->sc_dev, "ctrl is 0x%08x (%d, old status 0x%08x, current 0x%08x)\n", ctrl, ctr, */
    /* 		     bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD), */
    /* 		     bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS)); */
    delay(1);
    ctr ++;
  }
  
  /* aprint_normal_dev(sc->sc_dev, "ctrl is 0x%08x (%d, old status 0x%08x, current 0x%08x)\n", ctrl, ctr, */
  /* 		    bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD), */
  /* 		    bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS)); */


  if (ctrl) {
	  aprint_error_dev(sc->sc_dev, "%s:%d:  timed out (%u after %u)\n", __PRETTY_FUNCTION__, __LINE__, ctrl, ctr);
    return EBUSY;
  }

  return rdfpga_sdcard_wait_dma_ready(sc, count);
}

static int rdfpga_sdcard_read_block(struct rdfpga_sdcard_softc *sc, const u_int32_t block, void *data) {
  int res = 0;
  u_int32_t ctrl;
  //aprint_normal_dev(sc->sc_dev, "Reading block %u from sdcard\n", block);
  
  if ((res = rdfpga_sdcard_wait_device_ready(sc, 50000)) != 0)
    return res;
  
  if (bus_dmamem_alloc(sc->sc_dmatag, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, 64, 64, &sc->sc_segs, 1, &sc->sc_rsegs, BUS_DMA_NOWAIT | BUS_DMA_STREAMING)) {
    aprint_error_dev(sc->sc_dev, "cannot allocate DVMA memory");
    return ENXIO;
  }
  
  void* kvap;
  if (bus_dmamem_map(sc->sc_dmatag, &sc->sc_segs, 1, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, &kvap, BUS_DMA_NOWAIT)) {
    aprint_error_dev(sc->sc_dev, "cannot allocate DVMA address");
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }

  /* for testing only, remove */
  //memcpy(kvap, data, 512);
  
  if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, /* kernel space */ NULL,
		      BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_READ)) {
    aprint_error_dev(sc->sc_dev, "cannot load dma map");
    bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }
  
  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 512, BUS_DMASYNC_PREREAD);

  /* set DMA address */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMAW_ADDR, (uint32_t)(sc->sc_dmamap->dm_segs[0].ds_addr));
  /* set block to read */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_ADDR, block);
  ctrl = RDFPGA_SDCARD_CTRL_START | RDFPGA_SDCARD_CTRL_READ;
  /* initiate reading block from SDcard; once the read request is acknowledged, the HW will start the DMA engine */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL, ctrl);

  res = rdfpga_sdcard_wait_device_ready(sc, 100000);

  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 512, BUS_DMASYNC_POSTREAD);
  
  bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
  /* aprint_normal_dev(sc->sc_dev, "dma: unloaded\n"); */

  memcpy(data, kvap, 512);
  
  bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
	  /* aprint_normal_dev(sc->sc_dev, "dma: unmapped\n"); */
  
  bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
  
  return res;
}


static int rdfpga_sdcard_write_block(struct rdfpga_sdcard_softc *sc, const u_int32_t block, void *data) {
  int res = 0;
  u_int32_t ctrl;
  if ((res = rdfpga_sdcard_wait_device_ready(sc, 50000)) != 0)
    return res;
  
  if (bus_dmamem_alloc(sc->sc_dmatag, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, 64, 64, &sc->sc_segs, 1, &sc->sc_rsegs, BUS_DMA_NOWAIT | BUS_DMA_STREAMING)) {
    aprint_error_dev(sc->sc_dev, "cannot allocate DVMA memory");
    return ENXIO;
  }
  
  void* kvap;
  if (bus_dmamem_map(sc->sc_dmatag, &sc->sc_segs, 1, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, &kvap, BUS_DMA_NOWAIT)) {
    aprint_error_dev(sc->sc_dev, "cannot allocate DVMA address");
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }

  memcpy(kvap, data, 512);
  
  if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, /* kernel space */ NULL,
		      BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
    aprint_error_dev(sc->sc_dev, "cannot load dma map");
    bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }
  
  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 512, BUS_DMASYNC_PREWRITE);

  /* set DMA address */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMA_ADDR, (uint32_t)(sc->sc_dmamap->dm_segs[0].ds_addr));
  /* set block to read */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_ADDR, block);
  ctrl = RDFPGA_SDCARD_CTRL_START;
  /* initiate reading block from SDcard; once the read request is acknowledged, the HW will start the DMA engine */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL, ctrl);

  res = rdfpga_sdcard_wait_device_ready(sc, 100000);

  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 512, BUS_DMASYNC_POSTWRITE);
  
  bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
  /* aprint_normal_dev(sc->sc_dev, "dma: unloaded\n"); */

  //memcpy(data, kvap, 512);
  
  bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
	  /* aprint_normal_dev(sc->sc_dev, "dma: unmapped\n"); */
  
  bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
  
  return res;
}
