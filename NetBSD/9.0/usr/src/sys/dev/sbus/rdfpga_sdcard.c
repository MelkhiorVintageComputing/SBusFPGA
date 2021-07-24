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
#include <sys/systm.h>

#include <sys/bus.h>
#include <machine/autoconf.h>
#include <sys/cpu.h>
#include <sys/conf.h>

#include <sys/rndsource.h>
#include <sys/timetc.h>

#include <dev/sbus/sbusvar.h>

#include <sys/disklabel.h>
#include <sys/disk.h>
#include <sys/buf.h>

#include <sys/bufq.h>
#include <sys/disk.h>
#include <dev/dkvar.h>

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
dev_type_strategy(rdfpga_sdcard_strategy);
dev_type_size(rdfpga_sdcard_size);

const struct bdevsw rdfpga_sdcard_bdevsw = {
    .d_open = rdfpga_sdcard_open,
    .d_close = rdfpga_sdcard_close,
    .d_strategy = rdfpga_sdcard_strategy,
    .d_ioctl = rdfpga_sdcard_ioctl,
    .d_dump = nodump,
    .d_psize = rdfpga_sdcard_size,
    .d_discard = nodiscard,
    .d_flag = D_DISK
};

const struct cdevsw rdfpga_sdcard_cdevsw = {
	.d_open = rdfpga_sdcard_open,
	.d_close = rdfpga_sdcard_close,
	.d_read = noread,
	.d_write = nowrite,
	.d_ioctl = rdfpga_sdcard_ioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = nommap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = D_DISK
};

static void	rdfpga_sdcard_set_geometry(struct rdfpga_sdcard_softc *sc);
static void rdfpga_sdcard_minphys(struct buf *);
static int rdfpga_sdcard_diskstart(device_t self, struct buf *bp);

struct dkdriver rdfpga_sdcard_dkdriver = {
	.d_strategy = rdfpga_sdcard_strategy,
	.d_minphys = rdfpga_sdcard_minphys,
	.d_diskstart = rdfpga_sdcard_diskstart								  
};

extern struct cfdriver rdfpga_sdcard_cd;

static int rdfpga_sdcard_wait_dma_ready(struct rdfpga_sdcard_softc *sc, const int count);
static int rdfpga_sdcard_wait_device_ready(struct rdfpga_sdcard_softc *sc, const int count);
static int rdfpga_sdcard_read_block(struct rdfpga_sdcard_softc *sc, const u_int32_t block, const u_int32_t blkcnt, void *data);
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
        struct rdfpga_sdcard_softc *sc = device_lookup_private(&rdfpga_sdcard_cd, DISKUNIT(dev));
		int err = 0, err2 = 0;

		if (sc == NULL) {
			aprint_error("%s:%d: sc == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
			return (ENXIO);
		}
		
		aprint_normal_dev(sc->dk.sc_dev, "%s:%d: ioctl (0x%08lx, %p, 0x%08x) part %d\n", __PRETTY_FUNCTION__, __LINE__, cmd, data, flag, DISKPART(dev));
	
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
	    err = rdfpga_sdcard_read_block(sc, u->block, 1, u->data);
	    break;
	  }
        case RDFPGA_SDCARD_WB:
	  {
	    struct rdfpga_sdcard_rb_32to512* u = data; 
	    err = rdfpga_sdcard_write_block(sc, u->block, u->data);
	    break;
	  }
			
	/* case VNDIOCCLR: */
	/* case VNDIOCCLR50: */
	case DIOCGDINFO:
	case DIOCSDINFO:
	case DIOCWDINFO:
	case DIOCGPARTINFO:
	case DIOCKLABEL:
	case DIOCWLABEL:
	case DIOCCACHESYNC:
#ifdef __HAVE_OLD_DISKLABEL
	case ODIOCGDINFO:
	case ODIOCSDINFO:
	case ODIOCWDINFO:
	case ODIOCGDEFLABEL:
#endif
	case DIOCDWEDGE:
	case DIOCAWEDGE:
	case DIOCLWEDGES:
	case DIOCRMWEDGES:
	case DIOCMWEDGES:
	case DIOCGWEDGEINFO:

	err2 = dk_ioctl(&sc->dk, dev, cmd, data, flag, l);
	if (err2 != EPASSTHROUGH)
		err = err2;
	break;
	case DIOCGDEFLABEL:
		if (0) {
		struct disklabel *lp = sc->dk.sc_dkdev.dk_label;
		struct cpu_disklabel *clp = sc->dk.sc_dkdev.dk_cpulabel;
		const char* buf;
		memset(lp, 0, sizeof(struct disklabel));
		memset(clp, 0, sizeof(struct cpu_disklabel));
		lp->d_type = DKTYPE_FLASH;
		lp->d_secsize = 512;
		lp->d_secpercyl = 63;
		lp->d_nsectors = 62521344; /* wrong, pet track not total */
		lp->d_ncylinders = 3892;
		lp->d_ntracks = 255;
		lp->d_secperunit = lp->d_secpercyl * lp->d_ncylinders;
		lp->d_rpm = 3600;	/* XXX like it matters... */
		
		strncpy(lp->d_typename, "sdcard", sizeof(lp->d_typename));
		strncpy(lp->d_packname, "fictitious", sizeof(lp->d_packname));
		lp->d_interleave = 0;
		
		lp->d_partitions[RAW_PART].p_offset = 0;
		lp->d_partitions[RAW_PART].p_size = lp->d_secpercyl * lp->d_ncylinders;
		lp->d_partitions[RAW_PART].p_fstype = FS_UNUSED;
		lp->d_npartitions = RAW_PART + 1;
		
		lp->d_magic = DISKMAGIC;
		lp->d_magic2 = DISKMAGIC;
		lp->d_checksum = dkcksum(lp);
		
		if ((buf = readdisklabel(dev, rdfpga_sdcard_strategy, lp, clp)) != NULL) {
			aprint_normal_dev(sc->dk.sc_dev, "read disk label err '%s'\n", buf);
		} else {
			aprint_normal_dev(sc->dk.sc_dev, "read disk label success\n");
		}
		}
	err2 = dk_ioctl(&sc->dk, dev, cmd, data, flag, l);
	if (err2 != EPASSTHROUGH)
		err = err2;
	break;
        default:
			err = EINVAL;
			break;
        }

		aprint_normal_dev(sc->dk.sc_dev, "%s:%d: ioctl (0x%08lx, %p, 0x%08x) -> %d [%d]\n", __PRETTY_FUNCTION__, __LINE__, cmd, data, flag, err, err2);
		
        return(err);
}

int
rdfpga_sdcard_open(dev_t dev, int flag, int fmt, struct lwp *l)
{
	struct rdfpga_sdcard_softc *sd = device_lookup_private(&rdfpga_sdcard_cd, DISKUNIT(dev));
	struct dk_softc *dksc;
	int error;

	if (sd == NULL) {
		aprint_error("%s:%d: sd == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	} else {
		aprint_normal("%s:%d: open device, part is %d\n", __PRETTY_FUNCTION__, __LINE__, DISKPART(dev));
	}
	dksc = &sd->dk;

	if (!device_is_active(dksc->sc_dev)) {
		return (ENODEV);
	}

	error = dk_open(dksc, dev, flag, fmt, l);

	return error;
}

int
rdfpga_sdcard_close(dev_t dev, int flag, int fmt, struct lwp *l)
{
	struct rdfpga_sdcard_softc *sd = device_lookup_private(&rdfpga_sdcard_cd, DISKUNIT(dev));
	struct dk_softc *dksc;

	if (sd == NULL) {
		aprint_error("%s:%d: sd == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	}
	
	dksc = &sd->dk;

	return dk_close(dksc, dev, flag, fmt, l);
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
	sc->dk.sc_dev = self;

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

	
	/* disk_init(&sc->dk.sc_dkdev, device_xname(sc->dk.sc_dev), &rdfpga_sdcard_dkdriver); */
	/* disk_attach(&sc->dk.sc_dkdev); */
	
	dk_init(&sc->dk, self, DKTYPE_FLASH);
	disk_init(&sc->dk.sc_dkdev, device_xname(sc->dk.sc_dev), &rdfpga_sdcard_dkdriver);
	dk_attach(&sc->dk);
	disk_attach(&sc->dk.sc_dkdev);
	rdfpga_sdcard_set_geometry(sc);

	bufq_alloc(&sc->dk.sc_bufq, BUFQ_DISK_DEFAULT_STRAT, BUFQ_SORT_RAWBLOCK); /* needed ? */

	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_blkshift = %d\n", sc->dk.sc_dkdev.dk_blkshift);
	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_byteshift = %d\n", sc->dk.sc_dkdev.dk_byteshift);
	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_label = %p\n", sc->dk.sc_dkdev.dk_label);
	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_cpulabel = %p\n", sc->dk.sc_dkdev.dk_cpulabel);

	
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
	  aprint_error_dev(sc->dk.sc_dev, "%s:%d:  timed out (%u after %u)\n", __PRETTY_FUNCTION__, __LINE__, ctrl, ctr);
    return EBUSY;
  }
  
  ctr = 0;
  while (((ctrl = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMA_CTRL)) != 0) &&
	 (ctr < count)) {
    delay(1);
    ctr ++;
  }

  if (ctrl) {
	  aprint_error_dev(sc->dk.sc_dev, "%s:%d:  timed out (%u after %u)\n", __PRETTY_FUNCTION__, __LINE__, ctrl, ctr);
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
    /* aprint_error_dev(sc->dk.sc_dev, "ctrl is 0x%08x (%d, old status 0x%08x, current 0x%08x)\n", ctrl, ctr, */
    /* 		     bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD), */
    /* 		     bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS)); */
    delay(1);
    ctr ++;
  }
  
  /* aprint_normal_dev(sc->dk.sc_dev, "ctrl is 0x%08x (%d, old status 0x%08x, current 0x%08x)\n", ctrl, ctr, */
  /* 		    bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS_OLD), */
  /* 		    bus_space_read_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_STATUS)); */


  if (ctrl) {
	  aprint_error_dev(sc->dk.sc_dev, "%s:%d:  timed out (%u after %u)\n", __PRETTY_FUNCTION__, __LINE__, ctrl, ctr);
    return EBUSY;
  }

  return rdfpga_sdcard_wait_dma_ready(sc, count);
}

static int rdfpga_sdcard_read_block(struct rdfpga_sdcard_softc *sc, const u_int32_t block, const u_int32_t blkcnt, void *data) {
  int res = 0;
  u_int32_t ctrl = 0;
  u_int32_t idx = 0;
  /* aprint_normal_dev(sc->dk.sc_dev, "Reading block %u from sdcard\n", block); */
  
  if ((res = rdfpga_sdcard_wait_device_ready(sc, 50000)) != 0)
    return res;
  
  if (bus_dmamem_alloc(sc->sc_dmatag, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, 64, 64, &sc->sc_segs, 1, &sc->sc_rsegs, BUS_DMA_NOWAIT | BUS_DMA_STREAMING)) {
    aprint_error_dev(sc->dk.sc_dev, "cannot allocate DVMA memory");
    return ENXIO;
  }
  
  void* kvap;
  if (bus_dmamem_map(sc->sc_dmatag, &sc->sc_segs, 1, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, &kvap, BUS_DMA_NOWAIT)) {
    aprint_error_dev(sc->dk.sc_dev, "cannot allocate DVMA address");
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }
  
  if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, /* kernel space */ NULL,
		      BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
    aprint_error_dev(sc->dk.sc_dev, "cannot load dma map");
    bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }
  
  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_PREWRITE);

  for (idx = 0 ; idx < blkcnt && !res; idx++) {
	  bus_addr_t addr = sc->sc_dmamap->dm_segs[0].ds_addr + 512 * idx;
	  
	  /* set DMA address */
	  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMAW_ADDR, (uint32_t)(addr));
	  /* set block to read */
	  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_ADDR, (block + idx));
	  ctrl = RDFPGA_SDCARD_CTRL_START | RDFPGA_SDCARD_CTRL_READ;
	  /* initiate reading block from SDcard; once the read request is acknowledged, the HW will start the DMA engine */
	  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL, ctrl);
	  
	  res = rdfpga_sdcard_wait_device_ready(sc, 100000);
  }

  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_POSTWRITE);
  
  bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
  /* aprint_normal_dev(sc->dk.sc_dev, "dma: unloaded\n"); */

  memcpy(data, kvap, blkcnt * 512);
  
  bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
	  /* aprint_normal_dev(sc->dk.sc_dev, "dma: unmapped\n"); */
  
  bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
  
  return res;
}


static int rdfpga_sdcard_write_block(struct rdfpga_sdcard_softc *sc, const u_int32_t block, void *data) {
  int res = 0;
  u_int32_t ctrl;
  /* aprint_normal_dev(sc->dk.sc_dev, "Reading Writing block %u from sdcard\n", block); */
  
  if ((res = rdfpga_sdcard_wait_device_ready(sc, 50000)) != 0)
    return res;
  
  if (bus_dmamem_alloc(sc->sc_dmatag, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, 64, 64, &sc->sc_segs, 1, &sc->sc_rsegs, BUS_DMA_NOWAIT | BUS_DMA_STREAMING)) {
    aprint_error_dev(sc->dk.sc_dev, "cannot allocate DVMA memory");
    return ENXIO;
  }
  
  void* kvap;
  if (bus_dmamem_map(sc->sc_dmatag, &sc->sc_segs, 1, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, &kvap, BUS_DMA_NOWAIT)) {
    aprint_error_dev(sc->dk.sc_dev, "cannot allocate DVMA address");
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }

  memcpy(kvap, data, 512);
  
  if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ, /* kernel space */ NULL,
		      BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_READ)) {
    aprint_error_dev(sc->dk.sc_dev, "cannot load dma map");
    bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
    bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
    return ENXIO;
  }
  
  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 512, BUS_DMASYNC_PREREAD);

  /* set DMA address */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_DMA_ADDR, (uint32_t)(sc->sc_dmamap->dm_segs[0].ds_addr));
  /* set block to read */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_ADDR, block);
  ctrl = RDFPGA_SDCARD_CTRL_START;
  /* initiate reading block from SDcard; once the read request is acknowledged, the HW will start the DMA engine */
  bus_space_write_4(sc->sc_bustag, sc->sc_bhregs, RDFPGA_SDCARD_REG_CTRL, ctrl);

  res = rdfpga_sdcard_wait_device_ready(sc, 100000);

  bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 512, BUS_DMASYNC_POSTREAD);
  
  bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
  /* aprint_normal_dev(sc->dk.sc_dev, "dma: unloaded\n"); */

  //memcpy(data, kvap, 512);
  
  bus_dmamem_unmap(sc->sc_dmatag, kvap, RDFPGA_SDCARD_VAL_DMA_MAX_SZ);
	  /* aprint_normal_dev(sc->dk.sc_dev, "dma: unmapped\n"); */
  
  bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
  
  return res;
}


void
rdfpga_sdcard_strategy(struct buf *bp)
{
	struct rdfpga_sdcard_softc *sc = device_lookup_private(&rdfpga_sdcard_cd, DISKUNIT(bp->b_dev));
	
	dk_strategy(&sc->dk, bp);
}

static void	rdfpga_sdcard_set_geometry(struct rdfpga_sdcard_softc *sc) {
	struct dk_softc *dksc = &sc->dk;
	struct disk_geom *dg = &dksc->sc_dkdev.dk_geom;

	memset(dg, 0, sizeof(*dg));

	dg->dg_secsize = 512;
	dg->dg_nsectors = 32; //63;
	dg->dg_ntracks = 64; //255;
	dg->dg_ncylinders = 30528; //3892;
	dg->dg_secpercyl = dg->dg_nsectors * dg->dg_ntracks;
	dg->dg_secperunit = 62521344; //dg->dg_secpercyl * dg->dg_ncylinders;
	dg->dg_pcylinders = 30528; //3892;
	dg->dg_sparespertrack = 0;
	dg->dg_sparespercyl = 0;

	disk_set_info(dksc->sc_dev, &dksc->sc_dkdev, "rdfpga_sdcard");
}


int
rdfpga_sdcard_size(dev_t dev) {
	return 62521344;
}

static void
rdfpga_sdcard_minphys(struct buf *bp)
{
	if (bp->b_bcount > RDFPGA_SDCARD_VAL_DMA_MAX_SZ)
		bp->b_bcount = RDFPGA_SDCARD_VAL_DMA_MAX_SZ;
}

static int
rdfpga_sdcard_diskstart(device_t self, struct buf *bp)
{	
	struct rdfpga_sdcard_softc *sc = device_private(self);
	int err = 0;
	if (sc == NULL) {
		aprint_error("%s:%d: sc == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		err = EINVAL;
		goto done;
	}
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: part %d\n", __PRETTY_FUNCTION__, __LINE__, DISKPART(bp->b_dev)); */
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_bflags = 0x%08x\n", __PRETTY_FUNCTION__, __LINE__, bp->b_flags); */
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_bufsize = %d\n", __PRETTY_FUNCTION__, __LINE__, bp->b_bufsize); */
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_blkno = %lld\n", __PRETTY_FUNCTION__, __LINE__, bp->b_blkno); */
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_rawblkno = %lld\n", __PRETTY_FUNCTION__, __LINE__, bp->b_rawblkno); */
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_bcount = %d\n", __PRETTY_FUNCTION__, __LINE__, bp->b_bcount); */

	bp->b_resid = bp->b_bcount;

	if (bp->b_bcount == 0) {
		goto done;
	}

	if (bp->b_flags & B_READ) {
		unsigned char* data = bp->b_data;
		daddr_t blk = bp->b_rawblkno;
		/* struct partition *p = NULL; */
		
		/* if (DISKPART(bp->b_dev) != RAW_PART) { */
		/* 	if ((err = bounds_check_with_label(&sc->dk.sc_dkdev, bp, 0)) <= 0) { */
		/* 		aprint_error("%s:%d: bounds_check_with_label -> %d\n", __PRETTY_FUNCTION__, __LINE__, err); */
		/* 		bp->b_resid = bp->b_bcount; */
		/* 		goto done; */
		/* 	} */
		/* 	p = &sc->dk.sc_dkdev.dk_label->d_partitions[DISKPART(bp->b_dev)]; */
		/* 	blk = bp->b_blkno + p->p_offset; */
		/* } */
		
		while (bp->b_resid >= 512 && !err) {
			u_int32_t blkcnt = bp->b_resid / 512;
			
			if (blkcnt > (RDFPGA_SDCARD_VAL_DMA_MAX_SZ/512))
				blkcnt = (RDFPGA_SDCARD_VAL_DMA_MAX_SZ/512);
			
			if (blk+blkcnt <= 62521344) {
				err = rdfpga_sdcard_read_block(sc, blk, blkcnt, data);
			} else {
				aprint_error("%s:%d: blk = %lld read out of range! giving up\n", __PRETTY_FUNCTION__, __LINE__, blk);
				err = EINVAL;
			}
			blk += blkcnt;
			data += 512 * blkcnt;
			bp->b_resid -= 512 * blkcnt;
		}
	} else {
#if 1
		err = EINVAL;
	aprint_normal_dev(sc->dk.sc_dev, "%s:%d: part %d\n", __PRETTY_FUNCTION__, __LINE__, DISKPART(bp->b_dev));
	aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_bflags = 0x%08x\n", __PRETTY_FUNCTION__, __LINE__, bp->b_flags);
	aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_bufsize = %d\n", __PRETTY_FUNCTION__, __LINE__, bp->b_bufsize);
	aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_blkno = %lld\n", __PRETTY_FUNCTION__, __LINE__, bp->b_blkno);
	aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_rawblkno = %lld\n", __PRETTY_FUNCTION__, __LINE__, bp->b_rawblkno);
	aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_bcount = %d\n", __PRETTY_FUNCTION__, __LINE__, bp->b_bcount);
#else
		unsigned char* data = bp->b_data;
		daddr_t blk = bp->b_rawblkno;
		/* struct partition *p = NULL; */
		
		/* if (DISKPART(bp->b_dev) != RAW_PART) { */
		/* 	if (bounds_check_with_label(&sc->dk.sc_dkdev, bp, 0) <= 0) { */
		/* 		bp->b_resid = bp->b_bcount; */
		/* 		goto done; */
		/* 	} */
		/* 	p = &sc->dk.sc_dkdev.dk_label->d_partitions[DISKPART(bp->b_dev)]; */
		/* 	blk = bp->b_blkno + p->p_offset; */
		/* } */
		
		while (bp->b_resid >= 512 && !err) {
			if (blk < 62521344) {
				err = rdfpga_sdcard_write_block(sc, blk, data);
			} else {
				aprint_error("%s:%d: blk = %lld write out of range! giving up\n", __PRETTY_FUNCTION__, __LINE__, blk);
				err = EINVAL;
			}
			blk ++;
			data += 512;
			bp->b_resid -= 512;
		}
#endif
	}
	
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_resid = %d\n", __PRETTY_FUNCTION__, __LINE__, bp->b_resid); */
	/* aprint_normal_dev(sc->dk.sc_dev, "%s:%d: bp->b_error = %d\n", __PRETTY_FUNCTION__, __LINE__, bp->b_error); */
	
 done:
	biodone(bp);
	return err;
}
