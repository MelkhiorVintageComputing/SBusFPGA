/*	$NetBSD$ */

/*-
 * Copyright (c) 2021 Romain Dolbeau <romain@dolbeau.org>
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

#include <dev/sbus/sbusvar.h>

#include <sys/disklabel.h>
#include <sys/disk.h>
#include <sys/buf.h>

#include <sys/bufq.h>
#include <dev/dkvar.h>

#include <dev/sbus/sbusfpga_sdram.h>

#include <machine/param.h>

#include <uvm/uvm_extern.h>

int	sbusfpga_sdram_match(device_t, cfdata_t, void *);
void	sbusfpga_sdram_attach(device_t, device_t, void *);

//#define USE_INTR

#ifdef USE_INTR
static int sbusfpga_sdram_intr(void *p);
static void sbusfpga_sdram_soft_intr(void *p);
#endif

CFATTACH_DECL_NEW(sbusfpga_sdram, sizeof(struct sbusfpga_sdram_softc),
    sbusfpga_sdram_match, sbusfpga_sdram_attach, NULL, NULL);

dev_type_open(sbusfpga_sdram_open);
dev_type_close(sbusfpga_sdram_close);
dev_type_read(sbusfpga_sdram_read);
dev_type_write(sbusfpga_sdram_write);
dev_type_ioctl(sbusfpga_sdram_ioctl);
dev_type_strategy(sbusfpga_sdram_strategy);
dev_type_size(sbusfpga_sdram_size);

const struct bdevsw sbusfpga_sdram_bdevsw = {
    .d_open = sbusfpga_sdram_open,
    .d_close = sbusfpga_sdram_close,
    .d_strategy = sbusfpga_sdram_strategy,
    .d_ioctl = sbusfpga_sdram_ioctl,
    .d_dump = nodump,
    .d_psize = sbusfpga_sdram_size,
    .d_discard = nodiscard,
    .d_flag = D_DISK
};

const struct cdevsw sbusfpga_sdram_cdevsw = {
	.d_open = sbusfpga_sdram_open,
	.d_close = sbusfpga_sdram_close,
	.d_read = sbusfpga_sdram_read,
	.d_write = sbusfpga_sdram_write,
	.d_ioctl = sbusfpga_sdram_ioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = nommap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = D_DISK
};

static void	sbusfpga_sdram_set_geometry(struct sbusfpga_sdram_softc *sc);
static void sbusfpga_sdram_minphys(struct buf *);
static void sbusfpga_sdram_iosize(device_t, int *);
static int sbusfpga_sdram_diskstart(device_t self, struct buf *bp);

struct dkdriver sbusfpga_sdram_dkdriver = {
	.d_strategy = sbusfpga_sdram_strategy,
	.d_minphys = sbusfpga_sdram_minphys,
	.d_iosize = sbusfpga_sdram_iosize,
	.d_diskstart = sbusfpga_sdram_diskstart
};

extern struct cfdriver sbusfpga_sdram_cd;

#ifndef USE_INTR
static int sbusfpga_sdram_read_block(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt, void *data);
static int sbusfpga_sdram_write_block(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt, void *data);
#endif
#ifdef USE_INTR
static int sbusfpga_sdram_read_block_async(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt);
static int sbusfpga_sdram_write_block_async(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt);
static void enable_irq(struct sbusfpga_sdram_softc *sc);
static void reset_irq(struct sbusfpga_sdram_softc *sc);
#endif

int
sbusfpga_sdram_open(dev_t dev, int flag, int fmt, struct lwp *l)
{
	struct sbusfpga_sdram_softc *sd = device_lookup_private(&sbusfpga_sdram_cd, DISKUNIT(dev));
	struct dk_softc *dksc;
	int error = 0;

	if (sd == NULL) {
		aprint_error("%s:%d: sd == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	} else {
		aprint_normal("%s:%d: open device %d, part is %d\n", __PRETTY_FUNCTION__, __LINE__, DISKUNIT(dev), DISKPART(dev));
	}
	dksc = &sd->dk;

	if (!device_is_active(dksc->sc_dev)) {
		return (ENODEV);
	}

	error = dk_open(dksc, dev, flag, fmt, l);

	return error;
}

int
sbusfpga_sdram_close(dev_t dev, int flag, int fmt, struct lwp *l)
{
	struct sbusfpga_sdram_softc *sd = device_lookup_private(&sbusfpga_sdram_cd, DISKUNIT(dev));
	struct dk_softc *dksc;
	int error = 0;

	if (sd == NULL) {
		aprint_error("%s:%d: sd == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	}

	dksc = &sd->dk;

	error = dk_close(dksc, dev, flag, fmt, l);

	return error;
}

int
sbusfpga_sdram_read(dev_t dev, struct uio *uio, int flags)
{
	return physio(sbusfpga_sdram_strategy, NULL, dev, B_READ, sbusfpga_sdram_minphys, uio);
}

int
sbusfpga_sdram_write(dev_t dev, struct uio *uio, int flags)
{
	return physio(sbusfpga_sdram_strategy, NULL, dev, B_WRITE, sbusfpga_sdram_minphys, uio);
}

int
sbusfpga_sdram_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("RDOL,sdram", sa->sa_name) == 0);
}

int
sdram_init(struct sbusfpga_sdram_softc *sc);

static int
dma_init(struct sbusfpga_sdram_softc *sc);
static int
dma_uninit(struct sbusfpga_sdram_softc *sc);

static int
dma_memtest(struct sbusfpga_sdram_softc *sc);

/*
 * Attach all the sub-devices we can find
 */
void
sbusfpga_sdram_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct sbusfpga_sdram_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int node;
	int sbusburst;
		
	sc->sc_bustag = sa->sa_bustag;
	sc->sc_dmatag = sa->sa_dmatag;
	sc->dk.sc_dev = self;

	aprint_normal("\n");

	if (sa->sa_nreg < 3) {
		aprint_error(": Not enough registers spaces\n");
		return;
	}

	/* map DDR PHY */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[0].oa_space /* sa_slot */,
					 sa->sa_reg[0].oa_base /* sa_offset */,
					 sa->sa_reg[0].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_ddrphy) != 0) {
		aprint_error(": cannot map DDR PHY registers\n");
		return;
	} else {
		aprint_normal_dev(self, "DDR PHY registers @ %p\n", (void*)sc->sc_bhregs_ddrphy);
	}
	/* map SDRAM DFII */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[1].oa_space /* sa_slot */,
					 sa->sa_reg[1].oa_base /* sa_offset */,
					 sa->sa_reg[1].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_sdram) != 0) {
		aprint_error(": cannot map SDRAM DFII registers\n");
		return;
	} else {
		aprint_normal_dev(self, "SDRAM DFII registers @ %p\n", (void*)sc->sc_bhregs_sdram);
	}
	/* custom DMA */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[2].oa_space /* sa_slot */,
					 sa->sa_reg[2].oa_base /* sa_offset */,
					 sa->sa_reg[2].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_exchange_with_mem) != 0) {
		aprint_error(": cannot map DMA registers\n");
		return;
	} else {
		aprint_normal_dev(self, "DMA registers @ %p\n", (void*)sc->sc_bhregs_exchange_with_mem);
	}
#if 0
	if (sa->sa_nreg >= 4) {
		/* if we map some of the memory itself */
		/* normally disabled, it's a debug feature */
		if (sbus_bus_map(sc->sc_bustag,
						 sa->sa_reg[3].oa_space /* sa_slot */,
						 sa->sa_reg[3].oa_base /* sa_offset */,
						 sa->sa_reg[3].oa_size /* sa_size */,
						 BUS_SPACE_MAP_LINEAR,
						 &sc->sc_bhregs_mmap) != 0) {
			aprint_error(": cannot map MMAP\n");
			return;
		} else {
			aprint_normal_dev(self, "MMAP @ %p\n", (void*)sc->sc_bhregs_mmap);
		}
		sc->sc_bufsiz_mmap = sa->sa_reg[3].oa_size;
	} else {
		sc->sc_bufsiz_mmap = 0;
	}
#else
	sc->sc_bufsiz_mmap = 0;
#endif
	
	sc->sc_bufsiz_ddrphy = sa->sa_reg[0].oa_size;
	sc->sc_bufsiz_sdram = sa->sa_reg[1].oa_size;
	sc->sc_bufsiz_exchange_with_mem = sa->sa_reg[2].oa_size;

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

	aprint_normal_dev(self, "nid 0x%x, bustag %p, burst 0x%x (parent 0x%0x)\n",
			  sc->sc_node,
			  sc->sc_bustag,
			  sc->sc_burst,
			  sbsc->sc_burst);
	
	  // the controller is now initialized in the PROM from values computed by sdram_init()
	  // if the board isn't a ZTex 2.13a with a 100 MHz core, new bitslip/delays value might be needed
	/*
	if (!sdram_init(sc)) {
		aprint_error_dev(self, "couldn't initialize SDRAM\n");
		return;
	}
	*/
	if (!dma_init(sc)) {
		aprint_error_dev(self, "couldn't initialize DMA for SDRAM\n");
		return;
	}

	if (!dma_memtest(sc)) { // in PIO mode, irq not yet enabled
		aprint_error_dev(self, "DMA-MEMTEST failed for SDRAM\n");
		return;
	}
	
	if (!dma_uninit(sc)) {
		aprint_error_dev(self, "couldn't un-initialize DMA\n");
		return;
	}

	sc->bp = NULL;
	
	mutex_init(&sc->sc_lock, MUTEX_DEFAULT, IPL_NONE);

#ifdef USE_INTR
	/* Map and establish the interrupt. */
	if (sa->sa_nintr != 0) {
		int ipl_pri = sbsc->sc_intr2ipl[sa->sa_pri];
		sc->sc_ih = bus_intr_establish(sc->sc_bustag, sa->sa_pri,
									   ipl_pri, sbusfpga_sdram_intr, sc);
		if (sc->sc_ih == NULL) {
			/* FIXME: CLEANUP */
			aprint_error_dev(self, "couldn't establish interrupt (%d)\n", sa->sa_nintr);
			return;
		} else 
			aprint_normal_dev(self, "interrupting at %d / %d / %d\n", sa->sa_nintr, sa->sa_pri, ipl_pri);
		enable_irq(sc);
		mutex_init(&sc->sc_intr_lock, MUTEX_DEFAULT, ipl_pri);
		sc->sc_sih = softint_establish(SOFTINT_BIO, sbusfpga_sdram_soft_intr, sc);
		if (sc->sc_sih == NULL) {
			aprint_error_dev(self, "couldn't establish soft interrupt\n");
			/* FIXME: CLEANUP */
			return;
		}
	} else {
		aprint_error_dev(self, "no interrupt defined in PROM\n");
		/* FIXME: CLEANUP */
		return;
	}
#endif

	/* we seem OK hardware-wise */
	dk_init(&sc->dk, self, DKTYPE_FLASH);
	disk_init(&sc->dk.sc_dkdev, device_xname(sc->dk.sc_dev), &sbusfpga_sdram_dkdriver);
	dk_attach(&sc->dk);
	disk_attach(&sc->dk.sc_dkdev);
	sbusfpga_sdram_set_geometry(sc);
	
	bufq_alloc(&sc->dk.sc_bufq, BUFQ_DISK_DEFAULT_STRAT, BUFQ_SORT_RAWBLOCK);

	/*
	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_blkshift = %d\n", sc->dk.sc_dkdev.dk_blkshift);
	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_byteshift = %d\n", sc->dk.sc_dkdev.dk_byteshift);
	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_label = %p\n", sc->dk.sc_dkdev.dk_label);
	aprint_normal_dev(self, "sc->dk.sc_dkdev.dk_cpulabel = %p\n", sc->dk.sc_dkdev.dk_cpulabel);
	*/
}

void
sbusfpga_sdram_strategy(struct buf *bp)
{
	struct sbusfpga_sdram_softc *sc = device_lookup_private(&sbusfpga_sdram_cd, DISKUNIT(bp->b_dev));
	
	dk_strategy(&sc->dk, bp);
}

static void	sbusfpga_sdram_set_geometry(struct sbusfpga_sdram_softc *sc) {
	struct dk_softc *dksc = &sc->dk;
	struct disk_geom *dg = &dksc->sc_dkdev.dk_geom;

	memset(dg, 0, sizeof(*dg));

	dg->dg_secsize = 512;
	dg->dg_nsectors = 2;
	dg->dg_ntracks = 4;
	dg->dg_ncylinders = sc->dma_real_mem_size / (dg->dg_secsize * dg->dg_nsectors * dg->dg_ntracks);
	dg->dg_secpercyl = dg->dg_nsectors * dg->dg_ntracks;
	dg->dg_secperunit = dg->dg_secpercyl * dg->dg_ncylinders;
	dg->dg_pcylinders = dg->dg_ncylinders;
	dg->dg_sparespertrack = 0;
	dg->dg_sparespercyl = 0;

	disk_set_info(dksc->sc_dev, &dksc->sc_dkdev, "sbusfpga_sdram");
}

int
sbusfpga_sdram_size(dev_t dev) {
	struct sbusfpga_sdram_softc *sc = device_lookup_private(&sbusfpga_sdram_cd, DISKUNIT(dev));
	if (sc == NULL)
		return -1;

	if (!device_is_active(sc->dk.sc_dev)) {
		return -1;
	}
	
	return dk_size(&sc->dk, dev);
}

static void
sbusfpga_sdram_minphys(struct buf *bp)
{
	if (bp->b_bcount > SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ)
		bp->b_bcount = SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ;
}
static void
sbusfpga_sdram_iosize(device_t dev, int *count)
{
	if (*count > SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ)
		*count = SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ;
}

#define CONFIG_CSR_DATA_WIDTH 32
/* grrr */
#define sbusfpga_exchange_with_mem_softc sbusfpga_sdram_softc
#define sbusfpga_ddrphy_softc sbusfpga_sdram_softc
#include "dev/sbus/sbusfpga_csr_exchange_with_mem.h"
#include "dev/sbus/sbusfpga_csr_ddrphy.h"
#include "dev/sbus/sbusfpga_csr_sdram.h"

#define DMA_STATUS_CHECK_BITS (0x01F)

#ifdef USE_INTR
/* asynchronous version, completin in interrupt
 * doesn't work
 */
static int
sbusfpga_sdram_diskstart(device_t self, struct buf *bp)
{	
	struct sbusfpga_sdram_softc *sc = device_private(self);
	int err = 0;
	if (sc == NULL) {
		aprint_error("%s:%d: sc == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		err = EINVAL;
		return err;
	}

	mutex_enter(&sc->sc_lock);
	
	//device_printf(sc->dk.sc_dev, "%s:\n", __PRETTY_FUNCTION__);
		
	if (sc->bp != NULL) {
			err = EAGAIN;
			mutex_exit(&sc->sc_lock);
			return err;
	}
	
	bp->b_resid = bp->b_bcount;

	if (bp->b_bcount == 0) {
		mutex_exit(&sc->sc_lock);
		dk_done(&sc->dk, bp);
		return err;
	}
	unsigned char* data = bp->b_data;
	daddr_t blk = bp->b_rawblkno;
	u_int32_t blkcnt = bp->b_resid / 512;
			
	if (blkcnt > (SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ/512)) {
		mutex_exit(&sc->sc_lock);
		aprint_error("%s:%d: blkcnt = %u too large! giving up\n", __PRETTY_FUNCTION__, __LINE__, blkcnt);
		err = EINVAL;
		return err;
	}
	if (blk+blkcnt > (sc->dma_real_mem_size / 512)) {
		mutex_exit(&sc->sc_lock);
		aprint_error("%s:%d: blk = %lld read out of range! giving up\n", __PRETTY_FUNCTION__, __LINE__, blk);
		err = EINVAL;
		return err;
	}

	if (bp->b_flags & B_READ) {
		if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, data, blkcnt * 512, /* kernel space */ NULL,
							BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
			mutex_exit(&sc->sc_lock);
			err = ENOMEM;
			return err;
		}
		bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_PREWRITE);
		sc->bp = bp;
		err = sbusfpga_sdram_read_block_async(sc, blk, blkcnt);
		if (err)
			sc->bp = NULL;
	} else {
		if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, data, blkcnt * 512, /* kernel space */ NULL,
							BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_READ)) {
			mutex_exit(&sc->sc_lock);
			err = ENOMEM;
			return err;
		}
		bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_PREREAD);
		sc->bp = bp;
		err = sbusfpga_sdram_write_block_async(sc, blk, blkcnt);
		if (err)
			sc->bp = NULL;
	}
	
	mutex_exit(&sc->sc_lock);
	return err;
}
#else
/* synchronous version */
static int
sbusfpga_sdram_diskstart(device_t self, struct buf *bp)
{	
	struct sbusfpga_sdram_softc *sc = device_private(self);
	int err = 0;
	if (sc == NULL) {
		aprint_error("%s:%d: sc == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		err = EINVAL;
		goto done;
	}
	
	bp->b_resid = bp->b_bcount;

	if (bp->b_bcount == 0) {
		goto done;
	}
					
	if (bp->b_flags & B_READ) {
		unsigned char* data = bp->b_data;
		daddr_t blk = bp->b_rawblkno;
		
		while (bp->b_resid >= 512 && !err) {
			u_int32_t blkcnt = bp->b_resid / 512;
			
			if (blkcnt > (SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ/512))
				blkcnt = (SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ/512);
			
			if (blk+blkcnt <= (sc->dma_real_mem_size / 512)) {
				err = sbusfpga_sdram_read_block(sc, blk, blkcnt, data);
			} else {
				aprint_error("%s:%d: blk = %lld read out of range! giving up\n", __PRETTY_FUNCTION__, __LINE__, blk);
				err = EINVAL;
				break;
			}
			blk += blkcnt;
			data += 512 * blkcnt;
			bp->b_resid -= 512 * blkcnt;
		}
	} else {
		unsigned char* data = bp->b_data;
		daddr_t blk = bp->b_rawblkno;
		
		while (bp->b_resid >= 512 && !err) {
			u_int32_t blkcnt = bp->b_resid / 512;
			
			if (blkcnt > (SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ/512))
				blkcnt = (SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ/512);
			
			if (blk+blkcnt <= (sc->dma_real_mem_size / 512)) {
				err = sbusfpga_sdram_write_block(sc, blk, blkcnt, data);
			} else {
				aprint_error("%s:%d: blk = %lld write out of range! giving up\n", __PRETTY_FUNCTION__, __LINE__, blk);
				err = EINVAL;
				break;
			}
			blk += blkcnt;
			data += 512 * blkcnt;
			bp->b_resid -= 512 * blkcnt;
		}
	}
	
 done:
	dk_done(&sc->dk, bp);
	return err;
}
#endif

#ifdef USE_INTR
static void sbusfpga_sdram_soft_intr(void *p) {
	struct sbusfpga_sdram_softc *sc = (struct sbusfpga_sdram_softc *)p;
	struct buf *bp;
	
	//device_printf(sc->dk.sc_dev, "%s:\n", __PRETTY_FUNCTION__);
	
	mutex_enter(&sc->sc_lock);

	bp = sc->bp;
	sc->bp = NULL;

	if ((exchange_with_mem_blk_cnt_read(sc) != 0) ||
		((exchange_with_mem_dma_status_read(sc) & DMA_STATUS_CHECK_BITS) != 0)) {
		device_printf(sc->dk.sc_dev, "interrupt while previous transaction didn't finish ?!?\n");
	}
	
	u_int32_t blkcnt = bp->b_resid / 512;
	
	if (bp->b_flags & B_READ) {
		bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_POSTWRITE);
	} else {
		bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_POSTREAD);
	}
	bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
	
	bp->b_resid -= 512 * blkcnt;
	
	mutex_exit(&sc->sc_lock);
	
	dk_done(&sc->dk, bp);
}
#endif

#ifdef USE_INTR
static int sbusfpga_sdram_intr(void *p) {
	struct sbusfpga_sdram_softc *sc = (struct sbusfpga_sdram_softc *)p;

	//device_printf(sc->dk.sc_dev, "%s:\n", __PRETTY_FUNCTION__);
	
	mutex_spin_enter(&sc->sc_intr_lock);
	
	reset_irq(sc);

	if (sc->bp == NULL) {
		mutex_spin_exit(&sc->sc_intr_lock);
		device_printf(sc->dk.sc_dev, "interrupt with no pending transaction...\n");
		return 1;
	}
	
	softint_schedule(sc->sc_sih);
	
	mutex_spin_exit(&sc->sc_intr_lock);

	return 1;
}
#endif

#ifdef USE_INTR
static void enable_irq(struct sbusfpga_sdram_softc *sc) {
	exchange_with_mem_irqctrl_write(sc, 0x3); // enable & clear interrupt
	//exchange_with_mem_irqctrl_write(sc, 0x1); // enable interrupt
	aprint_normal_dev(sc->dk.sc_dev, "irq ctrl: 0x%08x\n", exchange_with_mem_irqctrl_read(sc));
}
static void reset_irq(struct sbusfpga_sdram_softc *sc) {
	exchange_with_mem_irqctrl_write(sc, 0x3); // enable & clear interrupt
}
#endif

int
sbusfpga_sdram_ioctl (dev_t dev, u_long cmd, void *data, int flag, struct lwp *l)
{
	struct sbusfpga_sdram_softc *sc = device_lookup_private(&sbusfpga_sdram_cd, DISKUNIT(dev));
	int err = 0;//, err2 = 0;

	if (sc == NULL) {
		aprint_error("%s:%d: sc == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	}
	
	err = dk_ioctl(&sc->dk, dev, cmd, data, flag, l);
	/*if (err2 != EPASSTHROUGH)
		err = err2;
	else
	err = ENOTTY;*/

	return err;
}

static int
dma_init(struct sbusfpga_sdram_softc *sc) {
	sc->dma_blk_size = exchange_with_mem_blk_size_read(sc);
	sc->dma_blk_base = exchange_with_mem_blk_base_read(sc);
	sc->dma_mem_size = exchange_with_mem_mem_size_read(sc);
	sc->dma_real_mem_size = sc->dma_mem_size * sc->dma_blk_size;
	aprint_normal_dev(sc->dk.sc_dev, "DMA: HW -> block size is %d, base address is 0x%08x (%d MiB)\n",
					  sc->dma_blk_size,
					  sc->dma_blk_base * sc->dma_blk_size,
					  sc->dma_real_mem_size / 1048576);
	
	/* Allocate a dmamap */
	if (bus_dmamap_create(sc->sc_dmatag, SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ, 1, SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ, 0, BUS_DMA_NOWAIT | BUS_DMA_ALLOCNOW, &sc->sc_dmamap) != 0) {
		aprint_error_dev(sc->dk.sc_dev, "DMA map create failed\n");
		return 0;
	} else {
		aprint_normal_dev(sc->dk.sc_dev, "dmamap: %lu %lu %d (%p)\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs, sc->sc_dmatag->_dmamap_load);
	}

	if (bus_dmamem_alloc(sc->sc_dmatag, SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ, 64, 64, &sc->sc_segs, 1, &sc->sc_rsegs, BUS_DMA_NOWAIT | BUS_DMA_STREAMING)) {
		aprint_error_dev(sc->dk.sc_dev, "cannot allocate DVMA memory");
		bus_dmamap_destroy(sc->sc_dmatag, sc->sc_dmamap);
		return 0;
	}
  
	if (bus_dmamem_map(sc->sc_dmatag, &sc->sc_segs, 1, SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ, &sc->sc_dma_kva, BUS_DMA_NOWAIT)) {
		aprint_error_dev(sc->dk.sc_dev, "cannot allocate DVMA address");
		bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
		bus_dmamap_destroy(sc->sc_dmatag, sc->sc_dmamap);
		return 0;
	}
  
	if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, sc->sc_dma_kva, SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ, /* kernel space */ NULL,
						BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
		aprint_error_dev(sc->dk.sc_dev, "cannot load dma map");
		bus_dmamem_unmap(sc->sc_dmatag, sc->sc_dma_kva, SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ);
		bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
		bus_dmamap_destroy(sc->sc_dmatag, sc->sc_dmamap);
		return 0;
	}
	
	aprint_normal_dev(sc->dk.sc_dev, "DMA: SW -> kernel address is %p, dvma address is 0x%08llx\n", sc->sc_dma_kva, sc->sc_dmamap->dm_segs[0].ds_addr);
	
	return 1;
}


static int
dma_uninit(struct sbusfpga_sdram_softc *sc) {
	bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
	bus_dmamem_unmap(sc->sc_dmatag, sc->sc_dma_kva, SBUSFPGA_SDRAM_VAL_DMA_MAX_SZ);
	bus_dmamem_free(sc->sc_dmatag, &sc->sc_segs, 1);
	sc->sc_dma_kva = NULL;
	sc->sc_rsegs = 0;
	
	return 1;
}


/* tuned on my SPARCstation 20 with 25 MHz SBus & 2*SM61 */
/* asynchronous would be better ... */
#define DEF_BLK_DELAY 14

static inline unsigned long 
lfsr (unsigned long  bits, unsigned long  prev);

static int
dma_memtest(struct sbusfpga_sdram_softc *sc) {
	unsigned long *kva_ulong = (unsigned long*)sc->sc_dma_kva;
	unsigned long val;
	unsigned int blkn = 0; // 113;
	const unsigned int testdatasize = 4096;
	unsigned int blkcnt ;
	int count;

	aprint_normal_dev(sc->dk.sc_dev, "Initializing DMA buffer.\n");
	
	val = 0xDEADBEEF;
	for (int i = 0 ; i < testdatasize/sizeof(unsigned long) ; i++) {
		val = lfsr(32, val);
		kva_ulong[i] = val;
	}
	aprint_normal_dev(sc->dk.sc_dev, "First / last value: 0x%08lx 0x%08lx\n", kva_ulong[0], kva_ulong[(testdatasize/sizeof(unsigned long))-1]);

#if 0
	if (sc->sc_bufsiz_mmap > 0) {
		int idx = blkn * sc->dma_blk_size / sizeof(unsigned long), x;
		int bound = sc->sc_bufsiz_mmap / sizeof(unsigned long);
		if (bound > idx) {
			if ((bound - idx) > 10)
				bound = idx + 10;
			count = 0;
			for (x = idx ; x < bound; x++) {
				unsigned long data = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs_mmap, x*sizeof(unsigned long));
				aprint_normal_dev(sc->dk.sc_dev, "Prior to write [mmap] at %d: 0x%08lx\n", x, data);
			}
		}
	}
#endif

	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 4096, BUS_DMASYNC_PREREAD);

	aprint_normal_dev(sc->dk.sc_dev, "Starting DMA Write-to-Sdram.\n");
	
	exchange_with_mem_blk_addr_write(sc, blkn + sc->dma_blk_base);
	exchange_with_mem_dma_addr_write(sc, sc->sc_dmamap->dm_segs[0].ds_addr);
	exchange_with_mem_blk_cnt_write(sc, 0x80000000 | (testdatasize / sc->dma_blk_size));

	aprint_normal_dev(sc->dk.sc_dev, "DMA Write-to-Sdram started, polling\n");
	
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 4096, BUS_DMASYNC_POSTREAD);
  
	delay(DEF_BLK_DELAY * 8);

	count = 0;
	while (((blkcnt = exchange_with_mem_blk_cnt_read(sc)) != 0) && (count < 10)) {
		aprint_normal_dev(sc->dk.sc_dev, "DMA Write-to-Sdram ongoing (%u, status 0x%08x, lastblk req 0x%08x, last phys addr written 0x%08x)\n",
						  blkcnt & 0x0000FFFF,
						  exchange_with_mem_dma_status_read(sc),
						  exchange_with_mem_last_blk_read(sc),
						  exchange_with_mem_wr_tosdram_read(sc));
		count ++;
		delay(DEF_BLK_DELAY);
	}

	if (blkcnt) {
		aprint_error_dev(sc->dk.sc_dev, "DMA Write-to-Sdram didn't finish ? (%u, status 0x%08x, 0x%08x, 0x%08x, lastblk req 0x%08x, last phys addr written 0x%08x)\n",
						 blkcnt & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_wr_tosdram_read(sc));
		return 0;
	} else {
		aprint_normal_dev(sc->dk.sc_dev, "DMA Write-to-Sdram done (status 0x%08x, 0x%08x, 0x%08x, 0x%08x, last phys addr written 0x%08x)\n",
						  exchange_with_mem_dma_status_read(sc),
						  exchange_with_mem_last_blk_read(sc),
						  exchange_with_mem_last_dma_read(sc),
						  exchange_with_mem_blk_rem_read(sc),
						  exchange_with_mem_wr_tosdram_read(sc));
	}

	count = 0;
	while ((((blkcnt = exchange_with_mem_dma_status_read(sc)) & DMA_STATUS_CHECK_BITS) != 0) && (count < 10)) {
		aprint_normal_dev(sc->dk.sc_dev, "DMA Write-to-Sdram hasn't reached SDRAM yet (status 0x%08x)\n", blkcnt);
		count ++;
		delay(DEF_BLK_DELAY);
	}

	if (blkcnt & DMA_STATUS_CHECK_BITS) {
		aprint_error_dev(sc->dk.sc_dev, "DMA Write-to-Sdram can't reach SDRAM ? (%u, status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n", blkcnt & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc));
		return 0;
	} else {
		aprint_normal_dev(sc->dk.sc_dev, "DMA Write-to-Sdram has reached SDRAM (status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n",
						  exchange_with_mem_dma_status_read(sc),
						  exchange_with_mem_last_blk_read(sc),
						  exchange_with_mem_last_dma_read(sc),
						  exchange_with_mem_blk_rem_read(sc));
	}

#if 0
	if (sc->sc_bufsiz_mmap > 0) {
		int idx = blkn * sc->dma_blk_size / sizeof(unsigned long), x;
		int bound = sc->sc_bufsiz_mmap / sizeof(unsigned long);
		if (bound > idx) {
			count = 0;
			val = 0xDEADBEEF;
			if ((bound - idx) >  (testdatasize / sizeof(unsigned long)))
				bound = idx + (testdatasize / sizeof(unsigned long));
			for (x = idx ; x < bound && count < 10; x++) {
				unsigned long data = bus_space_read_4(sc->sc_bustag, sc->sc_bhregs_mmap, x*sizeof(unsigned long));
				val = lfsr(32, val);
				if (val != data) {
					aprint_error_dev(sc->dk.sc_dev, "Read-after-write [mmap] error at %d: 0x%08lx vs. 0x%08lx (0x%08lx)\n", x, data, val, val ^ data);
					count ++;
				}
			}
		}
	}
#endif

	for (int i = 0 ; i < testdatasize/sizeof(unsigned long) ; i++) {
		kva_ulong[i] = 0x0c0ffee0;
	}
	aprint_normal_dev(sc->dk.sc_dev, "First / last value: 0x%08lx 0x%08lx\n", kva_ulong[0], kva_ulong[(testdatasize/sizeof(unsigned long))-1]);

	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 4096, BUS_DMASYNC_PREWRITE);

	aprint_normal_dev(sc->dk.sc_dev, "Starting DMA Read-from-Sdram.\n");
	
	exchange_with_mem_blk_addr_write(sc, blkn + sc->dma_blk_base);
	exchange_with_mem_dma_addr_write(sc, sc->sc_dmamap->dm_segs[0].ds_addr);
	exchange_with_mem_blk_cnt_write(sc, 0x00000000 | (testdatasize / sc->dma_blk_size));

	aprint_normal_dev(sc->dk.sc_dev, "DMA Read-from-Sdram started, polling\n");
	
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, 4096, BUS_DMASYNC_POSTWRITE);

	delay(DEF_BLK_DELAY * 8);

	count = 0;
	while (((blkcnt = exchange_with_mem_blk_cnt_read(sc)) != 0) && (count < 10)) {
		aprint_normal_dev(sc->dk.sc_dev, "DMA Read-from-Sdram ongoing (%u, status 0x%08x)\n", blkcnt & 0x0000FFFF, exchange_with_mem_dma_status_read(sc));
		count ++;
		delay(DEF_BLK_DELAY);
	}

	if (blkcnt) {
		aprint_error_dev(sc->dk.sc_dev, "DMA Read-from-Sdram didn't finish ? (%u, status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n",
						 blkcnt & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc));
		return 0;
	} else {
		aprint_normal_dev(sc->dk.sc_dev, "DMA Read-from-Sdram done (status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n",
						  exchange_with_mem_dma_status_read(sc),
						  exchange_with_mem_last_blk_read(sc),
						  exchange_with_mem_last_dma_read(sc),
						  exchange_with_mem_blk_rem_read(sc));
	}

	count = 0;
	while ((((blkcnt = exchange_with_mem_dma_status_read(sc)) & DMA_STATUS_CHECK_BITS) != 0) && (count < 10)) {
		aprint_normal_dev(sc->dk.sc_dev, "DMA Read-from-Sdram hasn't reached memory yet (status 0x%08x)\n", blkcnt);
		count ++;
		delay(DEF_BLK_DELAY);
	}
	
	aprint_normal_dev(sc->dk.sc_dev, "First /last value: 0x%08lx 0x%08lx\n", kva_ulong[0], kva_ulong[(testdatasize/sizeof(unsigned long))-1]);

	if (blkcnt & DMA_STATUS_CHECK_BITS) {
		aprint_error_dev(sc->dk.sc_dev, "DMA  Read-from-Sdram can't reach memory ? (%u, status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n", blkcnt & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc));
		return 0;
	} else {
		aprint_normal_dev(sc->dk.sc_dev, "DMA  Read-from-Sdram has reached memory (status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n",
						  exchange_with_mem_dma_status_read(sc),
						  exchange_with_mem_last_blk_read(sc),
						  exchange_with_mem_last_dma_read(sc),
						  exchange_with_mem_blk_rem_read(sc));
	}
	
	count = 0;
	val = 0xDEADBEEF;
	for (int i = 0 ; i < testdatasize/sizeof(unsigned long) && count < 10; i++) {
		val = lfsr(32, val);
		if (kva_ulong[i] != val) {
			aprint_error_dev(sc->dk.sc_dev, "Read-after-write error at %d: 0x%08lx vs. 0x%08lx (0x%08lx)\n", i, kva_ulong[i], val, val ^ kva_ulong[i]);
			count ++;
		}
	}

	if (count)
		return 0;
   
	return 1;
}

#ifndef USE_INTR
static int sbusfpga_sdram_read_block(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt, void *data) {
	int res = 0;
	int count;
	unsigned int check;
	
	if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, data, blkcnt * 512, /* kernel space */ NULL,
						BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
		return ENOMEM;
	}
	
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_PREWRITE);
  
	exchange_with_mem_blk_addr_write(sc, sc->dma_blk_base + (block * 512 / sc->dma_blk_size) );
	exchange_with_mem_dma_addr_write(sc, sc->sc_dmamap->dm_segs[0].ds_addr);
	exchange_with_mem_blk_cnt_write(sc, 0x00000000 | (blkcnt * 512 / sc->dma_blk_size) );

	delay(DEF_BLK_DELAY * blkcnt);

	count = 0;
	while (((check = exchange_with_mem_blk_cnt_read(sc)) != 0) && (count < (4*blkcnt))) {
		count ++;
		delay(DEF_BLK_DELAY);
	}

	if (check) {
		aprint_error_dev(sc->dk.sc_dev, "DMA didn't finish ? (%u, status 0x%08x, 0x%08x, 0x%08x, lastblk req 0x%08x, last phys addr written 0x%08x)\n",
						 check & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_wr_tosdram_read(sc));
		res = ENXIO;
		goto done;
	}
#if 0
	else {
		aprint_normal_dev(sc->dk.sc_dev, "DMA READ finish for %d blk in %d attempts.\n", blkcnt, count);
	}
#endif

	count = 0;
	while ((((check = exchange_with_mem_dma_status_read(sc)) & DMA_STATUS_CHECK_BITS) != 0) && (count < blkcnt)) {
		//aprint_normal_dev(sc->dk.sc_dev, "DMA Write-to-Sdram hasn't reached SDRAM yet (status 0x%08x)\n", check);
		count ++;
		delay(DEF_BLK_DELAY);
	}
  
	if (check & DMA_STATUS_CHECK_BITS) {
		aprint_error_dev(sc->dk.sc_dev, "DMA can't reach memory/SDRAM ? (%u, status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n",
						 check & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc));
		res = ENXIO;
		goto done;
	} 
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_POSTWRITE);

 done:
	bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
  
	return res;
}
#endif

#ifndef USE_INTR
static int sbusfpga_sdram_write_block(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt, void *data) {
	int res = 0;
	int count;
	unsigned int check;
	
	if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, data, blkcnt * 512, /* kernel space */ NULL,
						BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_READ)) {
		return ENOMEM;
	}
	
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_PREREAD);
  
	exchange_with_mem_blk_addr_write(sc, sc->dma_blk_base + (block * 512 / sc->dma_blk_size) );
	exchange_with_mem_dma_addr_write(sc, sc->sc_dmamap->dm_segs[0].ds_addr);
	exchange_with_mem_blk_cnt_write(sc, 0x80000000 | (blkcnt * 512 / sc->dma_blk_size) );

	delay(DEF_BLK_DELAY * blkcnt);

	count = 0;
	while (((check = exchange_with_mem_blk_cnt_read(sc)) != 0) && (count < (4*blkcnt))) {
		count ++;
		delay(DEF_BLK_DELAY);
	}

	if (check) {
		aprint_error_dev(sc->dk.sc_dev, "DMA didn't finish ? (%u, status 0x%08x, 0x%08x, 0x%08x, lastblk req 0x%08x, last phys addr written 0x%08x)\n",
						 check & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_wr_tosdram_read(sc));
		res = ENXIO;
		goto done;
	}
#if 0
	else {
		aprint_normal_dev(sc->dk.sc_dev, "DMA WRITE finish for %d blk in %d attempts.\n", blkcnt, count);
	}
#endif

	count = 0;
	while ((((check = exchange_with_mem_dma_status_read(sc)) & DMA_STATUS_CHECK_BITS) != 0) && (count < blkcnt)) {
		//aprint_normal_dev(sc->dk.sc_dev, "DMA Read_from-Sdram hasn't reached SDRAM yet (status 0x%08x)\n", check);
		count ++;
		delay(DEF_BLK_DELAY);
	}
  
	if (check & DMA_STATUS_CHECK_BITS) {
		aprint_error_dev(sc->dk.sc_dev, "DMA can't reach memory/SDRAM ? (%u, status 0x%08x, 0x%08x, 0x%08x, 0x%08x)\n",
						 check & 0x0000FFFF,
						 exchange_with_mem_dma_status_read(sc),
						 exchange_with_mem_last_blk_read(sc),
						 exchange_with_mem_last_dma_read(sc),
						 exchange_with_mem_blk_rem_read(sc));
		res = ENXIO;
		goto done;
	} 
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, blkcnt * 512, BUS_DMASYNC_POSTREAD);

 done:
	bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);
	return res;
}
#endif

#ifdef USE_INTR
static int sbusfpga_sdram_read_block_async(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt) {
	int res = 0;
  
	exchange_with_mem_blk_addr_write(sc, sc->dma_blk_base + (block * 512 / sc->dma_blk_size) );
	exchange_with_mem_dma_addr_write(sc, sc->sc_dmamap->dm_segs[0].ds_addr);
	exchange_with_mem_blk_cnt_write(sc, 0x00000000 | (blkcnt * 512 / sc->dma_blk_size) );
  
	return res;
}
#endif

#ifdef USE_INTR
static int sbusfpga_sdram_write_block_async(struct sbusfpga_sdram_softc *sc, const u_int32_t block, const u_int32_t blkcnt) {
	int res = 0;
  
	exchange_with_mem_blk_addr_write(sc, sc->dma_blk_base + (block * 512 / sc->dma_blk_size) );
	exchange_with_mem_dma_addr_write(sc, sc->sc_dmamap->dm_segs[0].ds_addr);
	exchange_with_mem_blk_cnt_write(sc, 0x80000000 | (blkcnt * 512 / sc->dma_blk_size) );
  
	return res;
}
#endif

/* auto-generated sdram_phy.h + sc */
#define DFII_CONTROL_SEL        0x01
#define DFII_CONTROL_CKE        0x02
#define DFII_CONTROL_ODT        0x04
#define DFII_CONTROL_RESET_N    0x08

#define DFII_COMMAND_CS         0x01
#define DFII_COMMAND_WE         0x02
#define DFII_COMMAND_CAS        0x04
#define DFII_COMMAND_RAS        0x08
#define DFII_COMMAND_WRDATA     0x10
#define DFII_COMMAND_RDDATA     0x20

#define SDRAM_PHY_A7DDRPHY
#define SDRAM_PHY_XDR 2
#define SDRAM_PHY_DATABITS 16
#define SDRAM_PHY_PHASES 4
#define SDRAM_PHY_CL 6
#define SDRAM_PHY_CWL 5
#define SDRAM_PHY_CMD_LATENCY 0
#define SDRAM_PHY_RDPHASE 2
#define SDRAM_PHY_WRPHASE 3
#define SDRAM_PHY_WRITE_LATENCY_CALIBRATION_CAPABLE
#define SDRAM_PHY_READ_LEVELING_CAPABLE
#define SDRAM_PHY_MODULES SDRAM_PHY_DATABITS/8
#define SDRAM_PHY_DELAYS 32
#define SDRAM_PHY_BITSLIPS 8

void cdelay(int i);

__attribute__((unused)) static inline void command_p0(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi0_command_write(sc, cmd);
    sdram_dfii_pi0_command_issue_write(sc, 1);
}
__attribute__((unused)) static inline void command_p1(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi1_command_write(sc, cmd);
    sdram_dfii_pi1_command_issue_write(sc, 1);
}
__attribute__((unused)) static inline void command_p2(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi2_command_write(sc, cmd);
    sdram_dfii_pi2_command_issue_write(sc, 1);
}
__attribute__((unused)) static inline void command_p3(struct sbusfpga_sdram_softc *sc, int cmd)
{
    sdram_dfii_pi3_command_write(sc, cmd);
    sdram_dfii_pi3_command_issue_write(sc, 1);
}

#define DFII_PIX_DATA_SIZE CSR_SDRAM_DFII_PI0_WRDATA_SIZE

static inline unsigned long sdram_dfii_pix_wrdata_addr(int phase){
    switch (phase) {
        case 0: return CSR_SDRAM_DFII_PI0_WRDATA_ADDR;
		case 1: return CSR_SDRAM_DFII_PI1_WRDATA_ADDR;
		case 2: return CSR_SDRAM_DFII_PI2_WRDATA_ADDR;
		case 3: return CSR_SDRAM_DFII_PI3_WRDATA_ADDR;
        default: return 0;
        }
}
    
static inline unsigned long sdram_dfii_pix_rddata_addr(int phase){
    switch (phase) {
        case 0: return CSR_SDRAM_DFII_PI0_RDDATA_ADDR;
		case 1: return CSR_SDRAM_DFII_PI1_RDDATA_ADDR;
		case 2: return CSR_SDRAM_DFII_PI2_RDDATA_ADDR;
		case 3: return CSR_SDRAM_DFII_PI3_RDDATA_ADDR;
        default: return 0;
        }
}
    
#define DDRX_MR_WRLVL_ADDRESS 1
#define DDRX_MR_WRLVL_RESET 6
#define DDRX_MR_WRLVL_BIT 7

static inline void init_sequence(struct sbusfpga_sdram_softc *sc)
{
	/* Release reset */
	sdram_dfii_pi0_address_write(sc, 0x0);
	sdram_dfii_pi0_baddress_write(sc, 0);
	sdram_dfii_control_write(sc, DFII_CONTROL_ODT|DFII_CONTROL_RESET_N);
	cdelay(50000);

	/* Bring CKE high */
	sdram_dfii_pi0_address_write(sc, 0x0);
	sdram_dfii_pi0_baddress_write(sc, 0);
	sdram_dfii_control_write(sc, DFII_CONTROL_CKE|DFII_CONTROL_ODT|DFII_CONTROL_RESET_N);
	cdelay(10000);

	/* Load Mode Register 2, CWL=5 */
	sdram_dfii_pi0_address_write(sc, 0x200);
	sdram_dfii_pi0_baddress_write(sc, 2);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);

	/* Load Mode Register 3 */
	sdram_dfii_pi0_address_write(sc, 0x0);
	sdram_dfii_pi0_baddress_write(sc, 3);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);

	/* Load Mode Register 1 */
	sdram_dfii_pi0_address_write(sc, 0x6);
	sdram_dfii_pi0_baddress_write(sc, 1);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);

	/* Load Mode Register 0, CL=6, BL=8 */
	sdram_dfii_pi0_address_write(sc, 0x920);
	sdram_dfii_pi0_baddress_write(sc, 0);
	command_p0(sc, DFII_COMMAND_RAS|DFII_COMMAND_CAS|DFII_COMMAND_WE|DFII_COMMAND_CS);
	cdelay(200);

	/* ZQ Calibration */
	sdram_dfii_pi0_address_write(sc, 0x400);
	sdram_dfii_pi0_baddress_write(sc, 0);
	command_p0(sc, DFII_COMMAND_WE|DFII_COMMAND_CS);
	cdelay(200);
}

#define sbusfpga_common_softc sbusfpga_sdram_softc
#include "dev/sbus/sbusfpga_csr_common.h"

/* sdram.c from liblitedram, preprocessed for our case, + sc */

static inline unsigned long 
lfsr (unsigned long  bits, unsigned long  prev)
{
  static const unsigned long long lfsr_taps[] = {
    0x0L,
    0x0L,
    0x3L,
    0x6L,
    0xcL,
    0x14L,
    0x30L,
    0x60L,
    0xb8L,
    0x110L,
    0x240L,
    0x500L,
    0x829L,
    0x100dL,
    0x2015L,
    0x6000L,
    0xd008L,
    0x12000L,
    0x20400L,
    0x40023L,
    0x90000L,
    0x140000L,
    0x300000L,
    0x420000L,
    0xe10000L,
    0x1200000L,
    0x2000023L,
    0x4000013L,
    0x9000000L,
    0x14000000L,
    0x20000029L,
    0x48000000L,
    0x80200003L,
    0x100080000L,
    0x204000003L,
    0x500000000L,
    0x801000000L,
    0x100000001fL,
    0x2000000031L,
    0x4400000000L,
    0xa000140000L,
    0x12000000000L,
    0x300000c0000L,
    0x63000000000L,
    0xc0000030000L,
    0x1b0000000000L,
    0x300003000000L,
    0x420000000000L,
    0xc00000180000L,
    0x1008000000000L,
    0x3000000c00000L,
    0x6000c00000000L,
    0x9000000000000L,
    0x18003000000000L,
    0x30000000030000L,
    0x40000040000000L,
    0xc0000600000000L,
    0x102000000000000L,
    0x200004000000000L,
    0x600003000000000L,
    0xc00000000000000L,
    0x1800300000000000L,
    0x3000000000000030L,
    0x6000000000000000L,
    0x800000000000000dL
  };
  unsigned long lsb = prev & 1;
  prev >>= 1;
  prev ^= (-lsb) & lfsr_taps[bits];
  return prev;
}

__attribute__((unused))
     void
     cdelay (int i)
{
  while (i > 0) {
    __asm__ volatile ("");
    i--;
  }
}
#if 0
int
sdram_get_databits (void)
{
  return 16;
}
int
sdram_get_freq (void)
{
  return 2 * 4 * 100000000;
}
int
sdram_get_cl (void)
{
  return 6;
}
int
sdram_get_cwl (void)
{
  return 5;
}
#endif
static unsigned char
sdram_dfii_get_rdphase(struct sbusfpga_sdram_softc *sc)
{
  return ddrphy_rdphase_read(sc);
}
static unsigned char
sdram_dfii_get_wrphase(struct sbusfpga_sdram_softc *sc)
{
  return ddrphy_wrphase_read(sc);
}
static void
sdram_dfii_pix_address_write(struct sbusfpga_sdram_softc *sc, unsigned char phase, unsigned int value)
{
  switch (phase) {
  case 3:
    sdram_dfii_pi3_address_write(sc, value);
    break;
  case 2:
    sdram_dfii_pi2_address_write(sc, value);
    break;
  case 1:
    sdram_dfii_pi1_address_write(sc, value);
    break;
  default:
    sdram_dfii_pi0_address_write(sc, value);
  }
}
static void
sdram_dfii_pird_address_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char rdphase = sdram_dfii_get_rdphase(sc);
  sdram_dfii_pix_address_write(sc, rdphase, value);
}
static void
sdram_dfii_piwr_address_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char wrphase = sdram_dfii_get_wrphase(sc);
  sdram_dfii_pix_address_write(sc, wrphase, value);
}
static void
sdram_dfii_pix_baddress_write(struct sbusfpga_sdram_softc *sc, unsigned char phase, unsigned int value)
{
  switch (phase) {
  case 3:
    sdram_dfii_pi3_baddress_write(sc, value);
    break;
  case 2:
    sdram_dfii_pi2_baddress_write(sc, value);
    break;
  case 1:
    sdram_dfii_pi1_baddress_write(sc, value);
    break;
  default:
    sdram_dfii_pi0_baddress_write(sc, value);
  }
}
static void
sdram_dfii_pird_baddress_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char rdphase = sdram_dfii_get_rdphase(sc);
  sdram_dfii_pix_baddress_write(sc, rdphase, value);
}
static void
sdram_dfii_piwr_baddress_write(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char wrphase = sdram_dfii_get_wrphase(sc);
  sdram_dfii_pix_baddress_write(sc, wrphase, value);
}
static void
command_px(struct sbusfpga_sdram_softc *sc, unsigned char phase, unsigned int value)
{
  switch (phase) {
  case 3:
	  command_p3(sc, value);
    break;
  case 2:
	  command_p2(sc, value);
    break;
  case 1:
	  command_p1(sc, value);
    break;
  default:
	  command_p0(sc, value);
  }
}
static void
command_prd(struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char rdphase = sdram_dfii_get_rdphase(sc);
  command_px(sc, rdphase, value);
}
static void
command_pwr (struct sbusfpga_sdram_softc *sc, unsigned int value)
{
  unsigned char wrphase = sdram_dfii_get_wrphase(sc);
  command_px(sc, wrphase, value);
}
static void
sdram_software_control_on(struct sbusfpga_sdram_softc *sc)
{
  unsigned int previous;
  previous = sdram_dfii_control_read(sc);
  if (previous != (0x02 | 0x04 | 0x08)) {
    sdram_dfii_control_write(sc, (0x02 | 0x04 | 0x08));
    aprint_normal_dev(sc->dk.sc_dev, "Switching SDRAM to software control.\n");
  }
}
static void
sdram_software_control_off(struct sbusfpga_sdram_softc *sc)
{
  unsigned int previous;
  previous = sdram_dfii_control_read(sc);
  if (previous != (0x01)) {
    sdram_dfii_control_write(sc, (0x01));
    aprint_normal_dev(sc->dk.sc_dev, "Switching SDRAM to hardware control.\n");
  }
}
__attribute__((unused)) static void
sdram_mode_register_write(struct sbusfpga_sdram_softc *sc, char reg, int value)
{
  sdram_dfii_pi0_address_write(sc, value);
  sdram_dfii_pi0_baddress_write(sc, reg);
  command_p0(sc, 0x08 | 0x04 | 0x02 | 0x01);
}
typedef void (*delay_callback) (struct sbusfpga_sdram_softc *sc, int module);
static void
sdram_activate_test_row(struct sbusfpga_sdram_softc *sc)
{
  sdram_dfii_pi0_address_write(sc, 0);
  sdram_dfii_pi0_baddress_write(sc, 0);
  command_p0(sc, 0x08 | 0x01);
  cdelay (15);
}
static void
sdram_precharge_test_row(struct sbusfpga_sdram_softc *sc)
{
  sdram_dfii_pi0_address_write(sc, 0);
  sdram_dfii_pi0_baddress_write(sc, 0);
  command_p0(sc, 0x08 | 0x02 | 0x01);
  cdelay (15);
}
#if 0
// available from kern.h
static unsigned int
popcount (unsigned int x)
{
  x -= ((x >> 1) & 0x55555555);
  x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
  x = (x + (x >> 4)) & 0x0F0F0F0F;
  x += (x >> 8);
  x += (x >> 16);
  return x & 0x0000003F;
}
#endif
static void
print_scan_errors (unsigned int errors)
{
	aprint_normal("%d", errors == 0);
}
static unsigned int
sdram_write_read_check_test_pattern (struct sbusfpga_sdram_softc *sc, int module, unsigned int seed)
{
  int p, i;
  unsigned int errors;
  unsigned int prv;
  unsigned char tst[1 * 32 / 8];
  unsigned char prs[4][1 * 32 / 8];
  prv = seed;
  for (p = 0; p < 4; p++) {
    for (i = 0; i < 1 * 32 / 8; i++) {
      prv = lfsr (32, prv);
      prs[p][i] = prv;
    }
  }
  sdram_activate_test_row(sc);
  for (p = 0; p < 4; p++)
	  csr_wr_buf_uint8(sc, sc->sc_bhregs_sdram + (sdram_dfii_pix_wrdata_addr (p) - CSR_SDRAM_BASE), prs[p], 1 * 32 / 8); /* cleanme */
  sdram_dfii_piwr_address_write(sc, 0);
  sdram_dfii_piwr_baddress_write(sc, 0);
  command_pwr(sc, 0x04 | 0x02 | 0x01 | 0x10);
  cdelay (15);
  sdram_dfii_pird_address_write(sc, 0);
  sdram_dfii_pird_baddress_write(sc, 0);
  command_prd(sc, 0x04 | 0x01 | 0x20);
  cdelay (15);
  sdram_precharge_test_row(sc);
  errors = 0;
  for (p = 0; p < 4; p++) {
	  csr_rd_buf_uint8(sc, sc->sc_bhregs_sdram + (sdram_dfii_pix_rddata_addr (p) - CSR_SDRAM_BASE), tst, 1 * 32 / 8); /* cleanme */
    errors +=
      popcount (prs[p][16 / 8 - 1 - module] ^ tst[16 / 8 - 1 - module]);
    errors +=
      popcount (prs[p][2 * 16 / 8 - 1 - module] ^
		tst[2 * 16 / 8 - 1 - module]);
  }
  return errors;
}
static void
sdram_leveling_center_module (struct sbusfpga_sdram_softc *sc, int module, int show_short, int show_long,
			      delay_callback rst_delay,
			      delay_callback inc_delay)
{
  int i;
  int show;
  int working;
  unsigned int errors;
  int delay, delay_mid, delay_range;
  int delay_min = -1, delay_max = -1;
  if (show_long)
    aprint_normal_dev(sc->dk.sc_dev, "m%d: |", module);
  delay = 0;
  rst_delay(sc, module);
  while (1) {
    errors = sdram_write_read_check_test_pattern(sc, module, 42);
    errors += sdram_write_read_check_test_pattern(sc, module, 84);
    working = errors == 0;
    show = show_long;
    if (show)
      print_scan_errors(errors);
    if (working && delay_min < 0) {
      delay_min = delay;
      break;
    }
    delay++;
    if (delay >= 32)
      break;
    inc_delay(sc, module);
  }
  delay++;
  inc_delay(sc, module);
  while (1) {
    errors = sdram_write_read_check_test_pattern(sc, module, 42);
    errors += sdram_write_read_check_test_pattern(sc, module, 84);
    working = errors == 0;
    show = show_long;
    if (show)
      print_scan_errors(errors);
    if (!working && delay_max < 0) {
      delay_max = delay;
    }
    delay++;
    if (delay >= 32)
      break;
    inc_delay(sc, module);
  }
  if (delay_max < 0) {
    delay_max = delay;
  }
  if (show_long)
    aprint_normal_dev(sc->dk.sc_dev, "| ");
  delay_mid = (delay_min + delay_max) / 2 % 32;
  delay_range = (delay_max - delay_min) / 2;
  if (show_short) {
    if (delay_min < 0)
		aprint_normal("delays: -");
    else
		aprint_normal("delays: %02d+-%02d", delay_mid, delay_range);
  }
  if (show_long)
	  aprint_normal("\n");
  rst_delay(sc, module);
  cdelay (100);
  for (i = 0; i < delay_mid; i++) {
    inc_delay(sc, module);
    cdelay (100);
  }
}
int _sdram_tck_taps;
int _sdram_write_leveling_bitslips[16];
static void
sdram_read_leveling_rst_delay (struct sbusfpga_sdram_softc *sc, int module)
{
  ddrphy_dly_sel_write(sc, 1 << module);
  ddrphy_rdly_dq_rst_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static void
sdram_read_leveling_inc_delay (struct sbusfpga_sdram_softc *sc, int module)
{
  ddrphy_dly_sel_write(sc, 1 << module);
  ddrphy_rdly_dq_inc_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static void
sdram_read_leveling_rst_bitslip (struct sbusfpga_sdram_softc *sc, char m)
{
  ddrphy_dly_sel_write(sc, 1 << m);
  ddrphy_rdly_dq_bitslip_rst_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static void
sdram_read_leveling_inc_bitslip (struct sbusfpga_sdram_softc *sc, char m)
{
  ddrphy_dly_sel_write(sc, 1 << m);
  ddrphy_rdly_dq_bitslip_write(sc, 1);
  ddrphy_dly_sel_write(sc, 0);
}
static unsigned int
sdram_read_leveling_scan_module (struct sbusfpga_sdram_softc *sc, int module, int bitslip, int show)
{
  const unsigned int max_errors = 2 * (4 * 2 * 32);
  int i;
  unsigned int score;
  unsigned int errors;
  score = 0;
  if (show)
    aprint_normal_dev(sc->dk.sc_dev, "  m%d, b%02d: |", module, bitslip);
  sdram_read_leveling_rst_delay(sc, module);
  for (i = 0; i < 32; i++) {
    int working;
    int _show = show;
    errors = sdram_write_read_check_test_pattern(sc, module, 42);
    errors += sdram_write_read_check_test_pattern(sc, module, 84);
    working = errors == 0;
    score += (working * max_errors * 32) + (max_errors - errors);
    if (_show) {
      print_scan_errors(errors);
    }
    sdram_read_leveling_inc_delay(sc, module);
  }
  if (show)
    aprint_normal("| ");
  return score;
}
static void
sdram_read_leveling(struct sbusfpga_sdram_softc *sc)
{
  int module;
  int bitslip;
  unsigned int score;
  unsigned int best_score;
  int best_bitslip;
  for (module = 0; module < 16 / 8; module++) {
    best_score = 0;
    best_bitslip = 0;
    sdram_read_leveling_rst_bitslip(sc, module);
    for (bitslip = 0; bitslip < 8; bitslip++) {
      score = sdram_read_leveling_scan_module(sc, module, bitslip, 1);
      sdram_leveling_center_module(sc, module, 1, 0,
				    sdram_read_leveling_rst_delay,
				    sdram_read_leveling_inc_delay);
      aprint_normal("\n");
      if (score > best_score) {
	best_bitslip = bitslip;
	best_score = score;
      }
      if (bitslip == 8 - 1)
	break;
      sdram_read_leveling_inc_bitslip(sc, module);
    }
    aprint_normal_dev(sc->dk.sc_dev, "  best: m%d, b%02d ", module, best_bitslip);
    sdram_read_leveling_rst_bitslip(sc, module);
    for (bitslip = 0; bitslip < best_bitslip; bitslip++)
      sdram_read_leveling_inc_bitslip(sc, module);
    sdram_leveling_center_module(sc, module, 1, 0,
				  sdram_read_leveling_rst_delay,
				  sdram_read_leveling_inc_delay);
    aprint_normal("\n");
  }
}
static void
sdram_write_latency_calibration(struct sbusfpga_sdram_softc *sc)
{
  int i;
  int module;
  int bitslip;
  unsigned int score;
  unsigned int subscore;
  unsigned int best_score;
  int best_bitslip;
  for (module = 0; module < 16 / 8; module++) {
    best_score = 0;
    best_bitslip = -1;
    for (bitslip = 0; bitslip < 8; bitslip += 2) {
      score = 0;
      ddrphy_dly_sel_write(sc, 1 << module);
      ddrphy_wdly_dq_bitslip_rst_write(sc, 1);
      for (i = 0; i < bitslip; i++) {
	ddrphy_wdly_dq_bitslip_write(sc, 1);
      }
      ddrphy_dly_sel_write(sc, 0);
      score = 0;
      sdram_read_leveling_rst_bitslip(sc, module);
      for (i = 0; i < 8; i++) {
	subscore = sdram_read_leveling_scan_module(sc, module, i, 0);
	score = subscore > score ? subscore : score;
	sdram_read_leveling_inc_bitslip(sc, module);
      }
      if (score > best_score) {
	best_bitslip = bitslip;
	best_score = score;
      }
    }
    if (_sdram_write_leveling_bitslips[module] < 0)
      bitslip = best_bitslip;
    else
      bitslip = _sdram_write_leveling_bitslips[module];
    if (bitslip == -1)
      aprint_normal_dev(sc->dk.sc_dev, "m%d:- ", module);
    else
      aprint_normal_dev(sc->dk.sc_dev, "m%d:%d ", module, bitslip);
    ddrphy_dly_sel_write(sc, 1 << module);
    ddrphy_wdly_dq_bitslip_rst_write(sc, 1);
    for (i = 0; i < bitslip; i++) {
      ddrphy_wdly_dq_bitslip_write(sc, 1);
    }
    ddrphy_dly_sel_write(sc, 0);
  }
  aprint_normal("\n");
}
static int
sdram_leveling(struct sbusfpga_sdram_softc *sc)
{
  int module;
  sdram_software_control_on(sc);
  for (module = 0; module < 16 / 8; module++) {
    sdram_read_leveling_rst_delay(sc, module);
    sdram_read_leveling_rst_bitslip(sc, module);
  }
  aprint_normal_dev(sc->dk.sc_dev, "Write latency calibration:\n");
  sdram_write_latency_calibration(sc);
  aprint_normal_dev(sc->dk.sc_dev, "Read leveling:\n");
  sdram_read_leveling(sc);
  sdram_software_control_off(sc);
  return 1;
}
int
sdram_init(struct sbusfpga_sdram_softc *sc)
{
  ddrphy_rdphase_write(sc, 2);
  ddrphy_wrphase_write(sc, 3);
  aprint_normal_dev(sc->dk.sc_dev, "Initializing SDRAM @0x%08lx...\n", 0x80000000L);
  sdram_software_control_on(sc);
  ddrphy_rst_write(sc, 1);
  cdelay (1000);
  ddrphy_rst_write(sc, 0);
  cdelay (1000);
  init_sequence(sc);
  sdram_leveling(sc);
  sdram_software_control_off(sc);
#if 0
  if (!memtest ((unsigned int *) 0x80000000L, (2 * 1024 * 1024))) {
    return 0;
  }
  memspeed ((unsigned int *) 0x80000000L, (2 * 1024 * 1024), 0);
#endif
  return 1;
}
