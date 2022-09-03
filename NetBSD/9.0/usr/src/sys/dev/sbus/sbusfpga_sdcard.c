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

#include <dev/sbus/sbusfpga_sdcard.h>

#include <machine/param.h>

#include <uvm/uvm_extern.h>

int	sbusfpga_sd_match(device_t, cfdata_t, void *);
void	sbusfpga_sd_attach(device_t, device_t, void *);

extern struct cfdriver sbusfpga_sd_cd;
CFATTACH_DECL_NEW(sbusfpga_sd, sizeof(struct sbusfpga_sd_softc),
    sbusfpga_sd_match, sbusfpga_sd_attach, NULL, NULL);

dev_type_open(sbusfpga_sd_open);
dev_type_close(sbusfpga_sd_close);
dev_type_read(sbusfpga_sd_read);
dev_type_write(sbusfpga_sd_write);
dev_type_ioctl(sbusfpga_sd_ioctl);
dev_type_strategy(sbusfpga_sd_strategy);
dev_type_size(sbusfpga_sd_size);

const struct bdevsw sbusfpga_sd_bdevsw = {
    .d_open = sbusfpga_sd_open,
    .d_close = sbusfpga_sd_close,
    .d_strategy = sbusfpga_sd_strategy,
    .d_ioctl = sbusfpga_sd_ioctl,
    .d_dump = nodump,
    .d_psize = sbusfpga_sd_size,
    .d_discard = nodiscard,
    .d_flag = D_DISK
};

const struct cdevsw sbusfpga_sd_cdevsw = {
	.d_open = sbusfpga_sd_open,
	.d_close = sbusfpga_sd_close,
	.d_read = sbusfpga_sd_read,
	.d_write = sbusfpga_sd_write,
	.d_ioctl = sbusfpga_sd_ioctl,
	.d_stop = nostop,
	.d_tty = notty,
	.d_poll = nopoll,
	.d_mmap = nommap,
	.d_kqfilter = nokqfilter,
	.d_discard = nodiscard,
	.d_flag = D_DISK
};


static void	sbusfpga_sd_set_geometry(struct sbusfpga_sd_softc *sc);
static void sbusfpga_sd_minphys(struct buf *);
static int sbusfpga_sd_diskstart(device_t self, struct buf *bp);

struct dkdriver sbusfpga_sd_dkdriver = {					
	.d_strategy = sbusfpga_sd_strategy,
	.d_minphys = sbusfpga_sd_minphys,
	.d_open = sbusfpga_sd_open,
	.d_close = sbusfpga_sd_close,
	.d_diskstart = sbusfpga_sd_diskstart
	/* d_iosize */
	/* d_dumpblocks */
	/* d_lastclose */
	/* d_discard */
	/* d_firstopen */
    /* d_label */
};

static int sdcard_init(struct sbusfpga_sd_softc *sc);
static int dma_init(struct sbusfpga_sd_softc *sc);
static int sdcard_read(struct sbusfpga_sd_softc *sc, uint32_t block, uint32_t count, uint8_t* buf);
static int sdcard_write(struct sbusfpga_sd_softc *sc, uint32_t block, uint32_t count, uint8_t* buf);
	
#if 0
static int	sbusfpga_sd_mmc_host_reset(sdmmc_chipset_handle_t);
static uint32_t	sbusfpga_sd_mmc_host_ocr(sdmmc_chipset_handle_t);
static int	sbusfpga_sd_mmc_host_maxblklen(sdmmc_chipset_handle_t);
static int	sbusfpga_sd_mmc_card_detect(sdmmc_chipset_handle_t);
static int	sbusfpga_sd_mmc_write_protect(sdmmc_chipset_handle_t);
static int	sbusfpga_sd_mmc_bus_power(sdmmc_chipset_handle_t, uint32_t);
static int	sbusfpga_sd_mmc_bus_clock(sdmmc_chipset_handle_t, int);
static int	sbusfpga_sd_mmc_bus_width(sdmmc_chipset_handle_t, int);
static int	sbusfpga_sd_mmc_bus_rod(sdmmc_chipset_handle_t, int);
static void	sbusfpga_sd_mmc_exec_command(sdmmc_chipset_handle_t,
				     struct sdmmc_command *);
static void	sbusfpga_sd_mmc_card_enable_intr(sdmmc_chipset_handle_t, int);
static void	sbusfpga_sd_mmc_card_intr_ack(sdmmc_chipset_handle_t);

//static int	sbusfpga_sd_mmc_wait_cmd(struct sbusfpga_sd_mmc_softc *);
//static int	sbusfpga_sd_mmc_pio_transfer(struct sbusfpga_sd_mmc_softc *,
//				     struct sdmmc_command *, int);

static struct sdmmc_chip_functions sbusfpga_sd_mmc_chip_functions = {
	.host_reset = sbusfpga_sd_mmc_host_reset,
	.host_ocr = sbusfpga_sd_mmc_host_ocr,
	.host_maxblklen = sbusfpga_sd_mmc_host_maxblklen,
	.card_detect = sbusfpga_sd_mmc_card_detect,
	.write_protect = sbusfpga_sd_mmc_write_protect,
	.bus_power = sbusfpga_sd_mmc_bus_power,
	.bus_clock = sbusfpga_sd_mmc_bus_clock,
	.bus_width = sbusfpga_sd_mmc_bus_width,
	.bus_rod = sbusfpga_sd_mmc_bus_rod,
	.exec_command = sbusfpga_sd_mmc_exec_command,
	.card_enable_intr = sbusfpga_sd_mmc_card_enable_intr,
	.card_intr_ack = sbusfpga_sd_mmc_card_intr_ack,
};
#endif

int
sbusfpga_sd_ioctl (dev_t dev, u_long cmd, void *data, int flag, struct lwp *l)
{
	struct sbusfpga_sd_softc *sc = device_lookup_private(&sbusfpga_sd_cd, DISKUNIT(dev));
	int err = 0;//, err2 = 0;

	if (!sc->init_done) {
		device_printf(sc->dk.sc_dev, "Device not initialized\n");
		return ENODEV;
	}

	if (sc == NULL) {
		device_printf(sc->dk.sc_dev, "%s:%d: sc == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	}
	
	err = dk_ioctl(&sc->dk, dev, cmd, data, flag, l);
	
	return err;
}

int
sbusfpga_sd_match(device_t parent, cfdata_t cf, void *aux)
{
	struct sbus_attach_args *sa = (struct sbus_attach_args *)aux;

	return (strcmp("LITEX,sdcard", sa->sa_name) == 0);
}

/*
 * Attach all the sub-devices we can find
 */
void
sbusfpga_sd_attach(device_t parent, device_t self, void *aux)
{
	struct sbus_attach_args *sa = aux;
	struct sbusfpga_sd_softc *sc = device_private(self);
	struct sbus_softc *sbsc = device_private(parent);
	int node;
	int sbusburst;
		
	sc->sc_bustag = sa->sa_bustag;
	sc->sc_dmatag = sa->sa_dmatag;
	sc->dk.sc_dev = self;
	sc->init_done = 0;

	aprint_normal("\n");

	if (sa->sa_nreg < 5) {
		aprint_error(": Not enough registers spaces\n");
		return;
	}

	/* map sdcore */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[0].oa_space /* sa_slot */,
					 sa->sa_reg[0].oa_base /* sa_offset */,
					 sa->sa_reg[0].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_sdcore) != 0) {
		aprint_error(": cannot map sdcore registers\n");
		return;
	} else {
		aprint_normal_dev(self, "sdcore registers @ %p\n", (void*)sc->sc_bhregs_sdcore);
	}
	/* map sdirq */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[1].oa_space /* sa_slot */,
					 sa->sa_reg[1].oa_base /* sa_offset */,
					 sa->sa_reg[1].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_sdirq) != 0) {
		aprint_error(": cannot map sdirq registers\n");
		return;
	} else {
		aprint_normal_dev(self, "sdirq registers @ %p\n", (void*)sc->sc_bhregs_sdirq);
	}
	/* map sdphy */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[2].oa_space /* sa_slot */,
					 sa->sa_reg[2].oa_base /* sa_offset */,
					 sa->sa_reg[2].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_sdphy) != 0) {
		aprint_error(": cannot map sdphy registers\n");
		return;
	} else {
		aprint_normal_dev(self, "sdphy registers @ %p\n", (void*)sc->sc_bhregs_sdphy);
	}
	/* map dma reader */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[3].oa_space /* sa_slot */,
					 sa->sa_reg[3].oa_base /* sa_offset */,
					 sa->sa_reg[3].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_sdblock2mem) != 0) {
		aprint_error(": cannot map DMA READ registers\n");
		return;
	} else {
		aprint_normal_dev(self, "DMA READ registers @ %p\n", (void*)sc->sc_bhregs_sdblock2mem);
	}
	/* map dma writer */
	if (sbus_bus_map(sc->sc_bustag,
					 sa->sa_reg[4].oa_space /* sa_slot */,
					 sa->sa_reg[4].oa_base /* sa_offset */,
					 sa->sa_reg[4].oa_size /* sa_size */,
					 BUS_SPACE_MAP_LINEAR,
					 &sc->sc_bhregs_sdmem2block) != 0) {
		aprint_error(": cannot map DMA WRITE registers\n");
		return;
	} else {
		aprint_normal_dev(self, "DMA WRITE registers @ %p\n", (void*)sc->sc_bhregs_sdmem2block);
	}
	
	sc->sc_bufsiz_sdcore      = sa->sa_reg[0].oa_size;
	sc->sc_bufsiz_sdirq       = sa->sa_reg[1].oa_size;
	sc->sc_bufsiz_sdphy       = sa->sa_reg[2].oa_size;
	sc->sc_bufsiz_sdblock2mem = sa->sa_reg[3].oa_size;
	sc->sc_bufsiz_sdmem2block = sa->sa_reg[4].oa_size;

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

	sc->max_rd_blk_len = 0;
	sc->max_size_in_blk = 0;
	/* check values from the PROM for proper initialization */
	if (prom_getpropint(node, "sdcard-good", 0) == 1) {
		aprint_normal_dev(self, "sdcard initialized by PROM\n");
		sc->max_rd_blk_len = prom_getpropint(node, "max_rd_blk_len", 0);
		sc->max_size_in_blk = prom_getpropint(node, "max_size_in_blk", 0);
	}
	/* if PROM initialization is not done [properly], try in the driver */
	if ((sc->max_rd_blk_len == 0) || (sc->max_size_in_blk == 0)) {
		if (!sdcard_init(sc)) {
			aprint_error_dev(self, "couldn't initialize sdcard\n");
			return;
		} else {
			aprint_normal_dev(self, "sdcard initialized by kernel\n");
		}
	}
	
	if (!dma_init(sc)) {
		aprint_error_dev(self, "couldn't initialize DMA for sdcard\n");
		return;
	}

	/* we seem OK hardware-wise */
	dk_init(&sc->dk, self, DKTYPE_FLASH);
	disk_init(&sc->dk.sc_dkdev, device_xname(sc->dk.sc_dev), &sbusfpga_sd_dkdriver);
	dk_attach(&sc->dk);
	disk_attach(&sc->dk.sc_dkdev);
	sbusfpga_sd_set_geometry(sc);
	bufq_alloc(&sc->dk.sc_bufq, BUFQ_DISK_DEFAULT_STRAT, BUFQ_SORT_RAWBLOCK); /* needed ? */
	dkwedge_discover(&sc->dk.sc_dkdev);

	sc->init_done = 1;
	
	#if 0
	struct sdmmcbus_attach_args saa;

	memset(&saa, 0, sizeof(saa));
	saa.saa_busname = "sdmmc";
	saa.saa_sct = &sbusfpga_sd_mmc_chip_functions;
	saa.saa_sch = sc;
	saa.saa_clkmin = SDMMC_SDCLK_400K;
	saa.saa_clkmax = 25000;
	saa.saa_caps = SMC_CAPS_4BIT_MODE;
	
	sc->sc_sdmmc_dev = config_found(sc->sc_dev, &saa, NULL);
	#endif
}

int
sbusfpga_sd_open(dev_t dev, int flag, int fmt, struct lwp *l)
{
	struct sbusfpga_sd_softc *sd = device_lookup_private(&sbusfpga_sd_cd, DISKUNIT(dev));
	struct dk_softc *dksc;
	int error = 0;

	if (!sd->init_done) {
		device_printf(sd->dk.sc_dev, "Device not initialized\n");
		return ENODEV;
	}

	if (sd == NULL) {
		device_printf(sd->dk.sc_dev, "%s:%d: sd == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	} else {
		device_printf(sd->dk.sc_dev, "%s:%d: open device %d, part is %d\n", __PRETTY_FUNCTION__, __LINE__, DISKUNIT(dev), DISKPART(dev));
	}
	dksc = &sd->dk;

	if (!device_is_active(dksc->sc_dev)) {
		return (ENODEV);
	}

	error = dk_open(dksc, dev, flag, fmt, l);

	return error;
}

int
sbusfpga_sd_close(dev_t dev, int flag, int fmt, struct lwp *l)
{
	struct sbusfpga_sd_softc *sd = device_lookup_private(&sbusfpga_sd_cd, DISKUNIT(dev));
	struct dk_softc *dksc;
	int error = 0;

	if (!sd->init_done) {
		device_printf(sd->dk.sc_dev, "Device not initialized\n");
		return ENODEV;
	}

	if (sd == NULL) {
		device_printf(sd->dk.sc_dev, "%s:%d: sd == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
		return (ENXIO);
	} else {
		device_printf(sd->dk.sc_dev, "%s:%d: close device %d, part is %d\n", __PRETTY_FUNCTION__, __LINE__, DISKUNIT(dev), DISKPART(dev));
	}

	dksc = &sd->dk;

	error = dk_close(dksc, dev, flag, fmt, l);

	return error;
}

int
sbusfpga_sd_read(dev_t dev, struct uio *uio, int flags)
{
	return physio(sbusfpga_sd_strategy, NULL, dev, B_READ, sbusfpga_sd_minphys, uio);
}

int
sbusfpga_sd_write(dev_t dev, struct uio *uio, int flags)
{
	return physio(sbusfpga_sd_strategy, NULL, dev, B_WRITE, sbusfpga_sd_minphys, uio);
}

void
sbusfpga_sd_strategy(struct buf *bp)
{
	struct sbusfpga_sd_softc *sc = device_lookup_private(&sbusfpga_sd_cd, DISKUNIT(bp->b_dev));
	
	dk_strategy(&sc->dk, bp);
}

static void	sbusfpga_sd_set_geometry(struct sbusfpga_sd_softc *sc) {
	struct dk_softc *dksc = &sc->dk;
	struct disk_geom *dg = &dksc->sc_dkdev.dk_geom;

	memset(dg, 0, sizeof(*dg));

	dg->dg_secsize = 512;
	dg->dg_nsectors = 64;
	dg->dg_ntracks = 32;
	dg->dg_ncylinders = (sc->max_size_in_blk * 512ULL) / (dg->dg_secsize * dg->dg_nsectors * dg->dg_ntracks);
	dg->dg_secpercyl = dg->dg_nsectors * dg->dg_ntracks;
	dg->dg_secperunit = dg->dg_secpercyl * dg->dg_ncylinders;
	dg->dg_pcylinders = dg->dg_ncylinders;
	dg->dg_sparespertrack = 0;
	dg->dg_sparespercyl = 0;

	disk_set_info(dksc->sc_dev, &dksc->sc_dkdev, "sbusfpga_sd");
}

int
sbusfpga_sd_size(dev_t dev) {
	struct sbusfpga_sd_softc *sc = device_lookup_private(&sbusfpga_sd_cd, DISKUNIT(dev));
	if (sc == NULL)
		return -1;

	if (!device_is_active(sc->dk.sc_dev)) {
		return -1;
	}
	
	return dk_size(&sc->dk, dev);
}

static void
sbusfpga_sd_minphys(struct buf *bp)
{
	if (bp->b_bcount > SBUSFPGA_SD_VAL_DMA_MAX_SZ)
		bp->b_bcount = SBUSFPGA_SD_VAL_DMA_MAX_SZ;
}

static int
sbusfpga_sd_diskstart(device_t self, struct buf *bp)
{	
	struct sbusfpga_sd_softc *sc = device_private(self);
	int err = 0;
	if (sc == NULL) {
		device_printf(sc->dk.sc_dev, "%s:%d: sc == NULL! giving up\n", __PRETTY_FUNCTION__, __LINE__);
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
		
		while (bp->b_resid >= 512 && !err) {
			u_int32_t blkcnt = bp->b_resid / 512;
			
			if (blkcnt > (SBUSFPGA_SD_VAL_DMA_MAX_SZ/512))
				blkcnt = (SBUSFPGA_SD_VAL_DMA_MAX_SZ/512);
			
			if (blk+blkcnt <= sc->max_size_in_blk) {
				err = sdcard_read(sc, blk, blkcnt, data);
			} else {
				device_printf(sc->dk.sc_dev, "%s:%d: blk = %lld read out of range! giving up\n", __PRETTY_FUNCTION__, __LINE__, blk);
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
			
			if (blkcnt > (SBUSFPGA_SD_VAL_DMA_MAX_SZ/512))
				blkcnt = (SBUSFPGA_SD_VAL_DMA_MAX_SZ/512);
			
			if (blk+blkcnt <= sc->max_size_in_blk) {
				err = sdcard_write(sc, blk, blkcnt, data);
			} else {
				device_printf(sc->dk.sc_dev, "%s:%d: blk = %lld write out of range! giving up\n", __PRETTY_FUNCTION__, __LINE__, blk);
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

static int dma_init(struct sbusfpga_sd_softc *sc) {
	
	/* Allocate a dmamap */
	if (bus_dmamap_create(sc->sc_dmatag, SBUSFPGA_SD_VAL_DMA_MAX_SZ, 1, SBUSFPGA_SD_VAL_DMA_MAX_SZ, 0, BUS_DMA_NOWAIT | BUS_DMA_ALLOCNOW, &sc->sc_dmamap) != 0) {
		aprint_error_dev(sc->dk.sc_dev, "DMA map create failed\n");
		return 0;
	} else {
		aprint_normal_dev(sc->dk.sc_dev, "dmamap: %lu %lu %d (%p)\n", sc->sc_dmamap->dm_maxsegsz, sc->sc_dmamap->dm_mapsize, sc->sc_dmamap->dm_nsegs, sc->sc_dmatag->_dmamap_load);
	}
	
	return 1;
}

static inline void busy_wait(int n) {
	delay(1000 * n);
}

#define CONFIG_CSR_DATA_WIDTH 32
/* grrr */
#define sbusfpga_sdcore_softc      sbusfpga_sd_softc
#define sbusfpga_sdirq_softc       sbusfpga_sd_softc
#define sbusfpga_sdphy_softc       sbusfpga_sd_softc
#define sbusfpga_sdblock2mem_softc sbusfpga_sd_softc
#define sbusfpga_sdmem2block_softc sbusfpga_sd_softc
#include "dev/sbus/sbusfpga_csr_sdcore.h"
#include "dev/sbus/sbusfpga_csr_sdirq.h"
#include "dev/sbus/sbusfpga_csr_sdphy.h"
#include "dev/sbus/sbusfpga_csr_sdblock2mem.h"
#include "dev/sbus/sbusfpga_csr_sdmem2block.h"

#define sbusfpga_common_softc sbusfpga_sd_softc
#include "dev/sbus/sbusfpga_csr_common.h"

/* basically Litex BIOS code */

#ifndef CONFIG_CLOCK_FREQUENCY
#define CONFIG_CLOCK_FREQUENCY 100000000
#endif


#define CLKGEN_STATUS_BUSY		0x1
#define CLKGEN_STATUS_PROGDONE	0x2
#define CLKGEN_STATUS_LOCKED	0x4

#define SD_CMD_RESPONSE_SIZE 16

#define SD_OK         0
#define SD_CRCERROR   1
#define SD_TIMEOUT    2
#define SD_WRITEERROR 3

#define SD_SWITCH_CHECK  0
#define SD_SWITCH_SWITCH 1

#define SD_SPEED_SDR12  0
#define SD_SPEED_SDR25  1
#define SD_SPEED_SDR50  2
#define SD_SPEED_SDR104 3
#define SD_SPEED_DDR50  4

#define SD_DRIVER_STRENGTH_B 0
#define SD_DRIVER_STRENGTH_A 1
#define SD_DRIVER_STRENGTH_C 2
#define SD_DRIVER_STRENGTH_D 3

#define SD_GROUP_ACCESSMODE     0
#define SD_GROUP_COMMANDSYSTEM  1
#define SD_GROUP_DRIVERSTRENGTH 2
#define SD_GROUP_POWERLIMIT     3

#define SDCARD_STREAM_STATUS_OK           0b000
#define SDCARD_STREAM_STATUS_TIMEOUT      0b001
#define SDCARD_STREAM_STATUS_DATAACCEPTED 0b010
#define SDCARD_STREAM_STATUS_CRCERROR     0b101
#define SDCARD_STREAM_STATUS_WRITEERROR   0b110

#define SDCARD_CTRL_DATA_TRANSFER_NONE  0
#define SDCARD_CTRL_DATA_TRANSFER_READ  1
#define SDCARD_CTRL_DATA_TRANSFER_WRITE 2

#define SDCARD_CTRL_RESPONSE_NONE       0
#define SDCARD_CTRL_RESPONSE_SHORT      1
#define SDCARD_CTRL_RESPONSE_LONG       2
#define SDCARD_CTRL_RESPONSE_SHORT_BUSY 3

//#define SDCARD_DEBUG
//#define SDCARD_CMD23_SUPPORT /* SET_BLOCK_COUNT */
#define SDCARD_CMD18_SUPPORT /* READ_MULTIPLE_BLOCK */
#define SDCARD_CMD25_SUPPORT /* WRITE_MULTIPLE_BLOCK */

#ifndef SDCARD_CLK_FREQ_INIT
#define SDCARD_CLK_FREQ_INIT 400000
#endif

#ifndef SDCARD_CLK_FREQ
#define SDCARD_CLK_FREQ 25000000
#endif

/*-----------------------------------------------------------------------*/
/* Helpers                                                               */
/*-----------------------------------------------------------------------*/

#define max(x, y) (((x) > (y)) ? (x) : (y))
#define min(x, y) (((x) < (y)) ? (x) : (y))

/*-----------------------------------------------------------------------*/
/* SDCard command helpers                                                */
/*-----------------------------------------------------------------------*/

static int sdcard_wait_cmd_done(struct sbusfpga_sd_softc *sc) {
	unsigned int event;
#ifdef SDCARD_DEBUG
	uint32_t r[SD_CMD_RESPONSE_SIZE/4];
#endif
	for (;;) {
		event = sdcore_cmd_event_read(sc);
#ifdef SDCARD_DEBUG
		printf("cmdevt: %08x\n", event);
#endif
		delay(10);
		if (event & 0x1)
			break;
	}
#ifdef SDCARD_DEBUG
	csr_rd_buf_uint32(sc, sc->sc_bhregs_sdcore + (CSR_SDCORE_CMD_RESPONSE_ADDR - CSR_SDCORE_BASE), r, SD_CMD_RESPONSE_SIZE/4);
	printf("%08x %08x %08x %08x\n", r[0], r[1], r[2], r[3]);
#endif
	if (event & 0x4)
		return SD_TIMEOUT;
	if (event & 0x8)
		return SD_CRCERROR;
	return SD_OK;
}

static int sdcard_wait_data_done(struct sbusfpga_sd_softc *sc) {
	unsigned int event;
	for (;;) {
		event = sdcore_data_event_read(sc);
#ifdef SDCARD_DEBUG
		printf("dataevt: %08x\n", event);
#endif
		if (event & 0x1)
			break;
		delay(10);
	}
	if (event & 0x4)
		return SD_TIMEOUT;
	else if (event & 0x8)
		return SD_CRCERROR;
	return SD_OK;
}

/*-----------------------------------------------------------------------*/
/* SDCard clocker functions                                              */
/*-----------------------------------------------------------------------*/

/* round up to closest power-of-two */
static inline uint32_t pow2_round_up(uint32_t r) {
	r--;
	r |= r >>  1;
	r |= r >>  2;
	r |= r >>  4;
	r |= r >>  8;
	r |= r >> 16;
	r++;
	return r;
}

static void sdcard_set_clk_freq(struct sbusfpga_sd_softc *sc, uint32_t clk_freq, int show) {
	uint32_t divider;
	divider = clk_freq ? CONFIG_CLOCK_FREQUENCY/clk_freq : 256;
	divider = pow2_round_up(divider);
	divider = min(max(divider, 2), 256);
#ifdef SDCARD_DEBUG
	show = 1;
#endif
	if (show) {
		/* this is the *effective* new clk_freq */
		clk_freq = CONFIG_CLOCK_FREQUENCY/divider;
		/*
		  printf("Setting SDCard clk freq to ");
		if (clk_freq > 1000000)
			printf("%d MHz\n", clk_freq/1000000);
		else
			printf("%d KHz\n", clk_freq/1000);
		*/
	}
	sdphy_clocker_divider_write(sc, divider);
}

/*-----------------------------------------------------------------------*/
/* SDCard commands functions                                             */
/*-----------------------------------------------------------------------*/

static inline int sdcard_send_command(struct sbusfpga_sd_softc *sc, uint32_t arg, uint8_t cmd, uint8_t rsp) {
	sdcore_cmd_argument_write(sc, arg);
	sdcore_cmd_command_write(sc, (cmd << 8) | rsp);
	sdcore_cmd_send_write(sc, 1);
	return sdcard_wait_cmd_done(sc);
}

static int sdcard_go_idle(struct sbusfpga_sd_softc *sc) {
#ifdef SDCARD_DEBUG
	printf("CMD0: GO_IDLE\n");
#endif
	return sdcard_send_command(sc, 0, 0, SDCARD_CTRL_RESPONSE_NONE);
}

static int sdcard_send_ext_csd(struct sbusfpga_sd_softc *sc) {
	uint32_t arg = 0x000001aa;
#ifdef SDCARD_DEBUG
	printf("CMD8: SEND_EXT_CSD, arg: 0x%08x\n", arg);
#endif
	return sdcard_send_command(sc, arg, 8, SDCARD_CTRL_RESPONSE_SHORT);
}

static int sdcard_app_cmd(struct sbusfpga_sd_softc *sc, uint16_t rca) {
#ifdef SDCARD_DEBUG
	printf("CMD55: APP_CMD\n");
#endif
	return sdcard_send_command(sc, rca << 16, 55, SDCARD_CTRL_RESPONSE_SHORT);
}

static int sdcard_app_send_op_cond(struct sbusfpga_sd_softc *sc, int hcs) {
	uint32_t arg = 0x10ff8000;
	if (hcs)
		arg |= 0x60000000;
#ifdef SDCARD_DEBUG
	printf("ACMD41: APP_SEND_OP_COND, arg: %08x\n", arg);
#endif
	return sdcard_send_command(sc, arg, 41, SDCARD_CTRL_RESPONSE_SHORT_BUSY);
}

static int sdcard_all_send_cid(struct sbusfpga_sd_softc *sc) {
#ifdef SDCARD_DEBUG
	printf("CMD2: ALL_SEND_CID\n");
#endif
	return sdcard_send_command(sc, 0, 2, SDCARD_CTRL_RESPONSE_LONG);
}

static int sdcard_set_relative_address(struct sbusfpga_sd_softc *sc) {
#ifdef SDCARD_DEBUG
	printf("CMD3: SET_RELATIVE_ADDRESS\n");
#endif
	return sdcard_send_command(sc, 0, 3, SDCARD_CTRL_RESPONSE_SHORT);
}

static int sdcard_send_cid(struct sbusfpga_sd_softc *sc, uint16_t rca) {
#ifdef SDCARD_DEBUG
	printf("CMD10: SEND_CID\n");
#endif
	return sdcard_send_command(sc, rca << 16, 10, SDCARD_CTRL_RESPONSE_LONG);
}

static int sdcard_send_csd(struct sbusfpga_sd_softc *sc, uint16_t rca) {
#ifdef SDCARD_DEBUG
	printf("CMD9: SEND_CSD\n");
#endif
	return sdcard_send_command(sc, rca << 16, 9, SDCARD_CTRL_RESPONSE_LONG);
}

static int sdcard_select_card(struct sbusfpga_sd_softc *sc, uint16_t rca) {
#ifdef SDCARD_DEBUG
	printf("CMD7: SELECT_CARD\n");
#endif
	return sdcard_send_command(sc, rca << 16, 7, SDCARD_CTRL_RESPONSE_SHORT_BUSY);
}

static int sdcard_app_set_bus_width(struct sbusfpga_sd_softc *sc) {
#ifdef SDCARD_DEBUG
	printf("ACMD6: SET_BUS_WIDTH\n");
#endif
	return sdcard_send_command(sc, 2, 6, SDCARD_CTRL_RESPONSE_SHORT);
}

static int sdcard_switch(struct sbusfpga_sd_softc *sc, unsigned int mode, unsigned int group, unsigned int value) {
	unsigned int arg;
	arg = (mode << 31) | 0xffffff;
	arg &= ~(0xf << (group * 4));
	arg |= value << (group * 4);
device_printf(sc->dk.sc_dev, "switch arg is 0x%08x\n", arg);
#ifdef SDCARD_DEBUG
	printf("CMD6: SWITCH_FUNC\n");
#endif
	sdcore_block_length_write(sc, 64);
	sdcore_block_count_write(sc, 1);
	while (sdcard_send_command(sc, arg, 6,
		(SDCARD_CTRL_DATA_TRANSFER_READ << 5) |
		SDCARD_CTRL_RESPONSE_SHORT) != SD_OK);
	return sdcard_wait_data_done(sc);
}

static int sdcard_app_send_scr(struct sbusfpga_sd_softc *sc) {
#ifdef SDCARD_DEBUG
	printf("CMD51: APP_SEND_SCR\n");
#endif
	sdcore_block_length_write(sc, 8);
	sdcore_block_count_write(sc, 1);
	while (sdcard_send_command(sc, 0, 51,
		(SDCARD_CTRL_DATA_TRANSFER_READ << 5) |
		SDCARD_CTRL_RESPONSE_SHORT) != SD_OK);
	return sdcard_wait_data_done(sc);
}

static int sdcard_app_set_blocklen(struct sbusfpga_sd_softc *sc, unsigned int blocklen) {
#ifdef SDCARD_DEBUG
	printf("CMD16: SET_BLOCKLEN\n");
#endif
	return sdcard_send_command(sc, blocklen, 16, SDCARD_CTRL_RESPONSE_SHORT);
}

static int sdcard_write_single_block(struct sbusfpga_sd_softc *sc, unsigned int blockaddr) {
#ifdef SDCARD_DEBUG
	printf("CMD24: WRITE_SINGLE_BLOCK\n");
#endif
	sdcore_block_length_write(sc, 512);
	sdcore_block_count_write(sc, 1);
	while (sdcard_send_command(sc, blockaddr, 24,
	    (SDCARD_CTRL_DATA_TRANSFER_WRITE << 5) |
	    SDCARD_CTRL_RESPONSE_SHORT) != SD_OK);
	return SD_OK;
}

static int sdcard_write_multiple_block(struct sbusfpga_sd_softc *sc, unsigned int blockaddr, unsigned int blockcnt) {
#ifdef SDCARD_DEBUG
	printf("CMD25: WRITE_MULTIPLE_BLOCK\n");
#endif
	sdcore_block_length_write(sc, 512);
	sdcore_block_count_write(sc, blockcnt);
	while (sdcard_send_command(sc, blockaddr, 25,
	    (SDCARD_CTRL_DATA_TRANSFER_WRITE << 5) |
	    SDCARD_CTRL_RESPONSE_SHORT) != SD_OK);
	return SD_OK;
}

static int sdcard_read_single_block(struct sbusfpga_sd_softc *sc, unsigned int blockaddr) {
#ifdef SDCARD_DEBUG
	printf("CMD17: READ_SINGLE_BLOCK\n");
#endif
	sdcore_block_length_write(sc, 512);
	sdcore_block_count_write(sc, 1);
	while (sdcard_send_command(sc, blockaddr, 17,
	    (SDCARD_CTRL_DATA_TRANSFER_READ << 5) |
	    SDCARD_CTRL_RESPONSE_SHORT) != SD_OK);
	return sdcard_wait_data_done(sc);
}

static int sdcard_read_multiple_block(struct sbusfpga_sd_softc *sc, unsigned int blockaddr, unsigned int blockcnt) {
#ifdef SDCARD_DEBUG
	printf("CMD18: READ_MULTIPLE_BLOCK\n");
#endif
	sdcore_block_length_write(sc, 512);
	sdcore_block_count_write(sc, blockcnt);
	while (sdcard_send_command(sc, blockaddr, 18,
		(SDCARD_CTRL_DATA_TRANSFER_READ << 5) |
		SDCARD_CTRL_RESPONSE_SHORT) != SD_OK);
	return sdcard_wait_data_done(sc);
}

static int sdcard_stop_transmission(struct sbusfpga_sd_softc *sc) {
#ifdef SDCARD_DEBUG
	printf("CMD12: STOP_TRANSMISSION\n");
#endif
	return sdcard_send_command(sc, 0, 12, SDCARD_CTRL_RESPONSE_SHORT_BUSY);
}

#if 0
static int sdcard_send_status(struct sbusfpga_sd_softc *sc, uint16_t rca) {
#ifdef SDCARD_DEBUG
	printf("CMD13: SEND_STATUS\n");
#endif
	return sdcard_send_command(sc, rca << 16, 13, SDCARD_CTRL_RESPONSE_SHORT);
}
#endif

#if 0
static int sdcard_set_block_count(struct sbusfpga_sd_softc *sc, unsigned int blockcnt) {
#ifdef SDCARD_DEBUG
	printf("CMD23: SET_BLOCK_COUNT\n");
#endif
	return sdcard_send_command(sc, blockcnt, 23, SDCARD_CTRL_RESPONSE_SHORT);
}
#endif

static uint16_t sdcard_decode_rca(struct sbusfpga_sd_softc *sc) {
	uint32_t r[SD_CMD_RESPONSE_SIZE/4];
	csr_rd_buf_uint32(sc, sc->sc_bhregs_sdcore + (CSR_SDCORE_CMD_RESPONSE_ADDR - CSR_SDCORE_BASE), r, SD_CMD_RESPONSE_SIZE/4);
	return (r[3] >> 16) & 0xffff;
}

static void sdcard_decode_cid(struct sbusfpga_sd_softc *sc) {
	uint32_t r[SD_CMD_RESPONSE_SIZE/4];
	csr_rd_buf_uint32(sc, sc->sc_bhregs_sdcore + (CSR_SDCORE_CMD_RESPONSE_ADDR - CSR_SDCORE_BASE), r, SD_CMD_RESPONSE_SIZE/4);
	aprint_normal_dev(sc->dk.sc_dev,
		"CID Register: 0x%08x%08x%08x%08x "
		"Manufacturer ID: 0x%x "
		"Application ID 0x%x "
		"Product name: %c%c%c%c%c "
		"CRC: %02x "
		"Production date(m/yy): %d/%d "
		"PSN: %08x "
		"OID: %c%c\n",
		r[0], r[1], r[2], r[3],
		(r[0] >> 16) & 0xffff,
		r[0] & 0xffff,
		(r[1] >> 24) & 0xff, (r[1] >> 16) & 0xff,
		(r[1] >>  8) & 0xff, (r[1] >>  0) & 0xff, (r[2] >> 24) & 0xff,
		r[3] & 0xff,
		(r[3] >>  8) & 0x0f, (r[3] >> 12) & 0xff,
		(r[3] >> 24) | (r[2] <<  8),
		(r[0] >> 16) & 0xff, (r[0] >>  8) & 0xff
	);
}

static void sdcard_decode_csd(struct sbusfpga_sd_softc *sc) {
	uint32_t r[SD_CMD_RESPONSE_SIZE/4];
	csr_rd_buf_uint32(sc, sc->sc_bhregs_sdcore + (CSR_SDCORE_CMD_RESPONSE_ADDR - CSR_SDCORE_BASE), r, SD_CMD_RESPONSE_SIZE/4);
	/* FIXME: only support CSR structure version 2.0 */
	sc->max_rd_blk_len = (1 << ((r[1] >> 16) & 0xf));
	sc->max_size_in_blk = ((r[2] >> 16) + ((r[1] & 0xff) << 16) + 1) * 512 * 2;
	aprint_normal_dev(sc->dk.sc_dev,
					  "CSD Register: 0x%08x%08x%08x%08x "
					  "Max data transfer rate: %d MB/s "
					  "Max read block length: %d bytes "
					  "Device size: %d GiB (%d blocks)\n",
					  r[0], r[1], r[2], r[3],
					  (r[0] >> 24) & 0xff,
					  sc->max_rd_blk_len,
					  ((r[2] >> 16) + ((r[1] & 0xff) << 16) + 1) * 512 / (1024 * 1024),
					  sc->max_size_in_blk
					  );
}

/*-----------------------------------------------------------------------*/
/* SDCard user functions                                                 */
/*-----------------------------------------------------------------------*/
static int sdcard_init(struct sbusfpga_sd_softc *sc) {
	uint16_t rca, timeout;
	int res;

	/* Set SD clk freq to Initialization frequency */
	sdcard_set_clk_freq(sc, SDCARD_CLK_FREQ_INIT, 0);
	busy_wait(1);

	for (timeout=1000; timeout>0; timeout--) {
		/* Set SDCard in SPI Mode (generate 80 dummy clocks) */
		sdphy_init_initialize_write(sc, 1);
		busy_wait(1);

		/* Set SDCard in Idle state */
		if (sdcard_go_idle(sc) == SD_OK)
			break;
		busy_wait(1);
	}
	if (timeout == 0) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard timeout (1)\n");
		return 0;
	}

	/* Set SDCard voltages, only supported by ver2.00+ SDCards */
	if ((res = sdcard_send_ext_csd(sc)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_send_ext_csd failed\n");
		return 0;
	}

	/* Set SD clk freq to Operational frequency */
	sdcard_set_clk_freq(sc, SDCARD_CLK_FREQ, 0);
	busy_wait(1);

	/* Set SDCard in Operational state */
	for (timeout=1000; timeout>0; timeout--) {
		sdcard_app_cmd(sc, 0);
		if ((res = sdcard_app_send_op_cond(sc, 1)) != SD_OK)
			break;
		busy_wait(1);
	}
	if (timeout == 0) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard timeout (2)\n");
		return 0;
	}

	/* Send identification */
	if ((res = sdcard_all_send_cid(sc)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_all_send_cid failed (%d)\n", res);
		return 0;
	}
	sdcard_decode_cid(sc);
	
	/* Set Relative Card Address (RCA) */
	if ((res = sdcard_set_relative_address(sc)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_set_relative_address failed (%d)\n", res);
		return 0;
	}
	rca = sdcard_decode_rca(sc);
device_printf(sc->dk.sc_dev, "rca is 0x%08x\n", rca);

	/* Set CID */
	if ((res = sdcard_send_cid(sc, rca)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_send_cid failed (%d)\n", res);
		return 0;
	}
#ifdef SDCARD_DEBUG
	/* FIXME: add cid decoding (optional) */
#endif

	/* Set CSD */
	if ((res = sdcard_send_csd(sc, rca)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_send_csd failed (%d)\n", res);
		return 0;
	}
	
	sdcard_decode_csd(sc);

	/* Select card */
	if ((res = sdcard_select_card(sc, rca)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_select_card failed (%d)\n", res);
		return 0;
	}

	/* Set bus width */
	if ((res = sdcard_app_cmd(sc, rca)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_app_cmd failed (%d)\n", res);
		return 0;
	}
	if((res = sdcard_app_set_bus_width(sc)) != SD_OK){
		aprint_error_dev(sc->dk.sc_dev, "sdcard_app_set_bus_width failed (%d)\n", res);
		return 0;
	}

	/* Switch speed */
	if ((res = sdcard_switch(sc, SD_SWITCH_SWITCH, SD_GROUP_ACCESSMODE, SD_SPEED_SDR25)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_switch failed (%d)\n", res);
		return 0;
	}

	/* Send SCR */
	/* FIXME: add scr decoding (optional) */
	if ((res = sdcard_app_cmd(sc, rca)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_app_cmd failed (%d)\n", res);
		return 0;
	}
	if ((res = sdcard_app_send_scr(sc)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_app_send_scr failed (%d)\n", res);
		return 0;
	}

	/* Set block length */
	if ((res = sdcard_app_set_blocklen(sc, 512)) != SD_OK) {
		aprint_error_dev(sc->dk.sc_dev, "sdcard_app_set_blocklen failed (%d)\n", res);
		return 0;
	}

	return 1;
}


static int sdcard_read(struct sbusfpga_sd_softc *sc, uint32_t block, uint32_t count, uint8_t* buf)
{
	const uint32_t counto = count;
	uint64_t ds_addr;
	//device_printf(sc->dk.sc_dev, "%s:%d: block %u count %u buf %p ds_addr %llx\n", __PRETTY_FUNCTION__, __LINE__, block, count, buf, ds_addr);
	
	if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, buf, counto * 512, /* kernel space */ NULL,
						BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_WRITE)) {
		return ENOMEM;
	}

	ds_addr = sc->sc_dmamap->dm_segs[0].ds_addr;
	
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, counto * 512, BUS_DMASYNC_PREWRITE);

   while (count) {
		uint32_t nblocks;
#ifdef SDCARD_CMD18_SUPPORT
		nblocks = count;
#else
		nblocks = 1;
#endif
		/* Initialize DMA Writer */
		sdblock2mem_dma_enable_write(sc, 0);
		sdblock2mem_dma_base_write(sc, ds_addr);
		sdblock2mem_dma_length_write(sc, 512*nblocks);
		sdblock2mem_dma_enable_write(sc, 1);

		/* Read Block(s) from SDCard */
#ifdef SDCARD_CMD23_SUPPORT
		sdcard_set_block_count(sc, nblocks);
#endif
		if (nblocks > 1)
			sdcard_read_multiple_block(sc, block, nblocks);
		else
			sdcard_read_single_block(sc, block);

		int timeout = 64 * nblocks;
		/* Wait for DMA Writer to complete */
		while (((sdblock2mem_dma_done_read(sc) & 0x1) == 0) && timeout) {
			delay(2);
			timeout --;
		}
		if ((sdblock2mem_dma_done_read(sc) & 0x1) == 0) {
			device_printf(sc->dk.sc_dev, "%s: SD card timeout\n", __PRETTY_FUNCTION__);
		}

		/* Stop transmission (Only for multiple block reads) */
		if (nblocks > 1)
			sdcard_stop_transmission(sc);

		/* Update Block/Buffer/Count */
		block += nblocks;
		ds_addr += 512*nblocks;
		count -= nblocks;
	}

   bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, counto * 512, BUS_DMASYNC_POSTWRITE);

   bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);

   return 0;
}

static int sdcard_write(struct sbusfpga_sd_softc *sc, uint32_t block, uint32_t count, uint8_t* buf)
{
	const uint32_t counto = count;
	uint64_t ds_addr;
	//device_printf(sc->dk.sc_dev, "%s: block %u count %u buf %p ds_addr %llx\n", __PRETTY_FUNCTION__, block, count, buf, ds_addr);
	
	if (bus_dmamap_load(sc->sc_dmatag, sc->sc_dmamap, buf, counto * 512, /* kernel space */ NULL,
						BUS_DMA_NOWAIT | BUS_DMA_STREAMING | BUS_DMA_READ)) {
		return ENOMEM;
	}

	ds_addr = sc->sc_dmamap->dm_segs[0].ds_addr;
   
	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, counto * 512, BUS_DMASYNC_PREREAD);
	
	while (count) {
		uint32_t nblocks;
#ifdef SDCARD_CMD25_SUPPORT
		nblocks = count;
#else
		nblocks = 1;
#endif
		/* Initialize DMA Reader */
		sdmem2block_dma_enable_write(sc, 0);
		sdmem2block_dma_base_write(sc, ds_addr);
		sdmem2block_dma_length_write(sc, 512*nblocks);
		sdmem2block_dma_enable_write(sc, 1);

		/* Write Block(s) to SDCard */
#ifdef SDCARD_CMD23_SUPPORT
		sdcard_set_block_count(sc, nblocks);
#endif
		if (nblocks > 1)
			sdcard_write_multiple_block(sc, block, nblocks);
		else
			sdcard_write_single_block(sc, block);

		/* Stop transmission (Only for multiple block writes) */
		sdcard_stop_transmission(sc);

		/* Wait for DMA Reader to complete */
		int timeout = 64 * nblocks;
		while (((sdmem2block_dma_done_read(sc) & 0x1) == 0) && timeout) {
			delay(2);
			timeout --;
		}
		if ((sdmem2block_dma_done_read(sc) & 0x1) == 0) {
			device_printf(sc->dk.sc_dev, "%s: SD card timeout\n", __PRETTY_FUNCTION__);
		}

		/* Update Block/Buffer/Count */
		block += nblocks;
		ds_addr += 512*nblocks;
		count -= nblocks;
	}

	bus_dmamap_sync(sc->sc_dmatag, sc->sc_dmamap, 0, counto * 512, BUS_DMASYNC_POSTREAD);

	bus_dmamap_unload(sc->sc_dmatag, sc->sc_dmamap);

	return 0;
}
